#!/usr/bin/env python3
"""Track foreground CLI conversations and embed their IDs in resurrect saves.

Only hook metadata is read; conversation transcripts and prompts are not stored.
The process identity check prevents an exited/background agent's ID from being
used for a different command in the same pane. No cwd-based session guessing.
"""

import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile


OPTION = "@agent-session"
AGENTS = {"claude": "claude --resume", "codex": "codex resume"}
SESSION_ID = re.compile(r"[a-zA-Z0-9][a-zA-Z0-9_-]{0,127}\Z")


def run(*args):
    return subprocess.check_output(args, text=True, stderr=subprocess.DEVNULL)


def processes():
    result = {}
    # lstart prevents PID reuse from validating an old pane option. These ps
    # fields are available on both macOS and Linux.
    for line in run("ps", "-axo", "pid=,ppid=,pgid=,tpgid=,lstart=,comm=").splitlines():
        fields = line.split(None, 9)
        if len(fields) == 10:
            result[int(fields[0])] = {
                "parent": int(fields[1]),
                "group": int(fields[2]),
                "foreground": int(fields[3]),
                "started": " ".join(fields[4:9]),
                "command": fields[9],
            }
    return result


def agent_name(command):
    name = Path(command).name
    if name in AGENTS:
        return name
    # Claude's native executable can be named after its version.
    if "/claude/versions/" in command:
        return "claude"
    return None


def ancestors(pid, root, table):
    chain = []
    while pid in table and pid not in chain:
        chain.append(pid)
        if pid == root:
            return chain
        pid = table[pid]["parent"]
    return []


def record(agent):
    pane = os.environ.get("TMUX_PANE", "")
    if not os.environ.get("TMUX") or not re.fullmatch(r"%\d+", pane):
        return
    payload = json.load(sys.stdin)
    if payload.get("agent_id") or payload.get("hook_event_name") not in {
        "SessionStart", "UserPromptSubmit"
    }:
        return
    session_id = payload.get("session_id", "")
    cwd = payload.get("cwd", "")
    if not isinstance(session_id, str) or not SESSION_ID.fullmatch(session_id):
        return
    if not isinstance(cwd, str) or not os.path.isabs(cwd) or any(c in cwd for c in "\t\n\r"):
        return
    root = int(run("tmux", "display-message", "-p", "-t", pane, "#{pane_pid}"))
    table = processes()
    chain = ancestors(os.getpid(), root, table)
    owners = [pid for pid in chain if agent_name(table[pid]["command"])]
    # Ignore nested CLIs and hooks from a server that inherited another pane's
    # environment. Those cannot safely identify this pane's foreground session.
    if len(owners) != 1:
        return
    owner = owners[0]
    process = table[owner]
    if agent_name(process["command"]) != agent or process["group"] != table[root]["foreground"]:
        return
    metadata = {
        "agent": agent,
        "session_id": session_id,
        "cwd": cwd,
        "pid": owner,
        "started": process["started"],
    }
    run("tmux", "set-option", "-p", "-t", pane, OPTION, json.dumps(metadata))


def live_session(raw, root, table):
    try:
        metadata = json.loads(raw)
        agent = metadata["agent"]
        pid = metadata["pid"]
        process = table[pid]
        cwd = metadata["cwd"]
        if (
            agent in AGENTS
            and SESSION_ID.fullmatch(metadata["session_id"])
            and isinstance(cwd, str)
            and os.path.isabs(cwd)
            and not any(c in cwd for c in "\t\n\r")
            and process["started"] == metadata["started"]
            and agent_name(process["command"]) == agent
            and ancestors(pid, root, table)
            and process["group"] == table[root]["foreground"]
        ):
            return metadata
    except (KeyError, ValueError, TypeError):
        pass
    return None


def rewrite_snapshot(contents, panes, table):
    lines = []
    for line in contents.splitlines(keepends=True):
        fields = line.rstrip("\n").split("\t")
        if len(fields) == 11 and fields[0] == "pane":
            pane = panes.get((fields[1], fields[2], fields[5]))
            metadata = live_session(pane[1], pane[0], table) if pane else None
            if metadata:
                agent = metadata["agent"]
                # Resurrect's pane reader removes backslash escapes with read.
                fields[7] = ":" + metadata["cwd"].replace("\\", "\\\\").replace(" ", "\\ ")
                fields[9] = agent
                fields[10] = ":" + AGENTS[agent] + " " + metadata["session_id"]
                line = "\t".join(fields) + "\n"
            elif fields[10].startswith((":claude --resume ", ":codex resume ")):
                # Never replay a stale launch ID after /clear or /resume if the
                # hook could not verify the current conversation.
                fields[10] = ":"
                line = "\t".join(fields) + "\n"
        lines.append(line)
    return "".join(lines)


def atomic_write(path, contents):
    with tempfile.NamedTemporaryFile(mode="w", dir=path.parent, delete=False) as stream:
        temporary = Path(stream.name)
        try:
            stream.write(contents)
            stream.flush()
            os.replace(temporary, path)
        finally:
            temporary.unlink(missing_ok=True)


def save(path):
    table = processes()
    fmt = "\t".join([
        "#{session_name}", "#{window_index}", "#{pane_index}",
        "#{pane_pid}", "#{" + OPTION + "}",
    ])
    panes = {}
    for line in run("tmux", "list-panes", "-a", "-F", fmt).splitlines():
        fields = line.split("\t", 4)
        if len(fields) == 5:
            panes[tuple(fields[:3])] = (int(fields[3]), fields[4])
    original = path.read_text()
    updated = rewrite_snapshot(original, panes, table)
    if updated != original:
        atomic_write(path, updated)


def install_hooks(home):
    for agent, path in [
        ("claude", home / ".claude/settings.json"),
        ("codex", home / ".codex/hooks.json"),
    ]:
        # Preserve symlinks and unrelated local settings/hooks.
        path = path.resolve()
        original = path.read_text() if path.exists() else None
        config = json.loads(original) if original else {}
        hooks = config.setdefault("hooks", {})
        command = 'python3 "$HOME/.config/tmux/scripts/agent-sessions.py" record ' + agent
        changed = False
        for event in ("SessionStart", "UserPromptSubmit"):
            groups = hooks.setdefault(event, [])
            if not any(
                handler.get("command") == command
                for group in groups for handler in group.get("hooks", [])
            ):
                groups.append({"hooks": [{"type": "command", "command": command, "timeout": 5}]})
                changed = True
        if changed:
            path.parent.mkdir(parents=True, exist_ok=True)
            backup = path.with_name(path.name + ".before-tmux-agent-sessions")
            if original is not None and not backup.exists():
                with backup.open("x") as stream:
                    os.chmod(backup, 0o600)
                    stream.write(original)
            atomic_write(path, json.dumps(config, indent=2) + "\n")
            print(f"Installed {agent} session hooks: {path}")
    print("In Codex, use /hooks to review and trust the two tmux session hooks.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    recorder = commands.add_parser("record")
    recorder.add_argument("agent", choices=AGENTS)
    saver = commands.add_parser("save")
    saver.add_argument("snapshot", type=Path)
    installer = commands.add_parser("install")
    installer.add_argument("--home", type=Path, default=Path.home())
    args = parser.parse_args()
    try:
        if args.command == "record":
            record(args.agent)
        elif args.command == "save":
            save(args.snapshot)
        else:
            install_hooks(args.home)
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print(f"tmux agent sessions: {error}", file=sys.stderr)
        # Metadata hooks must not block prompts or prevent tmux layout saves.
        return 1 if args.command == "install" else 0
    return 0


if __name__ == "__main__":
    sys.exit(main())

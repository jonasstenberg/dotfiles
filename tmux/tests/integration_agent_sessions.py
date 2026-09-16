"""Exercise real tmux/resurrect with local fake CLIs; no model requests.

Run: python3 tmux/tests/integration_agent_sessions.py
Requires tmux, cc, and the installed tmux-resurrect plugin.
"""

import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import time


ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / ".config/tmux/scripts/agent-sessions.py"
PLUGIN = ROOT / ".config/tmux/plugins/tmux-resurrect"


def wait_for(check):
    deadline = time.monotonic() + 10
    while time.monotonic() < deadline:
        if check():
            return
        time.sleep(0.1)
    raise AssertionError("Timed out waiting for tmux integration check")


def main():
    with tempfile.TemporaryDirectory(prefix="tmux-agent-test-") as directory:
        folder = Path(directory)
        project = folder / "same project"
        project.mkdir()
        source = folder / "agent.c"
        source.write_text(r'''
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
int main(int argc, char **argv) {
    const char *agent = strrchr(argv[0], '/');
    agent = agent ? agent + 1 : argv[0];
    if (argc < 2) return 2;
    const char *id = argv[argc - 1];
    char command[4096], cwd[4096];
    getcwd(cwd, sizeof(cwd));
    snprintf(command, sizeof(command), "python3 \"$TEST_AGENT_SCRIPT\" record %s", agent);
    FILE *hook = popen(command, "w");
    fprintf(hook, "{\"hook_event_name\":\"SessionStart\",\"session_id\":\"%s\",\"cwd\":\"%s\"}", id, cwd);
    if (pclose(hook)) return 3;
    FILE *log = fopen(getenv("TEST_AGENT_LOG"), "a");
    fprintf(log, "%s %s %s\n", agent, id, cwd);
    fclose(log);
    while (getchar() != EOF) {}
    return 0;
}
''')
        subprocess.run(["cc", str(source), "-o", str(folder / "codex")], check=True)
        shutil.copy(folder / "codex", folder / "claude")
        socket = str(folder / "tmux.sock")
        env = dict(os.environ, TEST_AGENT_SCRIPT=str(SCRIPT), TEST_AGENT_LOG=str(folder / "events"))
        env["PATH"] = str(folder) + os.pathsep + env["PATH"]
        env.pop("TMUX", None)
        env.pop("TMUX_PANE", None)

        def tmux(*args):
            return subprocess.check_output(["tmux", "-S", socket, *args], env=env, text=True).strip()

        def configure():
            server_pid = tmux("display-message", "-p", "#{pid}")
            env["TMUX"] = f"{socket},{server_pid},0"
            tmux("set", "-g", "default-shell", "/bin/bash")
            tmux("set", "-g", "default-command", "/bin/bash --noprofile --norc")
            tmux("set", "-g", "@resurrect-dir", str(folder / "saves"))
            tmux("run-shell", str(PLUGIN / "resurrect.tmux"))
            config = folder / "agent.conf"
            settings = [line for line in (ROOT / ".config/tmux/tmux.conf").read_text().splitlines()
                        if line.startswith(("set -g @resurrect-", "set-hook -g client-detached"))]
            config.write_text("\n".join(settings).replace(
                '$HOME/.config/tmux/scripts/agent-sessions.py', str(SCRIPT)) + "\n")
            tmux("source-file", str(config))

        try:
            tmux("-f", "/dev/null", "new-session", "-d", "-s", "work", "-c", str(project),
                 "-x", "160", "-y", "60", "/bin/bash --noprofile --norc")
            configure()
            for _ in range(3):
                tmux("split-window", "-d", "-t", "work", "-c", str(project))
                tmux("select-layout", "-t", "work", "tiled")
            pane_ids = tmux("list-panes", "-t", "work", "-F", "#{pane_id}").splitlines()
            agents = [("codex", "codex-one"), ("codex", "codex-two"),
                      ("claude", "claude-one"), ("claude", "claude-two")]
            for pane, (agent, session_id) in zip(pane_ids, agents):
                tmux("send-keys", "-t", pane, f"{folder / agent} {session_id}", "Enter")
            wait_for(lambda: all(tmux("show-options", "-pqv", "-t", pane, "@agent-session") for pane in pane_ids))
            subprocess.run([str(PLUGIN / "scripts/save.sh"), "quiet"], env=env, check=True)
            snapshot = (folder / "saves/last").read_text()
            for agent, session_id in agents:
                verb = "--resume" if agent == "claude" else "resume"
                assert f":{agent} {verb} {session_id}\n" in snapshot, snapshot

            tmux("kill-server")
            env.pop("TMUX", None)
            wait_for(lambda: not Path(socket).exists() or subprocess.run(
                ["tmux", "-S", socket, "has-session"], env=env,
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode != 0)
            tmux("-f", "/dev/null", "new-session", "-d", "-s", "scratch", "-c", str(project),
                 "-x", "160", "-y", "60", "/bin/bash --noprofile --norc")
            configure()
            # Consume pane IDs to ensure restoration doesn't depend on %pane_id.
            tmux("new-window", "-d", "-t", "scratch")
            tmux("kill-window", "-t", "scratch:1")
            subprocess.run([str(PLUGIN / "scripts/restore.sh")], env=env, check=True,
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            restored_ids = tmux("list-panes", "-t", "work", "-F", "#{pane_id}").splitlines()
            wait_for(lambda: all(tmux("show-options", "-pqv", "-t", pane, "@agent-session") for pane in restored_ids))
            restored = [json.loads(tmux("show-options", "-pqv", "-t", pane, "@agent-session")) for pane in restored_ids]
            assert [(item["agent"], item["session_id"]) for item in restored] == agents, restored
            assert all(Path(item["cwd"]).resolve() == project.resolve() for item in restored), restored
            assert restored_ids != pane_ids
            tmux("set-hook", "-g", "-R", "client-detached")
            wait_for(lambda: (folder / "saves/last").read_text().count(" resume codex-") == 2)
            assert (folder / "saves/last").read_text().count(" resume codex-") == 2
            assert (folder / "saves/last").read_text().count(" --resume claude-") == 2
            print("PASS: four conversations in one project survived save, fresh-server restore, and re-save.")
        finally:
            subprocess.run(["tmux", "-S", socket, "kill-server"], env=env,
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


if __name__ == "__main__":
    main()

import contextlib
import importlib.util
import io
import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch


SCRIPT = Path(__file__).parents[1] / ".config/tmux/scripts/agent-sessions.py"
spec = importlib.util.spec_from_file_location("agent_sessions", SCRIPT)
sessions = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sessions)


def process(parent, group, foreground, command="zsh", started="Mon Sep 14 12:00:00 2026"):
    return dict(parent=parent, group=group, foreground=foreground, command=command, started=started)


def metadata(agent, pid, session_id):
    return json.dumps(dict(agent=agent, pid=pid, session_id=session_id,
                           cwd="/tmp/same project", started="Mon Sep 14 12:00:00 2026"))


def row(pane, command="codex"):
    return f"pane\twork\t1\t1\t:*\t{pane}\ttitle\t:/tmp/same\\ project\t1\t{command}\t:{command}\n"


class AgentSessionsTest(unittest.TestCase):
    def setUp(self):
        self.table = {
            10: process(1, 10, 11), 11: process(10, 11, 11, "codex"),
            20: process(1, 20, 21), 21: process(20, 21, 21, "codex"),
            30: process(1, 30, 31), 31: process(30, 31, 31, "/home/me/.local/share/claude/versions/2.1.272"),
        }
        self.panes = {
            ("work", "1", "1"): (10, metadata("codex", 11, "codex-one")),
            ("work", "1", "2"): (20, metadata("codex", 21, "codex-two")),
            ("work", "1", "3"): (30, metadata("claude", 31, "claude-three")),
        }

    def test_same_directory_distinct_conversations(self):
        snapshot = row(1) + row(2) + row(3, "claude") + "window\tunchanged\n"
        result = sessions.rewrite_snapshot(snapshot, self.panes, self.table)
        self.assertIn(":codex resume codex-one\n", result)
        self.assertIn(":codex resume codex-two\n", result)
        self.assertIn(":claude --resume claude-three\n", result)
        self.assertTrue(result.endswith("window\tunchanged\n"))
        self.assertNotIn("--last", result)
        self.assertNotIn("--continue", result)

    def test_dead_reused_background_and_wrong_pane_processes(self):
        for change in ("dead", "reused", "background", "wrong-pane"):
            with self.subTest(change=change):
                table = {pid: dict(value) for pid, value in self.table.items()}
                if change == "dead":
                    del table[11]
                elif change == "reused":
                    table[11]["started"] = "Tue Sep 15 12:00:00 2026"
                elif change == "background":
                    table[10]["foreground"] = 10
                else:
                    table[11]["parent"] = 20
                self.assertIsNone(sessions.live_session(self.panes[("work", "1", "1")][1], 10, table))

    def test_unverified_resume_is_not_replayed(self):
        result = sessions.rewrite_snapshot(row(1, "codex resume old-id"), {}, self.table)
        self.assertTrue(result.endswith("\t:\n"))

    def test_non_agent_panes_unchanged(self):
        snapshot = row(4, "nvim") + row(5, "zsh")
        self.assertEqual(sessions.rewrite_snapshot(snapshot, self.panes, self.table), snapshot)

    def test_invalid_metadata_and_shell_injection_are_ignored(self):
        raw = self.panes[("work", "1", "1")][1]
        for invalid in ("{", "null", "[]", raw.replace("codex-one", "x;touch /tmp/no"),
                        raw.replace("codex-one", "--last")):
            with self.subTest(invalid=invalid):
                self.assertIsNone(sessions.live_session(invalid, 10, self.table))

    def test_record_uses_hook_session_and_ignores_nested_cli(self):
        table = dict(self.table)
        table[99] = process(11, 11, 11, "python3")
        payload = dict(session_id="new-session", cwd="/tmp/same project", hook_event_name="SessionStart")
        with patch.dict(os.environ, {"TMUX": "/tmp/test,1,0", "TMUX_PANE": "%1"}), \
                patch.object(sessions, "processes", return_value=table), \
                patch.object(sessions.os, "getpid", return_value=99), \
                patch.object(sessions, "run", return_value="10\n") as run:
            with patch.object(sessions.sys, "stdin", io.StringIO(json.dumps(payload))):
                sessions.record("codex")
            self.assertEqual(json.loads(run.call_args.args[-1])["session_id"], "new-session")
            table[98] = process(11, 11, 11, "codex")
            table[99]["parent"] = 98
            run.reset_mock()
            with patch.object(sessions.sys, "stdin", io.StringIO(json.dumps(payload))):
                sessions.record("codex")
            self.assertEqual(run.call_count, 1)  # only pane lookup, no metadata write

    def test_install_preserves_local_settings_and_is_idempotent(self):
        with tempfile.TemporaryDirectory() as directory, contextlib.redirect_stdout(io.StringIO()):
            home = Path(directory)
            config = home / ".claude/settings.json"
            config.parent.mkdir()
            original = '{"model":"local-model","hooks":{"PreToolUse":[{"hooks":[]}]}}'
            config.write_text(original)
            sessions.install_hooks(home)
            first = config.read_text()
            settings = json.loads(first)
            self.assertEqual(settings["model"], "local-model")
            self.assertEqual(settings["hooks"]["PreToolUse"], [{"hooks": []}])
            self.assertEqual(config.with_name(config.name + ".before-tmux-agent-sessions").read_text(), original)
            sessions.install_hooks(home)
            self.assertEqual(config.read_text(), first)
            self.assertEqual(len(settings["hooks"]["SessionStart"]), 1)


if __name__ == "__main__":
    unittest.main()

# Tmux

[Repository setup](../README.md#setup)

Run the commands below from the repository root.

## Conversation restore

Claude Code and Codex CLI conversations are saved by their exact session IDs,
so multiple panes can run separate conversations in the same project. Run
`make stow` to install the configuration and session hooks, or
`make tmux-agent-hooks` if the tmux config is already linked. The installer
merges hooks into local Claude/Codex settings, preserves existing settings,
and backs up existing files with a `.before-tmux-agent-sessions` suffix.

Reload tmux with `Ctrl-a r`. In Codex, open `/hooks` and trust the two tmux
session hooks, then submit a prompt or reopen the conversation so its ID is
recorded. Reopen existing Claude sessions after installing the hooks. Start
new conversations normally with `claude` or `codex`; no wrapper is needed.

- Save: `Ctrl-a Ctrl-s` (also every five minutes through continuum and on detach).
- Save and exit: `Ctrl-a M`, then confirm, or `Ctrl-a :` and `save-and-exit`.
- Restore: `Ctrl-a Ctrl-r` after starting tmux again.
- Check tracking: `Ctrl-a :` and `agent-sessions`.

Use **save-and-exit**, rather than `:kill-server`, when shutting down tmux.
It waits for the save, verifies each running agent's exact resume command in
the snapshot, and only then stops the server. It refuses to exit if an agent
hasn't recorded its ID. A direct `kill-server` does not wait for save-on-detach;
it restores only what was in the last completed save. Tracking a conversation
in a pane is not enough until a save has persisted it.

The saved snapshot contains an explicit `claude --resume <id>` or
`codex resume <id>` command for each tracked foreground agent. Session changes
through `/clear` and `/resume` update the pane's ID. Exited, background, nested,
and untracked agents are not automatically resumed. Existing snapshots need a
new save after the hooks have recorded IDs. Resume restores saved conversation
history; interrupted operations are not preserved. CLI flags are not replayed;
keep persistent preferences in each agent's configuration.

This supports locally running CLIs that expose `SessionStart` and
`UserPromptSubmit` hooks. Remote/shared app servers whose hook processes aren't
descendants of the pane cannot be associated safely and are skipped. Python 3
is required. Codex's hook review is described in the
[official documentation](https://learn.chatgpt.com/docs/hooks#review-and-trust-hooks).

Tests: `python3 -m unittest discover -s tmux/tests`. The optional
`python3 tmux/tests/integration_agent_sessions.py` uses an isolated tmux server
and fake CLIs to check four conversations in one directory across a server
restart. It requires `cc` and the installed resurrect plugin and makes no model
requests.


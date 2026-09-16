# Dotfiles

Shared development environment for macOS and Fedora, managed with GNU Stow.

## Usage

Clone this repository

```sh
git clone git@github.com:jonasstenberg/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

## Setup

### Install packages and shell plugins

On a minimal Fedora installation, install Make first:

```sh
sudo dnf install make
```

Then, on either OS:

```sh
make install
```

### Symlink everything

```sh
make stow
```

`make install` detects macOS or Fedora. macOS packages come from `Brewfile`;
Fedora packages come from the `packages-fedora` target in `Makefile`. Shared
configuration detects the OS at runtime, keeping platform-specific settings
small and close to the setting they affect.

Starship isn't available in Fedora's standard repository, so the Fedora setup
uses Starship's official installer and places the binary in `~/.local/bin`.

Older or situational tools (`ack`, Silver Searcher, and WireGuard tools) are
available separately with `make packages-fedora-optional`.

The repository can live anywhere, but `~/.dotfiles` is the conventional path.
After the first setup, edit the files in the repository and commit the changes
from either machine; Stow's links make them active immediately.

### Optional tools

NVM, pnpm, Bun, Android SDK, Google Cloud SDK, Colima, Antigravity, and OpenCode
are loaded only when their expected files exist. Install these separately when
you need them; missing optional tools won't break a shell session.

### Local overrides

Machine- or job-specific configuration stays out of this repository. Three hook
points are read when present and are otherwise ignored:

| Path                              | Purpose                                                     |
| --------------------------------- | ----------------------------------------------------------- |
| `~/.config/nvim/lua/plugins/local` | Extra lazy.nvim specs and LazyVim extras (gitignored)      |
| `~/.zshrc.plugins`                | Extend the oh-my-zsh `plugins` array before it loads        |
| `~/.zshrc.local`                  | Environment, aliases and completions, sourced last          |

Point them at a separate private repository (for example `~/Development/dotfiles-work`
with absolute symlinks) and that repository can carry its own `Brewfile`.

### Fedora notes

- Set Zsh as the login shell after installation with `chsh -s $(command -v zsh)`.
- The shared Git remote convention is SSH, which works with the 1Password SSH agent.
- Colima and Finder aliases are enabled only on macOS.

## Tmux conversation restore

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
- Restore: `Ctrl-a Ctrl-r` after starting tmux again.

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

## Neovim

The editor config is [LazyVim](https://www.lazyvim.org) with a small set of
overrides in `neovim/.config/nvim/lua/plugins/`. Extras are enabled in
`lua/config/lazy.lua`. Picker, explorer and terminal come from snacks.nvim;
completion from blink.cmp; Claude Code is integrated through the `ai.claudecode`
extra (`<leader>a`). Language servers and formatters are installed by mason on
first launch, so `node` must be on `PATH` (see NVM above).

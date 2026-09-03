# Dotfiles

Personal macOS development environment configuration managed with GNU Stow.

## Structure

Each top-level directory corresponds to a tool and mirrors the home directory structure:
- `zsh/` - Shell configuration (.zshrc, .aliases)
- `tmux/` - Terminal multiplexer config
- `neovim/` - Editor config (stored in .config/nvim)
- `git/` - Git configuration and aliases
- `starship/` - Prompt configuration
- `ghostty/` - Terminal emulator config
- `claude/` - Claude Code settings and agents

## How It Works

Stow creates symlinks from each directory to `$HOME`. For example, `zsh/.zshrc` becomes `~/.zshrc`.

## Neovim

LazyVim-based. `lua/config/lazy.lua` bootstraps lazy.nvim and lists the enabled LazyVim extras;
`lua/plugins/*.lua` hold overrides. Do not re-add plugins LazyVim already ships (snacks picker,
blink.cmp, conform, nvim-lint); override them via `opts` instead. Check the installed LazyVim
source under `~/.local/share/nvim/lazy/LazyVim` before duplicating a default.

## Local Overrides (keep work config out of this repo)

This repository is public. Job-specific config goes in a separate repo linked into these
gitignored/untracked hook points, never committed here:
- `neovim/.config/nvim/lua/plugins/local/` — lazy.nvim specs, may import LazyVim extras
- `~/.zshrc.plugins` — extends the oh-my-zsh `plugins` array
- `~/.zshrc.local` — env, aliases, completions

## Commands

```sh
make install  # Install Homebrew, oh-my-zsh, tmux plugins, and brew dependencies
make stow     # Symlink all configs to $HOME
```

## Working on This Repo

- Test config changes by running `make stow` after edits
- Configs should work on a fresh macOS system after `make install && make stow`
- The Brewfile lists required dependencies

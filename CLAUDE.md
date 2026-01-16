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

## Commands

```sh
make install  # Install Homebrew, oh-my-zsh, tmux plugins, and brew dependencies
make stow     # Symlink all configs to $HOME
```

## Working on This Repo

- Test config changes by running `make stow` after edits
- Configs should work on a fresh macOS system after `make install && make stow`
- The Brewfile lists required dependencies

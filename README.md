# Dotfiles

Shared development environment for macOS and Fedora, managed with GNU Stow.

## Usage

On a minimal Fedora installation, install Git and Make first:

```sh
sudo dnf install git make
```

Clone this repository:

```sh
git clone git@github.com:jonasstenberg/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

## Setup

### Install packages and shell plugins

On either OS:

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

The Fedora setup installs Starship into `~/.local/bin` using its official installer.

On Fedora, `ack`, Silver Searcher, and WireGuard tools are
available separately with `make packages-fedora-optional`.

The repository can live anywhere, but `~/.dotfiles` is the conventional path.
After the first setup, edit the files in the repository and commit the changes
from either machine; Stow's links make them active immediately.

On Fedora, set Zsh as the login shell after installation with
`chsh -s $(command -v zsh)`.

## Tool guides

- [Neovim](neovim/README.md): editor configuration and Markdown preview.
- [Tmux](tmux/README.md): conversation saving, restoration, and session hooks.

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

### Fedora notes

- Set Zsh as the login shell after installation with `chsh -s $(command -v zsh)`.
- The shared Git remote convention is SSH, which works with the 1Password SSH agent.
- Colima and Finder aliases are enabled only on macOS.

## TODO
- [ ] Add DAP

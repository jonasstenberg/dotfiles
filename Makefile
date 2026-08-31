.PHONY: install packages packages-macos packages-fedora packages-fedora-optional bundle stow

OS := $(shell uname -s)

ZSH_CUSTOM ?= $(HOME)/.oh-my-zsh/custom

ifeq ($(OS),Linux)
STARSHIP_TARGET := ~/.local/bin/starship
endif

install: packages $(STARSHIP_TARGET) ~/.oh-my-zsh \
	$(ZSH_CUSTOM)/plugins/zsh-autosuggestions \
	$(ZSH_CUSTOM)/plugins/zsh-syntax-highlighting \
	~/.tmux/plugins/tpm

packages:
ifeq ($(OS),Darwin)
	$(MAKE) packages-macos
else ifeq ($(OS),Linux)
	@if grep -q '^ID=fedora' /etc/os-release; then \
		$(MAKE) packages-fedora; \
	else \
		echo "Unsupported Linux distribution. Install the tools from README.md manually."; \
		exit 1; \
	fi
else
	@echo "Unsupported operating system: $(OS)"; exit 1
endif

packages-macos:
	@command -v brew >/dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle

packages-fedora:
	sudo dnf install -y make zsh git gh stow neovim tmux fzf fd-find ripgrep jq \
		direnv zoxide ShellCheck cmake ninja-build golang luarocks \
		python3-pygments ruby
	mkdir -p ~/.local/bin
	gem install --user-install --bindir ~/.local/bin tmuxinator

packages-fedora-optional:
	sudo dnf install -y ack the_silver_searcher wireguard-tools

~/.local/bin/starship:
	mkdir -p ~/.local/bin
	curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin -y

bundle: packages-macos

~/.oh-my-zsh:
	RUNZSH=no CHSH=no sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

$(ZSH_CUSTOM)/plugins/zsh-autosuggestions: ~/.oh-my-zsh
	git clone https://github.com/zsh-users/zsh-autosuggestions "$@"

$(ZSH_CUSTOM)/plugins/zsh-syntax-highlighting: ~/.oh-my-zsh
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$@"

~/.tmux/plugins/tpm:
	mkdir -p ~/.tmux/plugins
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

stow:
	stow --verbose --target=$$HOME --restow claude ghostty git neovim starship tmux zsh

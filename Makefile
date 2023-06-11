.PHONY: install bundle stow

install: bundle ~/.oh-my-zsh ~/.tmux/plugins/tpm

/opt/homebrew/bin/brew:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \

bundle: /opt/homebrew/bin/brew
	brew bundle

~/.oh-my-zsh:
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \

~/.tmux/plugins/tpm:
	mkdir -p  ~/.tmux/plugins/tpm; \
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \

stow:
	stow --verbose --target=$$HOME --restow */


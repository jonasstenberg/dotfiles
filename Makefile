.PHONY: install bundle stow

install: ~/.oh-my-zsh ~/.tmux/plugins/tpm

~/.oh-my-zsh:
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \

~/.tmux/plugins/tpm:
	mkdir -p  ~/.tmux/plugins/tpm; \
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \

stow:
	stow --verbose --target=$$HOME --restow */


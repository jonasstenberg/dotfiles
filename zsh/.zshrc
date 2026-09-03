export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Prevent oh-my-zsh from automatically setting terminal title
DISABLE_AUTO_TITLE="true"

# update automatically without asking
zstyle ':omz:update' mode auto
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

setopt HIST_IGNORE_ALL_DUPS       # Ignore duplicate entries in history
setopt HIST_FIND_NO_DUPS          # Avoid showing duplicates in completion
setopt INC_APPEND_HISTORY         # Append commands to history immediately
setopt SHARE_HISTORY              # Share history across all sessions
setopt HIST_IGNORE_SPACE          # Ignore commands prefixed with a space

zstyle ':completion:*' completer _expand _complete
autoload -Uz compinit
compinit

plugins=(
    git
    common-aliases
    zsh-syntax-highlighting
    zsh-autosuggestions
)

[[ "$OSTYPE" == darwin* ]] && plugins+=(macos)

# Machine-local plugins (not tracked), e.g. `plugins+=(terraform)` on a work machine
[[ -f "$HOME/.zshrc.plugins" ]] && source "$HOME/.zshrc.plugins"

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

source $HOME/.aliases
source $HOME/.git-aliases

export PATH="$HOME/.local/bin:$PATH"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export NVM_DIR="$HOME/.nvm"
if [[ "$OSTYPE" == darwin* ]]; then
  NVM_HOME="/opt/homebrew/opt/nvm"
else
  NVM_HOME="$HOME/.nvm"
fi
[ -s "$NVM_HOME/nvm.sh" ] && \. "$NVM_HOME/nvm.sh"
[ -s "$NVM_HOME/bash_completion" ] && \. "$NVM_HOME/bash_completion"
[ -s "$NVM_HOME/etc/bash_completion.d/nvm" ] && \. "$NVM_HOME/etc/bash_completion.d/nvm"

command -v starship >/dev/null && eval "$(starship init zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

export ENABLE_TOOL_SEARCH=true

# Machine-local environment, aliases and completions (not tracked)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

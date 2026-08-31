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
    direnv
    common-aliases
    zsh-syntax-highlighting
    zsh-autosuggestions
)

[[ "$OSTYPE" == darwin* ]] && plugins+=(macos)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

source $HOME/.aliases
source $HOME/.git-aliases

# tmuxinator
# -----------------------
_tmuxinator() {
  local commands projects
  commands=(${(f)"$(tmuxinator commands zsh)"})
  projects=(${(f)"$(tmuxinator completions start)"})

  if (( CURRENT == 2 )); then
    _alternative \
      'commands:: _describe -t commands "tmuxinator subcommands" commands' \
      'projects:: _describe -t projects "tmuxinator projects" projects'
  elif (( CURRENT == 3)); then
    case $words[2] in
      copy|debug|delete|open|start)
        _arguments '*:projects:($projects)'
      ;;
    esac
  fi

  return
}

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

command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# pnpm
if [[ "$OSTYPE" == darwin* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

[[ -d /opt/homebrew/opt/postgresql@17/bin ]] && export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

if [[ "$OSTYPE" == darwin* ]]; then
  # Colima (Docker replacement)
  docker_env() {
      export DOCKER_HOST="unix://${HOME}/.colima/$1/docker.sock"
  }
  export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
  export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE="/var/run/docker.sock"
  export TESTCONTAINERS_RYUK_DISABLED=true
fi

command -v starship >/dev/null && eval "$(starship init zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"


# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

export ENABLE_TOOL_SEARCH=true

alias claude-botler='CLAUDE_CONFIG_DIR=~/.claude-botler claude'

if [[ "$OSTYPE" == darwin* ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
else
  export ANDROID_HOME="$HOME/Android/Sdk"
fi
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

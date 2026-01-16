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
    macos
    zsh-syntax-highlighting
    zsh-autosuggestions
)

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

export PATH="/Users/jonasstenberg/.local/bin:$PATH"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jonasstenberg/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jonasstenberg/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jonasstenberg/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jonasstenberg/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

eval "$(direnv hook zsh)"

# pnpm
export PNPM_HOME="/Users/jonasstenberg/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# Colima (Docker replacement)
# See https://github.com/abiosoft/colima
docker_env() {
    export DOCKER_HOST="unix://${HOME}/.colima/$1/docker.sock"
}
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE="/var/run/docker.sock"
# Ryuk testcontainers cleanup doesn't seem to work with Colima socket location yet
export TESTCONTAINERS_RYUK_DISABLED=true

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"


# Added by Antigravity
export PATH="/Users/jonasstenberg/.antigravity/antigravity/bin:$PATH"

# opencode
export PATH=/Users/jonasstenberg/.opencode/bin:$PATH

export ENABLE_TOOL_SEARCH=true

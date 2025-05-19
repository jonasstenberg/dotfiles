export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

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

# plugins
# -----------------------
plugins=(
    common-aliases
    macos
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

# user configs
# -----------------------
# export LANG=en_US.UTF-8
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

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
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="/Users/jonasstenberg/.cargo/bin:$PATH"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

eval "$(ssh-agent -s)"

# export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c/lib/pkgconfig"
# export LDFLAGS="-L/opt/homebrew/opt/icu4c/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/icu4c/include"
# export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"

# Added by Windsurf - Next
export PATH="/Users/jonasstenberg/.codeium/windsurf/bin:$PATH"

# add direnv
eval "$(direnv hook zsh)"

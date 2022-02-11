export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# update automatically without asking
zstyle ':omz:update' mode auto
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# plugins
# -----------------------
plugins=(
    git
    common-aliases
    macos
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

# user configs
# -----------------------
# export LANG=en_US.UTF-8
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

source $HOME/.aliases

# functions
# -----------------------
function ip() {
  ip=$(`echo dig +short myip.opendns.com @resolver1.opendns.com`)
  localip=$(`echo ipconfig getifaddr en0`)
  echo "Public IP: ${ip} >> copied to clipboard
Local IP: ${localip}"
  echo ${ip} | tr -d '\n' | pbcopy
}

# sourcing
# -----------------------
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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

compdef _tmuxinator tmuxinator mux

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

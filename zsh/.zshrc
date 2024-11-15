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
    common-aliases
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

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

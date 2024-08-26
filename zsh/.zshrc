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
source $HOME/.git-aliases
source $HOME/.zshrc.local

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
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/.cargo/bin

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/Users/jonasstenberg/.local/bin:$PATH"
export PATH="/Users/jonasstenberg/.platformio/penv/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/jonasstenberg/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="/opt/homebrew/Cellar/ruby/3.2.2_1/bin:$PATH"

# bun completions
[ -s "/Users/jonasstenberg/.bun/_bun" ] && source "/Users/jonasstenberg/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jonasstenberg/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jonasstenberg/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jonasstenberg/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jonasstenberg/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export PATH=$PATH:$HOME/go/bin

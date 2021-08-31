eval "$(starship init zsh)"

plugins=(git)

# User configuration

source ~/.dotfiles/aliases.sh

# Functions
source ~/.dotfiles/functions/movement.sh
source ~/.dotfiles/functions/kubernetes.sh
source ~/.dotfiles/functions/terraform.sh

#export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Vi keybindings
bindkey -v 
bindkey '^R' history-incremental-search-backward

# Tilix VTE
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh 2>/dev/null
fi

# Programming tools
## Golang
eval `go env`
export GOBIN=${HOME}/go/bin
export PATH=$PATH:$GOBIN

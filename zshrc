eval "$(starship init zsh)"

plugins=(git)

# User configuration

source ~/.dotfiles/aliases

# Functions
source ~/.dotfiles/functions/movement.sh
source ~/.dotfiles/functions/kubernetes.sh
source ~/.dotfiles/functions/terraform.sh

#export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# History
export HISTSIZE=50000
export HISTSIZE=50000
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%d %b %y %T "

# history -w 

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

# SSH Configs
eval $(ssh-agent) && ssh-add ~/.ssh/*id_rsa

# Programming tools
## Golang
eval `go env`
export GOBIN=${HOME}/go/bin
export PATH=$PATH:$GOBIN

## Python
# Import packages to PATH
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "Python PATH not configured"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH=$PATH:${HOME}/Library/Python/3.8/bin
fi

# Cloud tools
## asdf
ASDF_BIN=/usr/local/opt/asdf/libexec/asdf.sh
if [[ -f "ASDF_BIN" ]]; then
  source /usr/local/opt/asdf/libexec/asdf.sh
  source /usr/local/share/zsh/site-functions/_asdf
fi

# Cloud providers
## AWS
if [[ -f "ASDF_BIN" ]]; then
  source /usr/local/share/zsh/site-functions/_aws
fi

# Kubernetes
if [[ -f "ASDF_BIN" ]]; then
  source /usr/local/share/zsh/site-functions/_kubectl
fi


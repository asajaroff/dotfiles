# 
# Alejandro's bashrc
#

# vi mode
set -o vi

# 
# BASH customizations
#
export PATH=$PATH:/usr/local/bin:/opt/bin

# History
export HISTSIZE=50000
export HISTSIZE=50000
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%d %b %y %T "

#
# Aliases
#
source ${HOME}/.dotfiles/aliases

# Functions
source ${HOME}/.dotfiles/private/clone.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Tilix VTE
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh 2>/dev/null
fi

# 
# Programming tools
# 

## Golang
GOBIN=$(which go)
if [[ -e ${GOBIN} ]]; then
  eval `go env`
  export GOBIN=${HOME}/go/bin
  export PATH=$PATH:$GOBIN
fi

## Python

## Node
if [[ -e ${HOME}/.nvm ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

## Rust

# Cloud tools
## asdf
ASDF_BIN=/usr/local/opt/asdf/libexec/asdf.sh
if [[ -f "${ASDF_BIN}" ]]; then
  source /usr/local/opt/asdf/libexec/asdf.sh
fi

# Starship shell
eval "$(starship init bash)"

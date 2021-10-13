# 
# Alejandro's bashrc
#
eval "$(starship init bash)"


# 
# BASH customizations
#
export PATH=$PATH:/usr/local/bin:/opt/bin

# History
export HISTSIZE=50000
export HISTSIZE=50000
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%d %b %y %T "
# vi mode
set -o vi

#
# Aliases
#
source ${HOME}/.dotfiles/aliases
[ -d "${HOME}/.dotfiles/private" ] && . "${HOME}/.dotfiles/private/mhe.aliases"

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

## Rust

# Cloud tools
## asdf
ASDF_BIN=~/.asdf/asdf.sh
if [[ -f "${ASDF_BIN}" ]]; then
  source ${ASDF_BIN}
  . $HOME/.asdf/completions/asdf.bash
fi

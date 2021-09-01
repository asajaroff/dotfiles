# 
# Alejandro's bashrc
#
eval "$(starship init bash)"

# Vi mode
set -o vi

# 
# $PATH additions
#
export PATH=$PATH:/usr/local/bin:/opt/bin

#
# Aliases
#
source ${HOME}/.dotfiles/aliases

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

#
# Languages
#

# Go
# todo: if statement
eval $(go env)

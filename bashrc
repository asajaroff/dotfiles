# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Vi mode
set -o vi

eval "$(starship init bash)"

alias l="ls"
alias ll="ls -lah"
alias repos="cd ${HOME}/Code"

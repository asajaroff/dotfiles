# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Vi mode
set -o vi

# PS1
export PS1="\[\033[38;5;6m\]\w\[$(tput sgr0)\] [\[$(tput sgr0)\]\[\033[38;5;3m\]\t\[$(tput sgr0)\]] \$?\n \[$(tput sgr0)\]\[\033[38;5;11m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"

alias l="ls"
alias ll="ls -lah"
alias repos="cd ${HOME}/Workspace/Repos"
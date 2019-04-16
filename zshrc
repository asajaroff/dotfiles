# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH Theme
ZSH_THEME="bullet-train"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

source ~/.dotfiles/aliases

#export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Vi keybindings
bindkey -v 
bindkey '^R' history-incremental-search-backward

# SSH Keys Import
ssh-add $HOME/.ssh/id_rsa

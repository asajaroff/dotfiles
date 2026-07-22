#!/usr/bin/env bash
# Alejandro's bashrc
#

if [[ -v DOTFILES_DEBUG ]]; then
	echo "Starting bashrc in debug mode"
	export TERM=dumb
	set -x
fi

# vi mode
set -o vi

#
# BASH customizations
#
export PATH=$PATH:/usr/local/bin:/opt/bin
export DOTFILES=${HOME}/.dotfiles

# History
HISTFILE="${HOME}/.bash_history"
export HISTCONTROL=ignoreboth,erasedups
export HISTTIMEFORMAT="%h %d %H:%M:%S "
export HISTIGNORE="ls:ps:history"
export HISTSIZE=10000000
export SAVEHIST=${HISTSIZE}

# Save multi-line commands as a single history entry
shopt -s cmdhist
# Preserve newlines in multi-line history entries
shopt -s lithist

#
# Aliases
#
source ${HOME}/.aliases

#
# Functions
#

# Dotfiles
for f in \
    "${DOTFILES}/src/functions"/*.sh \
    "${DOTFILES}/src/functions"/*.bash \
    "${DOTFILES}/private/een/functions"/*.sh \
    "${DOTFILES}/private/een/functions"/*.bash
do
    # shellcheck disable=SC1090
    [ -f "$f" ] && source "$f"
done

#
# Editor
#

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
  alias vim='nvim'
fi

# Krew
#
if [[ -d ${HOME}/.krew ]]; then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# Starship shell
eval "$(starship init bash)"

# Coloured man pages
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"

source ${DOTFILES}/private/secrets.env

# opencode
export PATH=/home/asajaroff/.opencode/bin:$PATH

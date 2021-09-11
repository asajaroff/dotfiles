.DEFAULT_GOAL=all
.PHONY: all

# 
# Variables
#
OS_ARCH 						:= $(shell arch)
DOTFILES_DIRECTORY 	:= ${HOME}/.dotfiles
GOBIN 							?= $(shell go bin) 

#
# Shell setup
#
shells: shell-requisites bash zsh

shell-requisites:
	mkdir -p /tmp/dotfiles/starship
	curl -fsSL https://starship.rs/install.sh -o /tmp/dotfiles/starship/install.sh
	chmod +x /tmp/dotfiles/starship/install.sh
	sudo /tmp/dotfiles/starship/install.sh -y

bash:
	ln -sf ${HOME}/.dotfiles/bashrc ${HOME}/.bashrc
	ln -sf ${HOME}/.dotfiles/bashrc ${HOME}/.profile

zsh:
	ln -sf ${HOME}/.dotfiles/zshrc ${HOME}/.zshrc

tmux:
	ln -sf ${HOME}/.tmux.conf ${HOME}/.dotfiles/config/tmux.conf

all: test

kubernetes:
ifeq ($(OS_ARCH),darwin)
	KUBERNETES_VERSION := (shell curl -L -s https://dl.k8s.io/release/stable.txt)
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
	xattr -d com.apple.quarantine kubectl
	chmod +x kubectl
	mv kubectl /usr/local/bin/kubectl-$(curl -L -s https://dl.k8s.io/release/stable.txt)
	echo $(KUBERNETES_VERSION)
endif


editor: editor-requisites neovim neovim-plugins

editor-requisites: 
	@echo "To build from sorce, follow this guide: https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites"
	mkdir -p ${HOME}/.vim/swapfiles
	mkdir -p ${HOME}/.vim/backupfiles
	mkdir -p ${HOME}/.config/nvim/

neovim:
	@echo neovim

neovim-plugins:
	sh -c 'curl -fLo "${HOME}/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

clean:
	@echo Cleanup

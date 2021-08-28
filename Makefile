all:
	echo $(OS_ARCH)

## Programming
GOBIN ?= (shell go bin) # Will only occur if GOBIN is not already present


OS_ARCH= (shell )
DOTFILES_DIRECTORY := ${HOME}/.dotfiles

.PHONY: test kubernetes

test:
	echo ${OS_ARCH}

kubernetes:
ifeq ($(OS_ARCH),darwin)
	KUBERNETES_VERSION := (shell curl -L -s https://dl.k8s.io/release/stable.txt)
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
	xattr -d com.apple.quarantine kubectl
	chmod +x kubectl
	mv kubectl /usr/local/bin/kubectl-$(curl -L -s https://dl.k8s.io/release/stable.txt)
	echo $(KUBERNETES_VERSION)
endif

shells: shell-requisites bash zsh

shell-requisites:
	mkdir -p /tmp/dotfiles/starship
	curl -fsSL https://starship.rs/install.sh -o /tmp/dotfiles/starship/install.sh
	chmod +x /tmp/dotfiles/starship/install.sh
	sudo /tmp/dotfiles/starship/install.sh

bash:
	ln -sf ${HOME}/.dotfiles/bashrc ${HOME}/.bashrc
	ln -sf ${HOME}/.dotfiles/bashrc ${HOME}/.profile

zsh:
	ln -sf ${HOME}/.dotfiles/zshrc ${HOME}/.zshrc

editor: editor-requisites neovim neovim-plugins

editor-requisites: 
	@echo "To build from sorce, follow this guide: https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites"

neovim:
	@echo neovim

neovim-plugins:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim



clean:
	@echo Cleanup

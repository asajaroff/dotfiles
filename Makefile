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
	ln -sf ${HOME}/.dotfiles/.bashrc ${HOME}/.bashrc
	ln -sf ${HOME}/.dotfiles/.bashrc ${HOME}/.profile

zsh:
	ln -sf ${HOME}/.dotfiles/.zshrc ${HOME}/.zshrc


clean:
	@echo Cleanup

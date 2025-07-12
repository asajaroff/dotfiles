.DEFAULT_GOAL 	:= help
DOTFILES_DIR	:= ${HOME}/Code/github.com/asajaroff/dotfiles
#OS_ARCH 		:= $(shell arch)
OS_FAMILY		:= $(shell uname)
GOBIN 			?= $(shell go bin) 
.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

# Makefile start
init: git-config git-submodules-private workspace ## Initialize git-submodules


workspace:
	mkdir -p ${HOME}/{Workspace,Code}
	mkdir -p ${HOME}/Downloads
	ln --symbolic ${HOME}/Code ${HOME}/Downloads/Code

update:
ifeq ($(shell uname), Darwin)
	brew update
	brew outdated
	brew upgrade
	brew autoremove
	brew cleanup --prune=all
else ifeq ($(shell uname), Linux)
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt clean
	sudo apt autoremove
else
	@echo "Could not identify host OS: stopping."
endif

git-submodules-private: ## Fetch and pull private git-submodules (requires auth)
ifneq ($(wildcard ${DOTFILES_DIR}/private.),)
	@echo "Found a 'private' directory"
	exit 0
else
	@echo "Did not find a 'private' directory, so let's clone it"
	git submodule update --init --recursive private
endif

git-config: ## Configure git user and email
	git config --global user.name "Alejandro Sajaroff"
	git config --global user.email "29068982+asajaroff@+users.noreply.github.com"

shells: shell-requisites bash zsh tmux ## Setup zsh, bash and tmux configs

shell-requisites: ## Install starship add-on for bash/zsh
	mkdir -p /tmp/dotfiles/starship
	curl -fsSL https://starship.rs/install.sh -o /tmp/dotfiles/starship/install.sh
	chmod +x /tmp/dotfiles/starship/install.sh
	sudo /tmp/dotfiles/starship/install.sh -y
	ln -sf ${DOTFILES_DIR} ~/.config/starship.toml

bash: ## Create bash symlinks to configfiles
	ln -sf ${DOTFILES_DIR} ~/.dotfiles
	ln -sf ${DOTFILES_DIR}/config/bashrc ${HOME}/.bashrc
	ln -sf ${DOTFILES_DIR}/config/profile ${HOME}/.profile

zsh: ## Create zsh symlinks to configfiles
	ln -sf ${DOTFILES_DIR}/config/zshrc ${HOME}/.zshrc

tmux: ## Create tmux symlinks to configfiles
	ln -sf ${DOTFILES_DIR}/config/tmux.conf ${HOME}/.tmux.conf 

kubernetes: ## Install kubectl, kubens, kubectx and helm
ifeq ($(OS_ARCH),darwin)
	KUBERNETES_VERSION := (shell curl -L -s https://dl.k8s.io/release/stable.txt)
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
	xattr -d com.apple.quarantine kubectl
	chmod +x kubectl
	mv kubectl /usr/local/bin/kubectl-$(curl -L -s https://dl.k8s.io/release/stable.txt)
	echo $(KUBERNETES_VERSION)
endif

kubectx:
	sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
	sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
	sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
	sudo pacman -S fzf

#
# aliases
#
aliases: ## Create aliases
	source ~

#
# Programming utils
#

# nvm
nodejs-tooling:  ## Install nodjs tooling (nvm)
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

#
# Ubuntu / Debian
#
ubuntu:
	sudo apt update -y
	sudo apt install -y \
		build-essential \
		dnsutils \
		net-tools \
		netcat-traditional \
		jq yq
	sudo apt clean
	sudo apt autoremove

#
# MacOS
#

macos-base:
	brew install gcc cmake llvm neovim coreutils ed findutils gawk gnu-sed gnu-tar grep make tmux
	brew install --cask rectangle ghostty

een:
	brew install cmctl kubernetes-cli helm kubectx
	brew install --cask zulip openvpn-connect
	brew tap hashicorp/tap
	brew install hashicorp/tap/vault

een-devel:
	brew install qemu docker minikube

emacs:
	ln -sf ${DOTFILES_DIR}/config/emacs/init.el ${HOME}/.emacs
	touch ${HOME}/emacs.custom.el


tenv:
	sudo pacman -Syu cosign
	wget https://github.com/tofuutils/tenv/releases/download/v4.7.6/tenv_v4.7.6_Linux_x86_64.tar.gz
	sudo tar -zxvf tenv_v4.7.6_Linux_x86_64.tar.gz -C /usr/local/bin/

arch-podman:
	sudo pacman -Syu podman

# https://github.com/istio/istio/releases/tag/1.24.2
#


# Istioctl version and platform configuration
ISTIO_VERSION ?= 1.24.2
PLATFORM ?= linux-amd64
INSTALL_DIR = /usr/local/bin

# Derived variables
ISTIOCTL_BINARY = istioctl-$(ISTIO_VERSION)
ISTIOCTL_PATH = $(INSTALL_DIR)/$(ISTIOCTL_BINARY)
ISTIOCTL_SYMLINK = $(INSTALL_DIR)/istioctl

ISTIO_URL = https://github.com/istio/istio/releases/download/$(ISTIO_VERSION)/istioctl-$(ISTIO_VERSION)-$(PLATFORM).tar.gz
TARBALL = istioctl-$(ISTIO_VERSION)-$(PLATFORM).tar.gz

istioctl:
	if [ ! -f "$(TARBALL)" ]; then \
		wget -O "$(TARBALL)" "$(ISTIO_URL)"; \
	else \
		echo "Tarball $(TARBALL) already exists, skipping download."; \
	fi
	tar -xzf "$(TARBALL)" istioctl
	sudo mv istioctl "$(ISTIOCTL_PATH)"
	sudo chmod +x "$(ISTIOCTL_PATH)"
	sudo ln -sf "$(ISTIOCTL_PATH)" "$(ISTIOCTL_SYMLINK)"

bitwarden:
	wget -L https://bitwarden.com/download/?app=cli&platform=linux
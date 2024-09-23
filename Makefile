.DEFAULT_GOAL 	:= help
DOTFILES_DIR	:= ${HOME}/.dotfiles
OS_ARCH 	:= $(shell arch)
OS_FAMILY	:= $(shell uname)
GOBIN 		?= $(shell go bin) 

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
#
# Init
#

init: git-config git-submodules-private ## Initialize git-submodules

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
	git config --global user.email "asajaroff@users.noreply.github.com"

shells: shell-requisites bash zsh tmux ## Setup zsh, bash and tmux configs

shell-requisites: ## Install starship add-on for bash/zsh
	mkdir -p /tmp/dotfiles/starship
	curl -fsSL https://starship.rs/install.sh -o /tmp/dotfiles/starship/install.sh
	chmod +x /tmp/dotfiles/starship/install.sh
	sudo /tmp/dotfiles/starship/install.sh -y

bash: ## Create bash symlinks to configfiles
	ln -sf ${HOME}/.dotfiles/config/bashrc ${HOME}/.bashrc
	ln -sf ${HOME}/.dotfiles/config/bashrc ${HOME}/.profile

zsh: ## Create zsh symlinks to configfiles
	ln -sf ${HOME}/.dotfiles/config/zshrc ${HOME}/.zshrc

tmux: ## Create tmux symlinks to configfiles
	ln -sf ${HOME}/.dotfiles/config/tmux.conf ${HOME}/.tmux.conf 

kubernetes: ## Install kubectl, kubens, kubectx and helm
ifeq ($(OS_ARCH),darwin)
	KUBERNETES_VERSION := (shell curl -L -s https://dl.k8s.io/release/stable.txt)
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
	xattr -d com.apple.quarantine kubectl
	chmod +x kubectl
	mv kubectl /usr/local/bin/kubectl-$(curl -L -s https://dl.k8s.io/release/stable.txt)
	echo $(KUBERNETES_VERSION)
endif


#
# Programming utils
#

# nvm
nodejs: 
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
.DEFAULT_GOAL := help
.PHONY: all
# __   ____ _ _ __ ___
# \ \ / / _` | '__/ __|
#  \ V / (_| | |  \__ \
#   \_/ \__,_|_|  |___/
#
OS_ARCH 	:= $(shell arch)
DOTFILES_DIR	:= ${HOME}/.dotfiles
GOBIN 		?= $(shell go bin) 
ASDF_DIR	:= ${HOME}/.asdf

# Help
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

#      _          _ _
#     | |        | | |
#  ___| |__   ___| | |
# / __| '_ \ / _ \ | |
# \__ \ | | |  __/ | |
# |___/_| |_|\___|_|_|
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


editor: editor-requisites neovim neovim-plugins emacs-dep emacs doom-emacs ## Configure text editor

# ___  ___           _____ _______   __
# |  \/  |          |  _  /  ___\ \ / /
# | .  . | __ _  ___| | | \ `--. \ V / 
# | |\/| |/ _` |/ __| | | |`--. \/   \ 
# | |  | | (_| | (__\ \_/ /\__/ / /^\ \
# \_|  |_/\__,_|\___|\___/\____/\/   \/
macos-install:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                                     

macos-brew-dependencies: ## MacOS 13.X+ - Install basic MacOS utils
	brew install coreutils neovim 
	brew install gcc
	brew install --cask rectangle
	brew install --cask netnewswire
	brew install --cask marta
	brew install --cask vscodium
	brew install --cask bitwarden
	brew install --cask iterm2
	# brew install --cask alfred
	#
macos-upgrade: ##
	brew outdated
	brew upgrade
                                     

#  ___ _ __ ___   __ _  ___ ___
# / _ \ '_ ` _ \ / _` |/ __/ __|
#|  __/ | | | | | (_| | (__\__ \
# \___|_| |_| |_|\__,_|\___|___/
emacs-dep:
	sudo dnf install git ripgrep

emacs:
	@echo sudo apt install emacs # Ubuntu
	@echo brew install emacs
	@echo sudo dnf install emacs

DOOM_DIR := ${HOME}/.doom.d

doom-emacs:
	@if test -d ${DOOM_DIR}; then git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d; ~/.emacs.d/bin/doom install; fi
	ln -sf ${HOME}/.dotfiles/config/emacs/doom.d/config.el ${HOME}/.doom.d/config.el
	ln -sf ${HOME}/.dotfiles/config/emacs/doom.d/init.el ${HOME}/.doom.d/init.el
	ln -sf ${HOME}/.dotfiles/config/emacs/doom.d/packages.el ${HOME}/.doom.d/packages.el
	~/.emacs.d/bin/doom sync

editor-requisites: ## Create vim folders
	@echo "To build from sorce, follow this guide: https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites"
	mkdir -p ${HOME}/.vim/swapfiles
	mkdir -p ${HOME}/.vim/backupfiles
	mkdir -p ${HOME}/.config/nvim/

neovim-plugins: ## Install Plug for neovim
	sh -c 'curl -fLo "${HOME}/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

#               | |/ _|
#   __ _ ___  __| | |_ 
#  / _` / __|/ _` |  _|
# | (_| \__ \ (_| | |  
#  \__,_|___/\__,_|_|  
#
asdf: asdf-setup-plugins asdf-install-packages ## Installs `asdf` utility

asdf-reinstall: asdf-setup-terraform asdf-setup-vault asdf-setup-kubectl

asdf-install:
	@if test -d ${ASDF_DIR}; then echo "asdf is installed at $(ASDF_DIR)"; else git clone https://github.com/asdf-vm/asdf.git $(ASDF_DIR) --branch v0.9.0; fi

asdf-setup-plugins:
	asdf plugin-add boundary https://github.com/asdf-community/asdf-hashicorp.git
	asdf plugin-add consul https://github.com/asdf-community/asdf-hashicorp.git
	asdf plugin-add nomad https://github.com/asdf-community/asdf-hashicorp.git
	asdf plugin-add packer https://github.com/asdf-community/asdf-hashicorp.git
	asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
	asdf plugin-add vault https://github.com/asdf-community/asdf-hashicorp.git
	asdf plugin-add kubectl https://github.com/asdf-community/asdf-kubectl.git

asdf-setup-terraform:
	asdf install terraform latest
	asdf install terraform latest:1.1.
	asdf install terraform 0.14.11
	asdf install terraform latest:0.14.
	asdf global terraform latest

asdf-setup-vault:
	asdf install vault latest
	asdf global vault latest

asdf-setup-kubectl: 
	asdf install kubectl latest
	asdf install kubectl latest:1.22.
	asdf install kubectl latest:1.19.
	asdf install kubectl latest:1.18.
	asdf global kubectl latest

clean: ## Render a destructive statement
	@echo "rm -rf ${DOTFILES_DIR}"

#
# Programming utils
#

# nvm
nodejs: 
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
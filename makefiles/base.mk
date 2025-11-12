# Base variables and utilities
DOTFILES_DIR := ${HOME}/Code/github.com/asajaroff/dotfiles
OS_ARCH := $(shell uname -m)
OS_FAMILY := $(shell uname -s)

# OS detection variables
IS_MACOS := $(shell [ "$(OS_FAMILY)" = "Darwin" ] && echo "true" || echo "false")
IS_ARCH := $(shell [ -f /etc/arch-release ] && echo "true" || echo "false")
IS_DEBIAN := $(shell [ -f /etc/debian_version ] && echo "true" || echo "false")

# Common directories
INSTALL_DIR = /usr/local/bin

.PHONY: help workspace
.ONESHELL:

workspace: ## Creates the Workspace and Code directory
	mkdir -p ${HOME}/{Workspace,Code}
	mkdir -p ${HOME}/Workspace/{log,tmp,daily}
	if [ -L ${HOME}/Workspace/Code ]; then \
		rm ${HOME}/Workspace/Code; \
	elif [ -e ${HOME}/Workspace/Code ]; then \
		echo "Error: ${HOME}/Workspace/Code exists and is not a symlink"; \
		exit 1; \
	fi
	ln -sf ${HOME}/Code ${HOME}/Workspace/Code
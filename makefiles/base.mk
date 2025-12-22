# Base variables and utilities
DOTFILES_DIR := ${PWD}
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
	mkdir -p ${HOME}/Workspace/Code
	ln -sf ${HOME}/Code ${HOME}/Workspace/Code
	mkdir -p ${HOME}/Code/github.com/EENCloud
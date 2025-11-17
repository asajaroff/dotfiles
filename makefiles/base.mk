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

.PHONY: all clean test help workspace

all:
clean:
test:

.ONESHELL:

workspace: ## Creates the Workspace and Code directory
	mkdir -p ${HOME}/Workspace/log ${HOME}/Workspace/tmp
# Base variables and utilities
DOTFILES_DIR := ${HOME}/Code/github.com/asajaroff/dotfiles
OS_ARCH := $(shell uname -m)
OS_FAMILY := $(shell uname -s)
GOBIN ?= $(shell go env GOBIN)

# Common directories
INSTALL_DIR = /usr/local/bin

.PHONY: help workspace
.ONESHELL:

workspace: ## Creates the Workspace and Code directory
	mkdir -p ${HOME}/{Workspace,Code}
	mkdir -p ${HOME}/Workspace/{log,tmp,daily}
	ln --symbolic ${HOME}/Code ${HOME}/Workspace/Code
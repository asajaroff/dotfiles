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

.PHONY: help workspace install-stow
.ONESHELL:

workspace: ## Creates the Workspace and Code directory
	mkdir -p ${HOME}/Workspace/Code
	ln -sf ${HOME}/Code ${HOME}/Workspace/Code
	mkdir -p ${HOME}/Code/github.com/EENCloud

install-stow: ## Install GNU Stow if it isn't already on PATH
	@if command -v stow >/dev/null 2>&1; then \
		echo "stow already installed: $$(stow --version | head -n1)"; \
	elif [ "$(IS_ARCH)" = "true" ]; then \
		sudo pacman -S --needed --noconfirm stow; \
	elif [ "$(IS_DEBIAN)" = "true" ]; then \
		sudo apt-get update && sudo apt-get install -y stow; \
	elif [ "$(IS_MACOS)" = "true" ]; then \
		brew install stow; \
	else \
		echo "Unsupported OS_FAMILY=$(OS_FAMILY): install GNU Stow manually" >&2; \
		exit 1; \
	fi

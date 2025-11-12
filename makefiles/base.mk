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

# Color codes for output
COLOR_RESET := \033[0m
COLOR_INFO := \033[36m
COLOR_SUCCESS := \033[32m
COLOR_ERROR := \033[31m
COLOR_WARNING := \033[33m

# Utility functions for formatted output
define info
	@echo "$(COLOR_INFO)ℹ $(1)$(COLOR_RESET)"
endef

define success
	@echo "$(COLOR_SUCCESS)✓ $(1)$(COLOR_RESET)"
endef

define error
	@echo "$(COLOR_ERROR)✗ $(1)$(COLOR_RESET)"
endef

define warning
	@echo "$(COLOR_WARNING)⚠ $(1)$(COLOR_RESET)"
endef

.PHONY: help workspace
.ONESHELL:

workspace: ## Creates the Workspace and Code directory
	$(call info,Creating workspace directories...)
	mkdir -p ${HOME}/{Workspace,Code}
	mkdir -p ${HOME}/Workspace/{log,tmp,daily}
	@if [ -L ${HOME}/Workspace/Code ]; then \
		rm ${HOME}/Workspace/Code; \
	elif [ -e ${HOME}/Workspace/Code ]; then \
		$(call error,${HOME}/Workspace/Code exists and is not a symlink); \
		exit 1; \
	fi
	ln -sf ${HOME}/Code ${HOME}/Workspace/Code
	$(call success,Workspace directories created successfully)
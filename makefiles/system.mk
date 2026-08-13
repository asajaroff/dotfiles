# System-wide update targets

.PHONY: update dotfiles-update check-deps

check-deps: ## Verify required tools are installed
	@missing=0; \
	for tool in git make tmux starship pre-commit; do \
	    if command -v $$tool >/dev/null 2>&1; then \
	        printf "  \033[32m✓\033[0m %s\n" "$$tool"; \
	    else \
	        printf "  \033[31m✗\033[0m %s (missing)\n" "$$tool"; \
	        missing=$$((missing+1)); \
	    fi; \
	done; \
	if [ $$missing -gt 0 ]; then \
	    echo "$$missing required tool(s) missing — install them before running make targets."; \
	    exit 1; \
	fi


dotfiles-update: ## Pull latest dotfiles + submodules
	git pull --ff-only
	git submodule update --remote --recursive
	@echo "Dotfiles updated. Re-source your shell or run 'make shells' if rc files changed."

update: ## Update system packages
ifeq ($(IS_MACOS),true)
	brew update
	brew outdated
	brew upgrade
	brew autoremove
	brew cleanup --prune=all
else ifeq ($(IS_ARCH),true)
	sudo pacman -Syu
else ifeq ($(IS_DEBIAN),true)
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt clean
	sudo apt autoremove -y
else
	echo "Error: Could not identify host OS"
	exit 1
endif

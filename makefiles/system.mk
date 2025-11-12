# System-wide update targets

.PHONY: update

update: ## Update system packages
ifeq ($(IS_MACOS),true)
	$(call info,Updating macOS packages via Homebrew...)
	brew update
	brew outdated
	brew upgrade
	brew autoremove
	brew cleanup --prune=all
	$(call success,macOS packages updated successfully)
else ifeq ($(IS_ARCH),true)
	$(call info,Updating Arch Linux packages...)
	sudo pacman -Syu
	$(call success,Arch Linux packages updated successfully)
else ifeq ($(IS_DEBIAN),true)
	$(call info,Updating Debian packages...)
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt clean
	sudo apt autoremove -y
	$(call success,Debian packages updated successfully)
else
	$(call error,Could not identify host OS)
	exit 1
endif
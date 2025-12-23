# System-wide update targets

.PHONY: update

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
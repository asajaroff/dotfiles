# System-wide update targets

.PHONY: update

update: ## Update system packages
ifeq ($(OS_FAMILY),Darwin)
	brew update
	brew outdated
	brew upgrade
	brew autoremove
	brew cleanup --prune=all
else ifeq ($(OS_FAMILY),Linux)
	sudo pacman -Syu
# sudo apt update -y
# sudo apt upgrade -y
# sudo apt clean
# sudo apt autoremove
else
	@echo "Could not identify host OS: stopping."
endif
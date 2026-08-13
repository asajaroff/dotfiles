# Arch Linux specific targets

.PHONY: archlinux

archlinux: ## Install Arch Linux packages
	sudo pacman -Syu base-devel jq go bash-completion starship bind

# Arch Linux specific targets

.PHONY: all clean test archlinux

all:
clean:
test:

archlinux: ## Install Arch Linux packages
	sudo pacman -Syu base-devel jq go bash-completion starship bind

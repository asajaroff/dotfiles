# Wayland configuration and tools

.PHONY: wayland wl-clipboard

wayland: wl-clipboard ## Setup Wayland tools

wl-clipboard: ## Install wl-clipboard for Wayland clipboard support
ifeq ($(IS_ARCH),true)
	sudo pacman -S --needed wl-clipboard
else ifeq ($(IS_DEBIAN),true)
	sudo apt install -y wl-clipboard
endif

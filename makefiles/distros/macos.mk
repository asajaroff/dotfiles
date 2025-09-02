# macOS specific targets

.PHONY: macos-base macos-een een-devel

macos-base: ## Install basic macOS packages
	brew install gcc cmake llvm neovim coreutils ed findutils gawk gnu-sed gnu-tar grep make tmux
	brew install --cask rectangle ghostty

macos-een: ## Install EEN-specific macOS packages
	brew install cmctl kubernetes-cli helm kubectx
	brew install --cask zulip openvpn-connect
	brew tap hashicorp/tap
	brew install hashicorp/tap/vault

een-devel: ## Install development tools for EEN
	brew install qemu docker minikube
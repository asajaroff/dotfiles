# System-wide configuration and update targets

.PHONY: update ssh-config

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

ssh-config: ## Setup SSH configuration
	$(call log_info,"Setting up SSH configuration")
	@mkdir -p ${HOME}/.ssh/sockets
	@chmod 700 ${HOME}/.ssh
	$(call symlink,${DOTFILES_DIR}/config/ssh_config,${HOME}/.ssh/config)
	@chmod 600 ${HOME}/.ssh/config
# Shell configuration setup

.PHONY: shells shell-requisites bash zsh tmux

shells: shell-requisites bash zsh tmux ## Setup zsh, bash and tmux configs

shell-requisites: ## Install starship add-on for bash/zsh
	$(call info,Setting up starship configuration...)
	mkdir -p ~/.config
	ln -sf ${DOTFILES_DIR}/config/starship.toml ~/.config/starship.toml
	$(call success,Starship configuration installed)

bash: ## Create bash symlinks to configfiles
	ln -sf ${DOTFILES_DIR} ~/.dotfiles
	ln -sf ${DOTFILES_DIR}/config/bashrc ${HOME}/.bashrc
	ln -sf ${DOTFILES_DIR}/config/profile ${HOME}/.profile

zsh: ## Create zsh symlinks to configfiles
	ln -sf ${DOTFILES_DIR}/config/zshrc ${HOME}/.zshrc

tmux: ## Create tmux symlinks to configfiles
ifeq ($(IS_ARCH),true)
	$(call info,Installing wl-clipboard for Wayland support on Arch...)
	sudo pacman -S --needed wl-clipboard
else ifeq ($(IS_DEBIAN),true)
	$(call info,Installing wl-clipboard for Wayland support on Debian...)
	sudo apt install -y wl-clipboard
else ifeq ($(IS_MACOS),true)
	$(call info,Skipping wl-clipboard on macOS - not needed)
endif
	$(call info,Creating tmux configuration symlink...)
	ln -sf ${DOTFILES_DIR}/config/tmux.conf ${HOME}/.tmux.conf
	$(call success,tmux configuration installed)
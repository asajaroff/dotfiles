# Shell configuration setup

.PHONY: shells shell-requisites bash zsh tmux

shells: shell-requisites bash zsh tmux ## Setup zsh, bash and tmux configs

shell-requisites: ## Install starship add-on for bash/zsh
	mkdir -p ~/.config
	ln -sf ${DOTFILES_DIR}/config/starship.toml ~/.config/starship.toml

bash: ## Create bash symlinks to configfiles
	ln -sf ${DOTFILES_DIR} ~/.dotfiles
	ln -sf ${DOTFILES_DIR}/config/bashrc ${HOME}/.bashrc
	ln -sf ${DOTFILES_DIR}/config/profile ${HOME}/.profile

zsh: ## Create zsh symlinks to configfiles
	ln -sf ${DOTFILES_DIR}/config/zshrc ${HOME}/.zshrc

tmux: ## Create tmux symlinks to configfiles
	ln -sf ${DOTFILES_DIR}/config/tmux.conf ${HOME}/.tmux.conf

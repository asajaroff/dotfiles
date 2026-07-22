# Shell configuration setup

.PHONY: shells bash zsh ssh

shells: bash zsh ## Setup zsh and bash configs

bash: ## Create bash symlinks to configfiles
	ln -sf ${DOTFILES_DIR} ~/.dotfiles
	ln -sf ${DOTFILES_DIR}/config/bashrc ${HOME}/.bashrc
	ln -sf ${DOTFILES_DIR}/config/profile ${HOME}/.profile

zsh: ## Create zsh symlinks to configfiles
	ln -sf ${DOTFILES_DIR}/config/zshrc ${HOME}/.zshrc

ssh: ## Symlink SSH config from private submodule
	mkdir -p ${HOME}/.ssh && chmod 700 ${HOME}/.ssh
	ln -sf ${DOTFILES_DIR}/private/config/ssh/config ${HOME}/.ssh/config

# Shell configuration setup

.PHONY: ssh

ssh: ## Symlink SSH config from private submodule
	mkdir -p ${HOME}/.ssh && chmod 700 ${HOME}/.ssh
	ln -sf ${DOTFILES_DIR}/private/config/ssh/config ${HOME}/.ssh/config

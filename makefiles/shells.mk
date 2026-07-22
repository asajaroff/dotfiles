# Shell configuration setup

.PHONY: ssh

ssh: ## Stow SSH config from the private submodule
	mkdir -p ${HOME}/.ssh && chmod 700 ${HOME}/.ssh
	stow -d ${DOTFILES_DIR}/private/config -t ${HOME}/.ssh ssh

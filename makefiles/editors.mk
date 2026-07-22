# Editor configuration

.PHONY: emacs

emacs: ## Setup emacs configuration
	ln -sf ${DOTFILES_DIR}/config/emacs/init.el ${HOME}/.emacs
	touch ${HOME}/.emacs.custom.el
	emacs -nw --load ${DOTFILES_DIR}/config/emacs/init.el --eval '(kill-emacs)'

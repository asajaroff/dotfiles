# Editor configuration

.PHONY: emacs

emacs: ## Setup emacs configuration
	ln -sf ${DOTFILES_DIR}/config/emacs/init.el ${HOME}/.emacs
	emacs -nw --load ~/.dotfiles/config/emacs/init.el --eval '(kill-emacs)'
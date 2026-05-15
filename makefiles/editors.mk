# Editor configuration

.PHONY: emacs nvim

emacs: ## Setup emacs configuration
	ln -sf ${DOTFILES_DIR}/config/emacs/init.el ${HOME}/.emacs
	touch ${HOME}/.emacs.custom.el
	emacs -nw --load ${DOTFILES_DIR}/config/emacs/init.el --eval '(kill-emacs)'

nvim: ## Create symlink to ${DOTFILES_DIR}/config/nvim
	mkdir -p ~/.config/nvim
	ln -sf ${DOTFILES_DIR}/config/nvim/init.lua ${HOME}/.config/nvim/init.lua
	ln -sf ${DOTFILES_DIR}/config/nvim/lua ${HOME}/.config/nvim/lua

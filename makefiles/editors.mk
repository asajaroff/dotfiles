# Editor configuration

.PHONY: emacs nvim vim

emacs: ## Setup emacs configuration
	ln -sf ${DOTFILES_DIR}/config/emacs/init.el ${HOME}/.emacs
	touch ${HOME}/.emacs.custom.el
	emacs -nw --load ~/.dotfiles/config/emacs/init.el --eval '(kill-emacs)'

nvim: ## Create symlink to ~/.dotfiles/config/neovim/init.lua
	mkdir -p ~/.config/nvim
	ln -sf ${DOTFILES_DIR}/config/nvim/init.lua ${HOME}/.config/nvim/init.lua

vim: ## Create symlink to ~/.dotfiles/config/vim/init.el - TODO
	ln -sf ${DOTFILES_DIR}/config/vimrc ~/.vimrc
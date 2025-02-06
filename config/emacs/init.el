;; init.el <asajaroff>

; Don't write garbage all around my config
(setq custom-file "~/.emacs.custom.el")
(load-file "~/.emacs.custom.el")

; Don't write backups on the same folder
(setq backup-directory-alist `(("." . "~/.emacs-backups")))


;; Saved files and extentions

;; UI

(setq inhibit-startup-message t)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(global-display-line-numbers-mode 1)
(ido-mode 1)
(setq ido-create-new-buffer 'always)
(setq-default confirm-nonexistent-file-or-buffer nil)

;; Evil mode
(evil-mode 1)

;; Custom keybindings

;; Tree-sitter
(load-file "~/Code/github.com/asajaroff/dotfiles/config/emacs/tree-sitter.el")

;; Packages
;(load-file "~/Code/github.com/asajaroff/dotfiles/config/emacs/custom-packages.el")

;; UI
(load-file "~/Code/github.com/asajaroff/dotfiles/config/emacs/ui.el")

;; init.el <asajaroff>

; Don't write garbage all around my config
(setq custom-file "~/.emacs.custom.el")
(load-file "~/.emacs.custom.el")

; Don't write backups on the same folder
(setq backup-directory-alist `(("." . "~/.emacs-backups")))


;; Saved files and extentions
(load-file "~/.dotfiles/config/emacs/files.el")

;; UI

(setq inhibit-startup-message t)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(global-display-line-numbers-mode 1)
(ido-mode 1)
(setq ido-create-new-buffer 'always)
(setq-default confirm-nonexistent-file-or-buffer nil)

;; Packages
(load-file "~/.dotfiles/config/emacs/custom-packages.el")

;; Tree-sitter
(load-file "~/.dotfiles/config/emacs/tree-sitter.el")

;; UI
(load-file "~/.dotfiles/config/emacs/ui.el")

;; Compilation mode configs
(load-file "~/.dotfiles/config/emacs/compilation-mode.el")

;; Files
(load-file "~/.dotfiles/config/emacs/files.el")

;; Custom keybindings

;; Custom variables
(setq vc-follow-symlinks nil) ;; Do not ask stupid questions when opening symlinks
(put 'dired-find-alternate-file 'disabled nil)
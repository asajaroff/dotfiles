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
(if (file-directory-p "~/.emacs.d/evil")
    (progn
      (add-to-list 'load-path "~/.emacs.d/evil")
      (require 'evil)
      (evil-mode 1)
      (message "Evil is enabled"))
  (message "Evil is not enabled"))

;; Custom keybindings

;; MacOS gui configuration
(set-frame-font "Monaco 19" nil t)

;; Tree-sitter
(load-file "~/.dotfiles/config/emacs/tree-sitter.el")

;; Packages
(load-file "~/.dotfiles/config/emacs/custom-packages.el")

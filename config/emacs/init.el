;; init.el <asajaroff>

; Don't write garbage all around my config
(setq custom-file "~/.emacs.custom.el")
(load-file "~/.emacs.custom.el")

; Don't write backups on the same folder
(setq backup-directory-alist `(("." . "~/.emacs-backups")))


;; Saved files and extentions

;; UI
(load-file "~/.dotfiles/config/emacs/ui.el")

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
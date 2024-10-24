(setq inhibit-startup-message t)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
;(global-display-line-numbers-mode

; Dired
(setq insert-directory-program "gls")
(setq dired-listing-switches "--all --group-directories-first")

; Interactive do
(setq ido-everywhere t)
(ido-mode 1)
(setq ido-create-new-buffer 'always)
(setq-default confirm-nonexistent-file-or-buffer nil)

(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (which-key-setup-minibuffer))

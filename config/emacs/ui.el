(setq inhibit-startup-message t)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
;(global-display-line-numbers-mode

; Dired
(setq insert-directory-program "ls")
(setq dired-listing-switches "--all --group-directories-first")

; Interactive do
(setq ido-everywhere t)
(ido-mode 1)
(setq ido-create-new-buffer 'always)
(setq-default confirm-nonexistent-file-or-buffer nil)


;; MacOS gui configuration
(set-frame-font "0xProto Nerd Font Mono 18" nil t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (which-key-setup-minibuffer))

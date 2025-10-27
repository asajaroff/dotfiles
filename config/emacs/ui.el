(setq inhibit-startup-message t)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq visible-bell 0)

;(global-display-line-numbers-mode

;; XWindow
;; Start with Maximized frame
;;(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; Start fullscreen (cross-platf)
;; (add-hook 'window-setup-hook 'toggle-frame-fullscreen t)

; Dired
(setq insert-directory-program "ls")
(setq dired-listing-switches "--all --group-directories-first")

; Interactive do
(setq ido-everywhere t)
(ido-mode 1)
(setq ido-create-new-buffer 'always)
(setq-default confirm-nonexistent-file-or-buffer nil)

;; Fonts
(cond
 ((eq system-type 'windows-nt)
  (progn
    (message "is Microsoft Windows")))
 ((eq system-type 'darwin)
  (progn
    (message "is Mac OS X")
    (set-frame-font "0xProto Nerd Font Mono 15" nil t)
  ))

 ((eq system-type 'gnu/linux)
  (progn
    (message "is Linux")
    ;(set-frame-font "0xProto Nerd Font Mono 15" nil t)))
    ; (set-frame-font "Iosevka Nerd Font Mono 15" nil t)
    (set-frame-font "Iosevka Nerd Font Mono 15" nil t)))
 ((eq system-type 'gnu/kfreebsd)
  (progn
    (message "is BSD")))
 (t
  (progn
    (message "other"))))


(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (which-key-setup-minibuffer))

(load-theme 'misterioso )

; (setq initial-buffer-choice "~/Code/")
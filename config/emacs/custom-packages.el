;; Packages setup
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
             '("melpa-stable" . "https://stable.melpa.org/packages/")
(package-initialize)

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; load evil
(use-package evil
  :ensure t ;; install the evil package if not installed
  :init ;; tweak evil's configuration before loading it
  (setq evil-undo-system 'undo-redo)
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-minibuffer t)
  :config ;; tweak evil after loading it
  (evil-mode)

  ;; example how to map a command in normal mode (called 'normal state' in evil)
  (define-key evil-normal-state-map (kbd ", w") 'evil-window-vsplit))

;; .editorconfig
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;; Line
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; LSP
(use-package company
  :ensure t
  :init
  (global-company-mode))

(use-package emacs
  :hook (rust-mode . eglot-ensure)
  :hook (go-mode . eglot-ensure)
  :hook (typescript-mode . eglot-ensure))

;; Tree-sitter
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; Languages
(use-package markdown-mode
  :ensure t
  :config
  (setq markdown-fontify-code-blocks-natively t))
(use-package go-mode)
(use-package gotest
  :ensure t)
(use-package typescript-mode
  :ensure t)

(use-package yaml
  :ensure t)

(use-package json
  :ensure t)

(use-package hcl-mode
  :ensure t)

(use-package magit
  :ensure t)

(use-package vterm-module
    :ensure t)

(use-package vterm
    :ensure t)

(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools
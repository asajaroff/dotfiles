;; Custom packages
(defun setup-editorconfig-mode()
  (let ((editorconfig-dir "~/.emacs.d/editorconfig"))
    (if (file-directory-p editorconfig-dir)
	(message "editorconfig is not installed.")
      (progn
	(message "Installing editorconfig...")
	(shell-command "git clone --depth 1 https://github.com/editorconfig/editorconfig-emacs.git ~/.emacs.d/editorconfig")
	(message "editorconfig cloned.")))))


;(add-to-list 'load-path "~/.emacs.d/editorconfig")

(require 'editorconfig)
(editorconfig-mode 1)

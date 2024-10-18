(defun check-evil-dir()
  (if (file-directory-p "~/.emacs.d/evil")
    (message "Evil is present")
    (message "Evil is not present")))

(defun setup-evil-mode()
  (let ((evil-dir "~/.emacs.d/evil"))
    (if (file-directory-p evil-dir)
	(message "Evil is not installed.")
      (progn
	(message "Installing Evil...")
	(shell-command "git clone --depth 1 https://github.com/emacs-evil/evil.git ~/.emacs.d/evil")
	(message "Evil cloned.")))))

(check-evil-dir)
(setup-evil-mode)

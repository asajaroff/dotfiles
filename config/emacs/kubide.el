(defun kubectl (args)
  "Execute 'kubectl ARGS', put output in a specific buffer, and select it.
ARGS should be the arguments passed to get (e.g., 'pods', 'nodes -o wide')."
  (interactive "skubectl get: ")
  (let* ((buffer-name (format "*k8s: %s*" args))
         (output-buffer (get-buffer-create buffer-name))
         (command-list (cons "get" (split-string args))))

    (with-current-buffer output-buffer
      (read-only-mode -1)      ;; Ensure we can write to it
      ;(erase-buffer)           ;; Clear old output
      (insert (format "Fetching: kubectl %s...\n\n" (mapconcat 'identity command-list " "))))

    ;; Create the process asynchronously
    (let ((proc (apply 'start-process
                       "k8s-process"
                       output-buffer
                       "kubectl"
                       command-list)))

      ;; Add a sentinel to finalize the buffer when the command finishes
      (set-process-sentinel
       proc
       (lambda (process event)
         (when (memq (process-status process) '(exit signal))
           (let ((buf (process-buffer process)))
             (when (buffer-live-p buf)
               (with-current-buffer buf
                 (goto-char (point-min))
                 ;; Optional: Try to make it look nice
                 (ignore-errors (conf-space-mode))
                 ;; Make read-only so you can quit with 'q' if using special-mode
                 (special-mode))))))))

    ;; Switch to the buffer immediately
    (pop-to-buffer output-buffer)))

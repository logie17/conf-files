(provide 'logan-go-mode)

(require 'go-mode)

(defun go-run-region-locally ()
  "run the selected code as though it is golang code"
  (interactive)
  (let ((tempfile (format "%s.go" (make-temp-file "golang"))))
    (write-region (region-beginning) (region-end) tempfile)
    (compile (format "go run %s" tempfile))))

(defun go-run-file-locally ()
  "run the current file as though it is golang code"
  (interactive)
  (save-some-buffers)
  (compile (format "go run %s" (buffer-file-name))))

(define-derived-mode logan-go-mode go-mode
  "Logan Let's Go!!!"
  (define-key logan-go-mode-map (kbd "C-x r r") 'go-run-region-locally)
  (define-key logan-go-mode-map (kbd "C-x r f") 'go-run-file-locally)
  )

(provide 'logan-go-mode)

(require 'go-mode)
(require 'go-autocomplete)
(require 'auto-complete-config)
(add-hook 'go-mode-hook 'auto-complete-mode)
(ac-config-default)

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
  (define-key go-mode-map (kbd "C-x r c") 'go-test-current-file)
  (define-key go-mode-map (kbd "C-x r t") 'go-test-current-test)
  (define-key go-mode-map (kbd "C-x r p") 'go-test-current-project)
  (define-key go-mode-map (kbd "C-x r b") 'go-test-current-benchmark)
  (define-key go-mode-map (kbd "C-x r x") 'go-run)
  )


(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(require 'package)
(add-to-list 'package-archives
                          '("melpa" . "http://melpa.milkbox.net/packages/") t)
(when (< emacs-major-version 24)
    (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)
(custom-set-variables
'(grep-find-command "find . ! -name '*~' ! -name '.#*' ! -name '#*#' ! -name TAGS ! -name .emacs.desktop ! -path '*/.git/*' ! -path '*/.svn/*' -type f -print0 | xargs -0 -e grep -n "))

(setq inferior-lisp-program "lein repl")

;; cperl mode setup by default
(defalias 'perl-mode 'cperl-mode)
(setq cperl-hairy                      t
      cperl-brace-offset               0
      cperl-extra-newline-before-brace nil
      cperl-close-paren-offset         -2
      cperl-indent-level               2
      cperl-indent-parens-as-block     t
      cperl-electric-keywords          t)

;; tab setup
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq js-indent-level 2)
(setq system-uses-terminfo nil)

;; i think i know lisp
(add-to-list 'load-path "~/.emacs.d/lisp")

;; not sure why i have this
(load "gud")

;; keybindings
(global-set-key (kbd "C-x gg") 'magit-status)

(add-to-list 'load-path (concat (getenv "GOPATH")  "/src/github.com/golang/lint/misc/emacs"))
(require 'golint)
(require 'perlbrew)

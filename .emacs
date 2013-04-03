(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))
(eval-after-load "compile" '(require 'compilation-perl))

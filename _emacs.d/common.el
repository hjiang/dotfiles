(require 'cl)
(require 'saveplace)
(require 'ffap)
(require 'uniquify)
(require 'recentf)

(load "~/.emacs.d/vendor/nxml-mode/rng-auto.el")
(load "~/.emacs.d/vendor/nxhtml/autostart.el")

(setq
 nxhtml-global-minor-mode t
 mumamo-chunk-coloring 'submode-colored
 nxhtml-skip-welcome t
 indent-region-mode t
 rng-nxml-auto-validate-flag nil
 nxml-degraded t)
(add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . eruby-nxhtml-mumamo-mode))

(add-to-list 'load-path "~/.emacs.d/vendor/yasnippet/")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/vendor/yasnippet/snippets/")

(add-to-list 'load-path "~/.emacs.d/vendor/yaml-mode/")
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(add-to-list 'load-path "~/.emacs.d/vendor/")
(require 'whitespace)

(add-to-list 'load-path "~/.emacs.d/vendor/rinari")
(require 'rinari)

(server-start)

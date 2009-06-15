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

(add-to-list 'load-path "~/.emacs.d/vendor/rinari")
(require 'rinari)

;; Language modes
(add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-mode))
(add-to-list 'auto-mode-alist '("\\.cmake\\'" . cmake-mode))
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(autoload 'smarty-mode "smarty-mode" "Smarty Mode" t)
(load-file "~/.emacs.d/thrift.el")
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(setq auto-mode-alist
    (cons '("\\.md" . markdown-mode) auto-mode-alist))

(server-start)

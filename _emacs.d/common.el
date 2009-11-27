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

;; needed by rinari
(add-to-list 'load-path "~/.emacs.d/vendor/jump")

(add-to-list 'load-path "~/.emacs.d/vendor/rinari")
(require 'rinari)

(add-to-list 'load-path "~/.emacs.d/vendor/magit")
(autoload 'magit-status "magit" nil t)

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

;; org-mode
(add-to-list 'load-path "~/.emacs.d/vendor/org-mode/lisp")
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; clojure-mode
(add-to-list 'load-path "~/.emacs.d/vendor/clojure-mode")
(require 'clojure-mode)

;; swank-clojure
(add-to-list 'load-path "~/.emacs.d/vendor/swank-clojure/src/emacs")

(setq swank-clojure-jar-path "~/.clojure/clojure.jar"
      swank-clojure-extra-classpaths
      (list
       "~/.emacs.d/vendor/swank-clojure/src/main/clojure"
       "~/.clojure/clojure-contrib.jar"))

(require 'swank-clojure-autoload)

;; slime
(eval-after-load "slime"
  '(progn (slime-setup '(slime-repl))))

(add-to-list 'load-path "~/.emacs.d/vendor/slime")
(require 'slime)
(slime-setup)

;; auctex
(add-to-list 'load-path "~/.emacs.d/vendor/auctex-11.85")
(add-to-list 'load-path "~/.emacs.d/vendor/auctex-11.85/preview")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

(global-set-key (kbd "M-j") 'fill-sentence)

(server-start)

;; Customization to existing modes.

;; Turn off generating *~ files
(setq make-backup-files nil)

(add-hook 'text-mode-hook '(lambda () (auto-fill-mode 1)))

;; turn on font-lock mode
(global-font-lock-mode t)
;; enable visual feedback on selections
(setq-default transient-mark-mode t)

(when window-system
  ;; enable wheelmouse support by default
  (mwheel-install)
  ;; use extended compound-text coding for X clipboard
  (set-selection-coding-system 'compound-text-with-extensions)
  (tool-bar-mode nil)
  (require 'color-theme)
  (color-theme-initialize)
  (color-theme-gnome2)
  )

(column-number-mode t)
(show-paren-mode t)
(transient-mark-mode t)


;; always end a file with a newline
(setq require-final-newline t)

;; stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

(require 'php-mode)
(require 'ruby-mode)
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)

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

(defadvice switch-to-buffer (before existing-buffer activate compile)
  "When interactive, switch to existing buffers only,
unless given a prefix argument."
  (interactive
   (list (read-buffer "Switch to buffer:"
		      (other-buffer)
		      (null current-prefix-arg)))))

(defadvice switch-to-buffer-other-window
  (before existing-buffer activate compile)
  "When interactive, switch to existing buffers only,
unless given a prefix argument."
  (interactive
   (list (read-buffer "Switch to buffer:"
		      (other-buffer)
		      (null current-prefix-arg)))))

(defadvice switch-to-buffer-other-frame
  (before existing-buffer activate compile)
  "When interactive, switch to existing buffers only,
unless given a prefix argument."
  (interactive
   (list (read-buffer "Switch to buffer:"
		      (other-buffer)
		      (null current-prefix-arg)))))

(setq auto-mode-alist
      (cons '("SConstruct" . python-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("SConscript" . python-mode) auto-mode-alist))

;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(autoload 'groovy-mode "groovy-mode" "Groovy editing mode." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

(setq groovy-indent-level 2)

;; (require 'linum)
;; (linum-mode t)

;; (global-hl-line-mode t)
;; (set-face-background 'hl-line "#333")

;; Color theme
(if window-system
    (progn (require 'color-theme-autoloads "color-theme-autoloads")
	   (color-theme-initialize)
	   (color-theme-clarity)))

(menu-bar-mode nil)

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(smart-split)

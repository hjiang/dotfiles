(setq js2-basic-offset 2)

(setq ruby-indent-level 2)

(setq css-indent-level 4)

(setq-default tab-width 2)

(defun map-filetype (pattern mode)
  "Map from filename patterns to major modes"
  (setq auto-mode-alist (cons `(,pattern . ,mode) auto-mode-alist)))

(map-filetype "\\.less$" 'css-mode)
(map-filetype "\\.js$" 'js2-mode)

;; Make Emacs use "reindent-then-newline-and-indent" when you hit the
;; Enter key so that you don't need to keep using TAB to align
;; yourself when coding.
(global-set-key (kbd "<RET>") 'reindent-then-newline-and-indent)

(defun pretty-js-function ()
  (font-lock-add-keywords
   'nil `(("\\(function *\\)("
           (0 (progn (compose-region (match-beginning 1)
                                     (match-end 1) "ƒ")
                     nil))))))

(defun onyx-html-font-lock ()
  (font-lock-add-keywords nil '(("}}\\|{{" . font-lock-constant-face)))
  (font-lock-add-keywords
   nil '(("#if\\|/if\\|else\\|bindAttr" . font-lock-keyword-face)))
  (font-lock-add-keywords
   nil '(("#collection\\|/collection\\|#view\\|/view" .
          font-lock-keyword-face))))

(defun code-hook ()
  "Customization for writing code"
  (add-hook 'write-file-hooks 'delete-trailing-whitespace t)
  (setq show-trailing-whitespace t)
  (highlight-80+-mode t)
  (setq indent-tabs-mode nil))

(add-hook 'clojure-mode-hook 'code-hook)
(add-hook 'ruby-mode-hook 'code-hook)
(add-hook 'css-mode-hook 'code-hook)
(add-hook 'js2-mode-hook 'pretty-js-function)

(when (require 'rainbow-delimiters nil 'noerror)
  (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode))

(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)
(add-hook 'slime-repl-mode-hook
          '(lambda ()
             (highlight-lines-matching-regexp
              "\s+\\(onyx\\|onycloud\\|onybooks\\|trakr\\)" "hi-green-b")
             (paredit-mode t)))

(setq-default indent-tabs-mode nil)

(setq auto-mode-alist (cons '("\\.[ch]$" . c++-mode)
                            auto-mode-alist)) ; .c,.h in C++ mode

(load-file "${HOME}/code/dotfiles/emacs/puppet-mode.el")
(setq auto-mode-alist (cons '("\\.pp$" . puppet-mode)
                            auto-mode-alist))

(defun hjiang-disallow-tab-indent ()
  "Don't use tabs to indent."
  (setq indent-tabs-mode nil))

(add-hook 'c-mode-common-hook 'code-hook)

(provide 'hjiang-coding-style)

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages
  '(starter-kit starter-kit-lisp starter-kit-bindings clojure-mode
                clojure-test-mode clojure-project-mode color-theme
                zenburn-theme nrepl rainbow-delimiters js2-mode)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
      (package-install p)))

(defun other-window-backward ()
  "Select the previous window."
  (interactive)
  (other-window -1))

(defun indent-buffer ()
  "Indent the whole buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(defun smart-split ()
  "Split the window into 80-column sub-windows, and make sure no window has
   fewer than 80 columns."
  (interactive)
  (defun smart-split-helper (w)
    "Helper function to split a given window into two, the first of which has
    80 columns."
    (if (> (window-width w) 140)
      (let ((w2 (split-window w 82 t)))
        (smart-split-helper w2))))
    (smart-split-helper nil))

(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(defun revert-all-buffers ()
  (interactive)
  (mapc 'revert-buffer (buffer-list)))

(defun fill-sentence ()
  (interactive)
  (save-excursion
    (or (eq (point) (point-max)) (forward-char))
    (forward-sentence -1)
    (indent-relative t)
    (let ((beg (point))
          (ix (string-match "LaTeX" mode-name)))
      (forward-sentence)
      (if (and ix (equal "LaTeX" (substring mode-name ix)))
          (LaTeX-fill-region-as-paragraph beg (point))
        (fill-region-as-paragraph beg (point))))))

(defun map-filetype (pattern mode)
  "Map from filename patterns to major modes"
  (setq auto-mode-alist (cons `(,pattern . ,mode) auto-mode-alist)))

(defun pretty-js-function ()
  (font-lock-add-keywords
   'nil `(("\\(function *\\)("
           (0 (progn (compose-region (match-beginning 1)
                                     (match-end 1) "ƒ")
                     nil))))))

(defun code-hook ()
  "Customization for writing code"
  (add-hook 'write-file-hooks 'delete-trailing-whitespace t)
  (setq show-trailing-whitespace t)
  (highlight-80+-mode t)
  (setq indent-tabs-mode nil))

(setq js2-basic-offset 2)

(setq ruby-indent-level 2)

(setq css-indent-level 4)

(setq-default tab-width 2)

(add-hook 'clojure-mode-hook 'code-hook)
(add-hook 'ruby-mode-hook 'code-hook)
(add-hook 'css-mode-hook 'code-hook)
(add-hook 'js2-mode-hook 'pretty-js-function)
(add-hook 'c-mode-common-hook 'code-hook)

(add-hook 'clojure-mode-hook '(lambda () (paredit-mode t)))
(when (require 'rainbow-delimiters nil 'noerror)
  (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode))

(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)

(setq-default indent-tabs-mode nil)

(setq auto-mode-alist (cons '("\\.[ch]$" . c++-mode)
                            auto-mode-alist)) ; .c,.h in C++ mode

;; For some reason clojure-mode is not automatically loaded by ELPA on
;; Mac
(require 'clojure-mode)

;; Turn off generating *~ files
(setq make-backup-files nil)

;; always end a file with a newline
(setq require-final-newline t)

;; stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

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

(menu-bar-mode -1)
(set-default 'indicate-empty-lines t)

(load-theme 'zenburn t)

;; enable wheelmouse support by default
(mwheel-install)
;; use extended compound-text coding for X clipboard
(set-selection-coding-system 'compound-text-with-extensions)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-set-key "\M-?" 'help-command)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\C-cc" 'comment-region)

;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\M-gg" 'goto-line)
(global-set-key "\C-xp" 'other-window-backward)
(global-set-key "\C-x\C-p" 'other-window-backward)
(global-set-key "\C-x\C-o" 'other-window)

;; Enable eldoc in clojure buffers:
(add-hook 'nrepl-interaction-mode-hook
          'nrepl-turn-on-eldoc-mode)
(add-hook 'nrepl-mode-hook 'paredit-mode)

(when (equal system-type 'darwin)
  (setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
  (push "/usr/local/bin" exec-path))

(smart-split)
(server-start)
(custom-set-variables

 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("71b172ea4aad108801421cc5251edb6c792f3adbaecfa1c52e94e3d99634dee7" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

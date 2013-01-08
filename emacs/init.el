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

(load-file "~/code/dotfiles/emacs/functions.el")
(load-file "~/code/dotfiles/emacs/coding-style.el")

;; For some reason clojure-mode is not automatically loaded by ELPA on
;;Mac
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

;; (if window-system (hjiang-gui-customization))
(load-theme 'zenburn t)

(setq ring-bell-function
      (lambda ()
        (call-process-shell-command "xset led 3; xset -led 3" nil 0 nil)))

;; (set-default-font "Inconsolata-11")
;; (setq default-frame-alist '((font . "Inconsolata-11")))
;; (let ((myfont (if (eq system-type 'darwin) "Inconsolata-15"
;;                     "Inconsolata-11")))
;;       (set-default-font myfont)
;;       (setq default-frame-alist
;;             `((font . ,myfont))))

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

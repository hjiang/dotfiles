(load-file "~/code/dotfiles/emacs/functions.el")
(load-file "~/code/dotfiles/emacs/coding-style.el")
(add-to-list 'load-path "~/code/dotfiles/emacs/eproject")

;; For eproject
(require 'eproject)
(require 'eproject-extras)

(define-project-type rake (generic) (look-for "Rakefile"))
(add-hook 'rake-project-file-visit-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (format "cd %s; rake " (eproject-root)))))

(define-project-type ant (generic) (look-for "build.xml"))
(add-hook 'ant-project-file-visit-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (format "cd %s; ant " (eproject-root)))))

(define-project-type maven (generic) (look-for "pom.xml"))
(add-hook 'maven-project-file-visit-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (format "cd %s; mvn " (eproject-root)))))

(define-project-type lein (generic) (look-for "project.clj"))
(add-hook 'lein-project-file-visit-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (format "cd %s; lein " (eproject-root)))))


;; For some reason clojure-mode is not automatically loaded by ELPA on
;;Mac
(require 'clojure-mode)

;; Android
(add-to-list 'load-path "~/code/dotfiles/emacs/android-mode")
(require 'android-mode)
(custom-set-variables '(android-mode-sdk-dir "/opt/android-sdk"))

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

(if window-system (hjiang-gui-customization))

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

(when (equal system-type 'darwin)
  (setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
  (push "/usr/local/bin" exec-path))

(smart-split)
(server-start)

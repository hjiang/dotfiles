(load-file "~/code/dotfiles/emacs/functions.el")
(load-file "~/code/dotfiles/emacs/coding-style.el")
(if (string= (getenv "IN_GOOGLE") "1")
    (load-file "~/code/dotfiles/emacs/google.el"))

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

(smart-split)

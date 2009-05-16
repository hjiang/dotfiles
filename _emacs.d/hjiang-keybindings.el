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

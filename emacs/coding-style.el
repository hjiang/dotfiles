;; To use, put this in your .emacs:
;;
;;    (load-file "${HOME}/.emacs.d/coding-style.el")
;;
;; There are some optional features in here as well:
;;
;; If you want the RETURN key to go to the next line and space over
;; to the right place, add this to your .emacs right after the load-file:
;;
;;    (add-hook 'c-mode-common-hook 'hjiang-make-newline-indent)
;;
;; Another feature you may find handy is the Auto mode: once editing a
;; file, use C-c C-a to have Emacs automatically do some newlines.
;; (This annoys most people but it's sorta neat to try.  It's really
;; bad when you're *editing* code but it may be useful when writing
;; new code.)  There's also a Hungry mode: C-c C-d to have the
;; backspace key eat up lots of whitespace at a time.  This annoys
;; some people but it's worth a try.  Both keys can be used again
;; to turn the mode off.  You'll see in the modeline C++/a or C++/h when
;; the mode is turned on.
;;
;; Also useful, perhaps, is fill mode.  In theory, when you use M-q,
;; it will word-wrap your comment paragraphs.

(load-file "${HOME}/code/onycloud/tools/emacs/coding-style.el")
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


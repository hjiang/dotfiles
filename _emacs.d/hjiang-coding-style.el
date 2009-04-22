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

;; We'll use 2 everywhere for Python
(setq py-indent-offset 2)

;; Indent for JavaScript
(setq js2-basic-offset 2)

;; Never use tabs, and indent by 4 properly.
(defun hjiang-set-perl-style ()
  (interactive)
  (setq perl-indent-level 4)
  (setq perl-continued-statement-offset 4)
  (setq perl-label-offset -4)
  (setq indent-tabs-mode nil))

(add-hook 'perl-mode-hook 'hjiang-set-perl-style)

(setq ruby-indent-level 2)

(setq thrift-indent-level 4)

(setq auto-mode-alist
      (cons '("\\.[ch]$" . c++-mode) auto-mode-alist)) ; .c,.h files in C++ mode

(defconst hjiang-c-style
  `((c-tab-always-indent . t)
    (c-recognize-knr-p . nil)
    (c-enable-xemacs-performance-kludge-p . t) ; speed up indentation in XEmacs
    (c-basic-offset . 4)
    (c-comment-only-line-offset . 0)
    (c-hanging-braces-alist . (
			       (defun-open after)
			       (defun-close before after)
			       (class-open after)
			       (class-close before after)
			       (inline-open after)
			       (inline-close before after)
			       (block-open after)
			       (block-close . c-snug-do-while)
			       (extern-lang-open after)
			       (extern-lang-close after)
			       (statement-case-open after)
			       (substatement-open after)
			       ))
    (c-hanging-colons-alist . (
			       (case-label)
			       (label after)
			       (access-label after)
			       (member-init-intro before)
			       (inher-intro)
			       ))
    (c-hanging-semi&comma-criteria
     . (c-semi&comma-no-newlines-for-oneline-inliners
	c-semi&comma-inside-parenlist
	c-semi&comma-no-newlines-before-nonblanks))
    (c-indent-comments-syntactically-p . nil)
    (comment-column . 40)
    (c-cleanup-list . (brace-else-brace
		       brace-elseif-brace
		       brace-catch-brace
		       empty-defun-braces
		       defun-close-semi
		       list-close-comma
		       scope-operator))
    (c-offsets-alist . (
			(arglist-intro . ++)
                        (func-decl-cont . ++)
                        (member-init-intro . ++)
                        (inher-intro . ++)
			(comment-intro . 0)
			(arglist-close . c-lineup-arglist)
			(topmost-intro . 0)
			(block-open . 0)
			(inline-open . 0)
			(substatement-open . 0)
                        (statement-cont
                         .
                         (,(when (fboundp 'c-no-indent-after-java-annotations)
                             'c-no-indent-after-java-annotations)
                          ,(when (fboundp 'c-lineup-assignments)
                             'c-lineup-assignments)
                          ++))
			(label . /)
			(case-label . +)
			(statement-case-open . +)
			(statement-case-intro . +) ; case w/o {
			(access-label . /)
			(innamespace . 0)
			))
    )
  "Hong Jiang's C/C++ Programming Style")

(defun hjiang-set-c-style ()
  (interactive)
  (setq indent-tabs-mode nil)
  (c-add-style "hjiang" hjiang-c-style t))

(defun hjiang-make-newline-indent ()
  (interactive)
  (define-key c-mode-base-map "\C-m" 'newline-and-indent)
  (define-key c-mode-base-map [ret] 'newline-and-indent))

;; (add-hook 'c-mode-common-hook 'hjiang-set-c-style)

(defun hjiang-c-mode-common-hook ()
  "Customization for C/C++ mode"
  (hjiang-set-c-style)
  (hjiang-make-newline-indent)
  (add-hook 'write-file-hooks 'delete-trailing-whitespace t)
  (setq show-trailing-whitespace t))

(add-hook 'c-mode-common-hook 'hjiang-c-mode-common-hook)

(setq-default indent-tabs-mode nil)

(add-hook 'c-mode-common-hook 'hjiang-make-newline-indent)

(provide 'hjiang-coding-style)


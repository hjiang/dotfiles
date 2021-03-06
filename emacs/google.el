;; -*- mode: emacs-lisp -*-

(setq automount-dir-prefix "^/\\(home\\)\\|\\(mnt\\)\\|\\(auto\\)")
(load-file "/home/build/public/eng/elisp/google.el")

(setq compile-command "blaze build ")

(require 'p4-google)                ;; g4-annotate, improves find-file-at-point
(require 'compilation-colorization) ;; colorizes output of (i)grep
(require 'rotate-clients)           ;; google-rotate-client
(require 'rotate-among-files)       ;; google-rotate-among-files
;; (require 'googlemenu)               ;; handy Google menu bar
;; (require 'google-java)              ;; fast Java compilation code
(require 'google3)                  ;; magically set paths for compiling google3 code
(require 'gsearch)                  ;; Search the whole Google code base.
(google-setup-tramp)

;; commented out because this doesn't work in China
(require 'p4-files)                 ;; transparent support for Perforce filesystem
(p4-enable-file-name-handler)

(global-set-key "\M-gt" 'google-show-tag-locations-regexp)
(global-set-key "\M-ga" 'google-show-callers)
(global-set-key [f6] 'google-pop-tag)
(global-set-key [f7] 'google-show-matching-tags)
(global-set-key "\M-gs" 'gsearch)
(global-set-key "\M-gc" 'google-compile)

(gsearch-convert-filenames-on)

(setq google-tags-default-mode 'c++-mode)

(setq make-backup-files nil)

(column-number-mode 1)


(setq default-fill-column 78)

(global-font-lock-mode 1)

(setq google-decipher-proto-files t)

;; (setq default-frame-alist
;;     '((font . "-B&H-LucidaTypewriter-Medium-R-Normal-Sans-14-140-*-*-M-*-ISO8859-1")))
;; (setq initial-frame-alist default-frame-alist)

(p4-set-p4-executable "/home/build/static/projects/overlayfs/g4_or_v4.sh")

(defun v4-edit-open-asynchronously ()
  "If the current buffer is already writeable, do nothing.
Otherwise, mark it as writeable, then issue the command  in the background.  This is intended for use when
Perforce is slow and you want to edit a file right away.

WARNING: There is a race condition here.  If you try to save your
changes before  finishes, Perforce may overwrite your changes
on disk.  Simply save again once Perforce is done."
  (interactive)
  (if (not buffer-read-only)
      (message "Buffer is already writeable (file: %s)." buffer-file-name)
    (setq buffer-read-only nil)
    (start-process "g4-edit" "*G4 edit*" (p4-check-p4-executable) "edit" buffer-file-name)))
(define-key p4-prefix-map "e" 'v4-edit-open-asynchronously)

(defun rat-edit ()
  "Just like v4-edit, but for labrats"
  (interactive)
  (if (not buffer-read-only)
      (message "Buffer is already writeable (file: %s)." buffer-file-name)
    (call-process "/home/build/static/projects/labrat/rat" nil nil nil "edit" buffer-file-name)
    (setq buffer-read-only nil)))

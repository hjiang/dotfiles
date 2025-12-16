;;; custom-functions.el --- Custom utility functions -*- lexical-binding: t; -*-

;;; Commentary:
;; This file contains custom utility functions extracted from init.el
;; for better organization and maintainability.

;;; Code:

;;; Editing Utilities

(defun indent-buffer ()
  "Indent the entire buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(defun smart-split ()
  "Split the window into 100-column sub-windows."
  (interactive)
  (cl-labels ((smart-split-helper (w)
                (if (> (window-width w) 180)
                    (let ((w2 (split-window w 100 t)))
                      (smart-split-helper w2)))))
    (smart-split-helper nil)))

;;; Environment and Configuration

(defun load-env-file (file)
  "Read and set envvars from FILE."
  (if (null (file-exists-p file))
      (signal 'file-error
              (list "No envvar file exists." file
                    "See https://github.com/hjiang/envel."))
    (with-temp-buffer
      (insert-file-contents file)
      (when-let (env (read (current-buffer)))
        (let ((tz (getenv-internal "TZ")))
          (setq-default
           process-environment
           (append env (default-value 'process-environment))
           exec-path
           (append (split-string (getenv "PATH") path-separator t)
                   (list exec-directory))
           shell-file-name
           (or (getenv "SHELL")
               (default-value 'shell-file-name)))
          (when-let (newtz (getenv-internal "TZ"))
            (unless (equal tz newtz)
              (set-time-zone-rule newtz))))
        env))))

(defun reload-env (&optional env-file)
  "Reload environment variables from ENV-FILE.
If ENV-FILE is not provided, uses ~/.emacs.d/.local/env.el"
  (interactive)
  (let ((file (or env-file "~/.cache/emacs/env.el")))
    (if (file-readable-p file)
        (progn
          (load-env-file file)
          (message "Environment variables reloaded from %s" file))
      (message "Environment file not found: %s" file))))

(defun setup-custom-file ()
  "Set up and load custom file."
  (setq custom-file "~/.config/emacs/local.el")
  (when (file-readable-p custom-file)
    (load custom-file)))

(defun auto-compile-emacs-lisp-files ()
  "Automatically compile Emacs Lisp files under ~/.emacs.d when saved."
  (when (and buffer-file-name
             (string-suffix-p ".el" buffer-file-name)
             (string-prefix-p (expand-file-name "~/.emacs.d/") buffer-file-name))
    (let ((byte-file (concat buffer-file-name "c")))
      ;; Only compile if .elc doesn't exist or .el is newer
      (when (or (not (file-exists-p byte-file))
                (file-newer-than-file-p buffer-file-name byte-file))
        (condition-case err
            (progn
              (byte-compile-file buffer-file-name)
              (message "Compiled %s" (file-name-nondirectory buffer-file-name)))
          (error
           (message "Failed to compile %s: %s"
                    (file-name-nondirectory buffer-file-name)
                    (error-message-string err))))))))

(defun clean-stale-elc-files (&optional directory)
  "Delete .elc files that are older than their .el counterparts in DIRECTORY.
If DIRECTORY is nil, defaults to ~/.emacs.d/"
  (interactive)
  (let ((dir (or directory (expand-file-name "~/.emacs.d/")))
        (cleaned 0))
    (dolist (file (directory-files-recursively dir "\\.elc$"))
      (let ((el-file (concat (file-name-sans-extension file) ".el")))
        (when (and (file-exists-p el-file)
                   (file-newer-than-file-p el-file file))
          (delete-file file)
          (setq cleaned (1+ cleaned))
          (message "Deleted stale file: %s" (file-name-nondirectory file)))))
    (if (called-interactively-p 'any)
        (message "Cleaned %d stale .elc file%s" cleaned (if (= cleaned 1) "" "s"))
      cleaned)))

;;; UI Setup

(defun cleanup-clutter ()
  "Remove UI clutter (menu bar, tool bar, scroll bar, startup messages)."
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (if (display-graphic-p)
      (scroll-bar-mode -1))
  (setq inhibit-startup-message t
        initial-scratch-message nil))

(defun effective-display-height ()
  (/ (display-pixel-height) (frame-monitor-attribute 'scale-factor)))

(defun adaptive-font-height ()
  (let ((d-height (effective-display-height)))
    (cond
     ((< d-height 1100) 120)
     ((< d-height 1400) 140)
     (t 160))))

(defun adaptive-cjk-font-size ()
  (let ((d-height (effective-display-height)))
    (cond
     ((< d-height 1100) 14)
     ((< d-height 1400) 16)
     (t 18))))

(defun setup-fonts ()
  "Set up fonts for different operating systems."
  ;; Only configure fonts in graphical mode, not in terminal
  (when (display-graphic-p)
    ;; See https://www.emacswiki.org/emacs/SetFonts#h5o-16
    (when (eq system-type 'darwin)
      (set-face-attribute 'default nil :family "FiraCode Nerd Font Mono")
      (set-face-attribute 'default nil :weight 'light)
      (set-face-attribute 'default nil :height (adaptive-font-height)))
    (when (eq system-type 'gnu/linux)
      (set-face-attribute 'default nil :family "FiraCode Nerd Font"
                          :weight 'light
                          :height (adaptive-font-height))
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font (frame-parameter nil 'font)
                          charset
                          (font-spec :family "Noto Sans CJK SC"
                                     :weight 'regular
                                     :size (adaptive-cjk-font-size)))))))

(defun maybe-setup-macos ()
  "Set up macOS-specific configuration."
  (when (eq system-type 'darwin)
    (setq mac-option-modifier 'super
          mac-command-modifier 'meta)
    (pixel-scroll-precision-mode 1)))

;;; Development Tools

(defun setup-tree-sitter ()
  "Set up tree-sitter language grammars and mode mappings."
  (interactive)
  (defvar treesit-language-source-alist)
  (setq treesit-language-source-alist
        '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")
          (c "https://github.com/tree-sitter/tree-sitter-c" "v0.23.6")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript"
                      "master" "typescript/src")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript"
                      "v0.21.4")
          (gdscript "https://github.com/PrestonKnopp/tree-sitter-gdscript"
                    "master" "src")
          (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile"
                      "main" "src")
          (lua "https://github.com/tree-sitter-grammars/tree-sitter-lua")))
  (dolist (lang treesit-language-source-alist)
    (unless (treesit-language-available-p (car lang))
      (condition-case err
          (treesit-install-language-grammar (car lang))
        (error
         (message "Failed to install tree-sitter grammar for %s: %s"
                  (car lang) (error-message-string err))))))
  (setq treesit-load-name-override-list
        '((c++ "libtree-sitter-cpp")))
  (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
  (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
  (add-to-list 'major-mode-remap-alist
               '(c-or-c++-mode . c-or-c++-ts-mode))
  (add-to-list 'major-mode-remap-alist '(js2-mode . js-ts-mode))
  (add-to-list 'major-mode-remap-alist '(gdscript-mode . gdscript-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-ts-mode)))


;;; File Utilities

(defun read-file-or-nil (filename)
  "Read file FILENAME, returning contents as string, or nil if it doesn't exist."
  (condition-case nil
      (with-temp-buffer
        (insert-file-contents filename)
        (buffer-string))
    (file-error nil)))

(provide 'custom-functions)
;;; custom-functions.el ends here

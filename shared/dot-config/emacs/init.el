;; -*- mode: emacs-lisp; lexical-binding: t; -*-
;;; init.el --- Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Personal Emacs configuration using straight.el and use-package.

;;; Code:

;;; ============================================================================
;;; Package Management Bootstrap
;;; ============================================================================

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Suppress byte-compiler warnings for dynamic loading
(declare-function straight-use-package "straight")
(declare-function ansi-color-apply-on-region "ansi-color")

;; Configure use-package with straight.el
(straight-use-package 'use-package)
(require 'use-package)
(defvar straight-use-package-by-default)
(setq straight-use-package-by-default t)

;; Restore performance settings after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            ;; Restore original garbage collection settings
            (setq gc-cons-threshold gc-cons-threshold-original
                  gc-cons-percentage gc-cons-percentage-original)
            ;; Restore file name handlers
            (setq file-name-handler-alist file-name-handler-alist-original)
            ;; Report startup time
            (message "Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;;; ============================================================================
;;; Custom Functions and Local Configuration
;;; ============================================================================

;; Load custom functions
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'custom-functions)

;; Load environment variables if available
(let ((env-file "~/.emacs.d/.local/env.el"))
  (when (file-readable-p env-file)
    (load-env-file env-file)))

;; Load secrets (API keys, tokens, etc.)
(let ((secrets-file "~/.emacs.d/.local/secrets.el"))
  (when (file-readable-p secrets-file)
    (load-file secrets-file)))

;;; ============================================================================
;;; Core Emacs Configuration
;;; ============================================================================

(use-package emacs
  :straight (:type built-in)
  :hook
  (before-save . delete-trailing-whitespace)
  :config
  (cleanup-clutter)
  (setq-default line-spacing 0.2
 	              indicate-empty-lines t
	              indent-tabs-mode nil
	              tab-width 2
                require-final-newline t
                file-preserve-symlinks-on-save t
                fill-column 80)
  (setq global-auto-revert-non-file-buffers t
        visible-bell t
        make-backup-files t
        backup-directory-alist
        `(("." . ,(expand-file-name "backups" user-emacs-directory)))
        backup-by-copying t
        delete-old-versions t
        kept-new-versions 6
        kept-old-versions 2
        version-control t)
  (column-number-mode 1)
  (recentf-mode 1)
  (setq history-length 1000)
  (savehist-mode 1)
  (save-place-mode 1)
  ;; Only affect clean buffers
  (global-auto-revert-mode 1)
  (electric-pair-mode)
  (setup-fonts)
  (setup-tree-sitter)
  (fido-mode)
  (setup-custom-file)
  (maybe-setup-macos)
  (add-to-list 'auto-mode-alist '("\\.hujson\\'" . js-json-mode)))

;;; ============================================================================
;;; Development Tools - LSP & Language Support
;;; ============================================================================

(use-package eglot
  :straight nil
  :hook ((c++-ts-mode . (lambda ()
                          (eglot-ensure)
                          (setq-local electric-indent-chars
                                      (remq ?\n electric-indent-chars))))
         (erlang-mode . eglot-ensure)
         (go-mode . eglot-ensure)))

(use-package flycheck
  :straight t
  :init (global-flycheck-mode)
  :hook (c++-ts-mode . (lambda ()
                         (setq-local flycheck-clang-language-standard "c++20")))
  :config
  (setq flycheck-emacs-lisp-load-path 'inherit))


(use-package apheleia
  :straight t
  :defer t
  :hook (prog-mode . apheleia-mode)
  :config
  ;; Configure formatters for different languages
  (setf (alist-get 'python-mode apheleia-mode-alist) 'black)
  (setf (alist-get 'rust-mode apheleia-mode-alist) 'rustfmt)
  (setf (alist-get 'go-mode apheleia-mode-alist) 'gofmt)
  (setf (alist-get 'c-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'c++-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'c-ts-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'c++-ts-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'js-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'typescript-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'elixir-ts-mode apheleia-mode-alist) 'mix-format))

;; Language-specific modes and tools
(use-package yaml-mode
  :straight t
  :defer t)

(use-package toml-mode
  :straight t
  :defer t)

(use-package ansible
  :straight t
  :defer t
  :hook (yaml-mode . ansible-mode))

(use-package bazel
  :straight t
  :defer t)

(use-package markdown-mode
  :straight t
  :defer t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "pandoc")
  :bind (:map markdown-mode-map
              ("C-c C-e" . markdown-do)))

(use-package cmake-mode
  :straight t)

(use-package clojure-mode
  :straight t)

(use-package erlang
  :straight t)

(use-package zig-mode
  :straight t)

(use-package platformio-mode
  :straight t
  :hook (c++-ts-mode . (lambda ()
                         (platformio-conditionally-enable))))

(use-package gdscript-mode
  :straight (gdscript-mode
             :type git
             :host github
             :repo "godotengine/emacs-gdscript-mode"))

(use-package go-mode
  :straight t)

(use-package elixir-ts-mode
  :straight (:type built-in)
  :defer t)

(use-package lua-ts-mode
  :straight (:type built-in)
  :defer t
  :mode (("\\.lua\\'" . lua-ts-mode)))

(use-package dockerfile-ts-mode
  :straight (:type built-in)
  :defer t
  :mode (("\\Dockerfile\\'" . dockerfile-ts-mode)
         ("\\.dockerignore\\'" . dockerfile-ts-mode)))

(use-package alchemist
  :straight t)

(use-package sly
  :straight t
  :config
  (setq inferior-lisp-program "sbcl"))

;;; ============================================================================
;;; UI & Editing Enhancement
;;; ============================================================================

(use-package company
  :straight t
  :defer t
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)
              ("TAB" . company-complete-common-or-cycle)
              ("M-/" . company-complete))
  :config
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2
        company-show-quick-access t
        company-tooltip-align-annotations t
        company-backends '((company-capf company-dabbrev-code)
                           company-dabbrev)))

(use-package company-box
  :straight t
  :defer t
  :hook (company-mode . company-box-mode)
  :config
  (setq company-box-icons-alist 'company-box-icons-all-the-icons))

(use-package which-key
  :straight t
  :defer t
  :init
  (which-key-mode 1))

(use-package yasnippet
  :straight t
  :defer t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :straight t
  :defer t
  :after yasnippet)

(use-package auto-yasnippet
  :straight t
  :defer t
  :bind (("C-c & w" . aya-create)
         ("C-c & y" . aya-expand)))

;;; ============================================================================
;;; Productivity Tools - Window Management & Navigation
;;; ============================================================================

(use-package ace-window
  :straight t
  :defer t
  :bind ("C-x o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
        aw-background t))

(use-package winner
  :straight (:type built-in)
  :config
  (winner-mode 1))

(use-package windmove
  :straight (:type built-in)
  :bind (("C-S-<left>" . windmove-left)
         ("C-S-<right>" . windmove-right)
         ("C-S-<up>" . windmove-up)
         ("C-S-<down>" . windmove-down)))

(use-package treemacs
  :straight t
  :defer t
  :bind (("C-x t t" . treemacs)
         ("C-x t s" . treemacs-select-window)
         ("C-x t d" . treemacs-select-directory))
  :config
  (setq treemacs-width 30
        treemacs-follow-mode t
        treemacs-filewatch-mode t))

(use-package treemacs-projectile
  :straight t
  :defer t
  :after (treemacs projectile))

(use-package treemacs-magit
  :straight t
  :defer t
  :after (treemacs magit))

(use-package deadgrep
  :straight t
  :defer t
  :bind ("C-c s" . deadgrep)
  :config
  (setq deadgrep-max-buffers 4))

(use-package multiple-cursors
  :straight t
  :defer t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

(use-package undo-tree
  :straight t
  :defer t
  :bind ("C-x u" . undo-tree-visualize)
  :config
  (setq undo-tree-auto-save-history t
        undo-tree-history-directory-alist
        `(("." . ,(expand-file-name "undo-tree" user-emacs-directory))))
  (global-undo-tree-mode))

;;; ============================================================================
;;; Org Mode & Knowledge Management
;;; ============================================================================

(use-package org
  :straight t
  :init
  (setq org-directory "~/org")
  (when (file-directory-p (expand-file-name "~/org/agenda"))
    (setq org-agenda-files '("~/org/agenda")))
  :config
  (setq org-adapt-indentation 'headline-data
        org-hide-leading-stars t)
  ;; (defun my-org-export-filter-cjk-spaces (text backend info)
  ;;   "Remove unwanted spaces between CJK characters."
  ;;   (when (org-export-derived-backend-p backend 'html 'latex 'odt)
  ;;     (replace-regexp-in-string "\\(\\cc\\) \\(\\cc\\)" "\\1\\2" text)))
  ;; (add-to-list 'org-export-filter-paragraph-functions
  ;;              'my-org-export-filter-cjk-spaces)
  )

(use-package org-modern
  :straight t
  :defer t
  :hook
  (org-mode . org-modern-mode))

(use-package visual-fill-column
  :straight t
  :defer t
  :hook
  ((org-mode . visual-line-mode)
   (org-mode . visual-fill-column-mode)
   (markdown-mode . visual-line-mode)
   (markdown-mode . visual-fill-column-mode)))

(use-package ox-hugo
  :straight t
  :defer t
  :after ox)

(use-package org-preview-html
  :straight t
  :defer t)

;;; ============================================================================
;;; Themes & Visual Appearance
;;; ============================================================================

(use-package color-theme-sanityinc-tomorrow
  :straight t
  :config
  (load-theme 'sanityinc-tomorrow-night :no-confirm))

(use-package ligature
  :straight t
  :defer t
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia and Fira Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode
                          '(;; == === ==== => =| =>>=>=|=>==>> ==< =/=//=// =~
                            ;; =:= =!=
                            ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                            ;; ;; ;;;
                            (";" (rx (+ ";")))
                            ;; && &&&
                            ("&" (rx (+ "&")))
                            ;; !! !!! !. !: !!. != !== !~
                            ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                            ;; ?? ??? ?:  ?=  ?.
                            ("?" (rx (or ":" "=" "\." (+ "?"))))
                            ;; %% %%%
                            ("%" (rx (+ "%")))
                            ;; |> ||> |||> ||||> |] |} || ||| |-> ||-||
                            ;; |->>-||-<<-| |- |== ||=||
                            ;; |==>>==<<==<=>==//==/=!==:===>
                            ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                            "-" "=" ))))
                            ;; \\ \\\ \/
                            ("\\" (rx (or "/" (+ "\\"))))
                            ;; ++ +++ ++++ +>
                            ("+" (rx (or ">" (+ "+"))))
                            ;; :: ::: :::: :> :< := :// ::=
                            (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                            ;; // /// //// /\ /* /> /===:===!=//===>>==>==/
                            ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                            "="))))
                            ;; .. ... .... .= .- .? ..= ..<
                            ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                            ;; -- --- ---- -~ -> ->> -| -|->-->>->--<<-|
                            ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                            ;; *> */ *)  ** *** ****
                            ("*" (rx (or ">" "/" ")" (+ "*"))))
                            ;; www wwww
                            ("w" (rx (+ "w")))
                            ;; <> <!-- <|> <: <~ <~> <~~ <+ <* <$ </  <+> <*>
                            ;; <$> </> <|  <||  <||| <|||| <- <-| <-<<-|-> <->>
                            ;; <<-> <= <=> <<==<<==>=|=>==/==//=!==:=>
                            ;; << <<< <<<<
                            ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                            "-"  "/" "|" "="))))
                            ;; >: >- >>- >--|-> >>-|-> >= >== >>== >=|=:=>>
                            ;; >> >>> >>>>
                            (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                            ;; #: #= #! #( #? #[ #{ #_ #_( ## ### #####
                            ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
                                         (+ "#"))))
                            ;; ~~ ~~~ ~=  ~-  ~@ ~> ~~>
                            ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                            ;; __ ___ ____ _|_ __|____|_
                            ("_" (rx (+ (or "_" "|"))))
                            ;; Fira code: 0xFF 0x12
                            ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                            ;; Fira code:
                            "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                            ;; The few not covered by the regexps.
                            "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(use-package doom-modeline
  :straight t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25
        doom-modeline-bar-width 3
        doom-modeline-project-detection 'projectile
        doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t))

(use-package all-the-icons
  :straight t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :straight t
  :defer t
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package colorful-mode
  :straight t
  :defer t
  :hook (prog-mode . colorful-mode))

(use-package dashboard
  :straight t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-show-shortcuts nil
        dashboard-items '((recents . 5)
                          (projects . 5)
                          (agenda . 5))
        dashboard-set-heading-icons t
        dashboard-set-file-icons t))

(use-package centaur-tabs
  :straight t
  :defer t
  :bind (("C-<prior>" . centaur-tabs-backward)
         ("C-<next>" . centaur-tabs-forward))
  :config
  (centaur-tabs-mode t)
  (setq centaur-tabs-style "bar"
        centaur-tabs-height 32
        centaur-tabs-set-icons t
        centaur-tabs-set-modified-marker t
        centaur-tabs-modified-marker "●"
        centaur-tabs-show-new-tab-button nil))

;;; ============================================================================
;;; Quality of Life Improvements
;;; ============================================================================

(use-package super-save
  :straight t
  :defer t
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t
        super-save-idle-duration 5
        super-save-remote-files nil))

;;; ============================================================================
;;; Completion & Search
;;; ============================================================================

(use-package vertico
  :straight t
  :init
  (vertico-mode))

(use-package prescient
  :straight t
  :init
  (add-to-list 'completion-styles 'prescient))

(use-package vertico-prescient
  :straight t
  :init
  (vertico-prescient-mode))

(use-package consult
  :straight t
  :bind (("C-x b" . consult-buffer)
         ("M-g g" . consult-goto-line)))

(use-package marginalia
  :straight t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;;; ============================================================================
;;; File Viewers & Readers
;;; ============================================================================

(use-package nov
  :straight t
  :defer t
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;;; ============================================================================
;;; AI & Development Assistance
;;; ============================================================================

(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("dist" "*.el"))
  :defer t
  :bind (:map copilot-completion-map
              ("C-<return>" . copilot-accept-completion-by-line)
              ("M-C-<return>" . copilot-accept-completion)
              ("C-g" . copilot-clear-overlay))
  :config
  ;; Install copilot server if not present and npm is available
  (when (not (file-exists-p (expand-file-name "~/.emacs.d/.cache/copilot/bin/copilot-language-server")))
    (if (executable-find "npm")
        (progn
          (message "Copilot language server not found. Installing...")
          (copilot-install-server)
          (message "Copilot language server installation complete. Restart Emacs to activate."))
      (message "Copilot language server not found, but npm is not available. Skipping installation.")))


  ;; Only enable the hook if the server is already installed
  (when (file-exists-p (expand-file-name "~/.emacs.d/.cache/copilot/bin/copilot-language-server"))
    (add-hook 'prog-mode-hook #'copilot-mode))

  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2))
  (add-to-list 'copilot-indentation-alist '(ld-script-mode 2))
  (add-to-list 'copilot-indentation-alist '(elixir-ts-mode 2))
  (add-to-list 'copilot-indentation-alist '(go-mode 2))
  (add-to-list 'copilot-indentation-alist '(dockerfile-ts-mode 4)))

;;; ============================================================================
;;; Version Control & Project Management
;;; ============================================================================

(use-package magit
  :straight t
  :defer t
  :commands (magit-status magit-log magit-diff magit-blame))

(use-package projectile
  :straight t
  :defer t
  :hook (prog-mode . projectile-mode)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map))
  :commands (projectile-find-file projectile-switch-project))

;;; ============================================================================
;;; Terminal & System Integration
;;; ============================================================================

(use-package ansi-color
  :straight t
  :defer t
  :hook (compilation-filter . ansi-color-compilation-filter))

(use-package vterm
  :straight t
  :defer t)

(use-package direnv
  :straight t
  :defer t
  :commands (direnv-mode direnv-update-environment)
  :config
  (direnv-mode))

(use-package claude-code
  :straight (:type git :host github :repo "stevemolitor/claude-code.el" :branch "main" :depth 1
                   :files ("*.el" (:exclude "images/*")))
  :defer t
  :bind-keymap
  ("C-c c" . claude-code-command-map)
  :commands (claude-code-mode)
  :config
  (setq claude-code-terminal-backend 'vterm)
  (claude-code-mode))

(if (boundp 'jh-slack-token)
    (use-package slack
      :bind (("C-c S K" . slack-stop)
             ("C-c S c" . slack-select-rooms)
             ("C-c S u" . slack-select-unread-rooms)
             ("C-c S U" . slack-user-select)
             ("C-c S s" . slack-search-from-messages)
             ("C-c S J" . slack-jump-to-browser)
             ("C-c S j" . slack-jump-to-app)
             ("C-c S e" . slack-insert-emoji)
             ("C-c S E" . slack-message-edit)
             ("C-c S r" . slack-message-add-reaction)
             ("C-c S t" . slack-thread-show-or-create)
             ("C-c S g" . slack-message-redisplay)
             ("C-c S G" . slack-conversations-list-update-quick)
             ("C-c S q" . slack-quote-and-reply)
             ("C-c S Q" . slack-quote-and-reply-with-link)
             (:map slack-mode-map
                   (("@" . slack-message-embed-mention)
                    ("#" . slack-message-embed-channel)))
             (:map slack-thread-message-buffer-mode-map
                   (("C-c '" . slack-message-write-another-buffer)
                    ("@" . slack-message-embed-mention)
                    ("#" . slack-message-embed-channel)))
             (:map slack-message-buffer-mode-map
                   (("C-c '" . slack-message-write-another-buffer)))
             (:map slack-message-compose-buffer-mode-map
                   (("C-c '" . slack-message-send-from-buffer)))
             )
      :custom
      (slack-extra-subscribed-channels (mapcar 'intern (list "eng")))
      :config
      (slack-register-team
       :name "emq-inc"
       :token jh-slack-token
       :cookie jh-slack-cookie
       :full-and-display-names t
       :default t
       :subscribed-channels nil ;; using slack-extra-subscribed-channels because I can change it dynamically
       )))

(use-package alert
  :commands (alert)
  :init
  (setq alert-default-style 'notifier))

;; Colorize compilation buffers
(if (>= emacs-major-version 28)
    (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
  (progn
    (defvar compilation-filter-start)
    (defun colorize-compilation-buffer ()
      (let ((inhibit-read-only t))
        (ansi-color-apply-on-region compilation-filter-start (point))))
    (add-hook 'compilation-filter-hook 'colorize-compilation-buffer)))

(require 'server)
(unless (server-running-p)
  (server-start))

(provide 'init)
;;; init.el ends here

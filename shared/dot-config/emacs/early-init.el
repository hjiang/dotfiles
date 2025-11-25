;; -*- mode: emacs-lisp; lexical-binding: t; -*-

;; Disable package.el in favor of straight.el
(setq package-enable-at-startup nil)

;; Performance optimizations for startup
;; Save original GC values for restoration after startup
(defvar gc-cons-threshold-original gc-cons-threshold)
(defvar gc-cons-percentage-original gc-cons-percentage)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

;; Temporarily disable file name handlers during startup
(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Native compilation optimizations
(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors 'silent
        native-comp-async-jobs-number 8
        native-comp-deferred-compilation t
        native-comp-jit-compilation t))

;; Increase read-process-output-max for better LSP performance
(setq read-process-output-max (* 1024 1024)) ; 1MB

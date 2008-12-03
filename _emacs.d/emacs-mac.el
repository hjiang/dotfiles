(setq default-frame-alist
    '((font . "Bitstream Vera Sans Mono-12")))

(require 'hjiang-coding-style)
(add-hook 'c-mode-common-hook 'hjiang-make-newline-indent)

(require 'color-theme)
(color-theme-initialize)

(if window-system
 (progn
  (color-theme-gnome2))
 (progn
   (color-theme-clarity)))

(column-number-mode t)
(font-lock-mode t)

(require 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
                ("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))

(load-file "hjiang-keybindings.el")
(load-file "hjiang-customization.el")
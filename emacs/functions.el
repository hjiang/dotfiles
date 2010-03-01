(defun other-window-backward ()
  "Select the previous window."
  (interactive)
  (other-window -1))

(defun indent-buffer ()
  "Indent the whole buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(defun smart-split ()
  "Split the window into 80-column sub-windows, and make sure no window has
   fewer than 80 columns."
  (interactive)
  (defun smart-split-helper (w)
    "Helper function to split a given window into two, the first of which has
    80 columns."
    (if (> (window-width w) (* 2 81))
      (let ((w2 (split-window w 82 t)))
        (smart-split-helper w2))))
    (smart-split-helper nil))

(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(defun revert-all-buffers ()
  (interactive)
  (mapc 'revert-buffer (buffer-list)))

(defun hjiang-gui-customization ()
  "Run the GUI customization stuff"
  (interactive)
  (progn (require 'color-theme-autoloads "color-theme-autoloads")
         (color-theme-initialize)
         (color-theme-clarity)
         (global-hl-line-mode t)
         (set-face-background 'hl-line "#333")
         ;; enable wheelmouse support by default
         (mwheel-install)
         ;; use extended compound-text coding for X clipboard
         (set-selection-coding-system 'compound-text-with-extensions)
         (tool-bar-mode -1)
         (scroll-bar-mode -1)
         (setq default-frame-alist
               '((font . "Monospace-12")))))

(defun fill-sentence ()
  (interactive)
  (save-excursion
    (or (eq (point) (point-max)) (forward-char))
    (forward-sentence -1)
    (indent-relative t)
    (let ((beg (point))
          (ix (string-match "LaTeX" mode-name)))
      (forward-sentence)
      (if (and ix (equal "LaTeX" (substring mode-name ix)))
          (LaTeX-fill-region-as-paragraph beg (point))
        (fill-region-as-paragraph beg (point))))))
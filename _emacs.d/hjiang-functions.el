(defun other-window-backward ()
  "Select the previous window."
  (interactive)
  (other-window -1))

(defun indent-buffer ()
  "Indent the whole buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

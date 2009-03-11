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
    (if (> (window-width w) (* 2 82))
	(let ((w2 (split-window w 83 t)))
	  (smart-split-helper w2))))
  (smart-split-helper nil))

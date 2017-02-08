(require 'calfw)
(require 'calfw-org)
(require 'calfw-cal)

(setq calendar-christian-all-holidays-flag t)

(setq org-capture-use-agenda-date t)

(setq cfw:org-overwrite-default-keybinding t)

(defun org-calfw-here (&optional arg)
  "Open calfw on the file of the present buffer."
  (interactive "P")
  (when (and (buffer-file-name) (eq major-mode 'org-mode))
    (if arg
        (setq org-agenda-files (list (buffer-file-name)))
      (add-to-list 'org-agenda-files (buffer-file-name))))
  ;; (org-log-here (buffer-file-name) t)
  (cfw:open-org-calendar))

(defun cfw:org-capture (prefix)
  "Overwrite original to run own cfw:org-capture-at-date instead."
  (interactive "P")
  (cfw:org-journal-at-date prefix))

(defun cfw:org-journal-at-date (prefix)
  "Run org-journal-new-entry with ORG-OVERRIDING-DEFAULT-TIME from cursor."
  (interactive "P")
  (with-current-buffer  (get-buffer-create cfw:calendar-buffer-name)
    (let* ((pos (cfw:cursor-to-nearest-date))
           (org-overriding-default-time
            (encode-time 0 0 7
                         (calendar-extract-day pos)
                         (calendar-extract-month pos)
                         (calendar-extract-year pos))))
      (org-journal-new-entry prefix org-overriding-default-time)
      (unless prefix (org-insert-time-stamp org-overriding-default-time t)))))

(defun cfw:org-journal-entry-for-now (prefix)
  "Run org-journal-new-entry with date+time timestamp from current time."
  (interactive "P")
  (with-current-buffer  (get-buffer-create cfw:calendar-buffer-name)
    (let* ((pos (cfw:cursor-to-nearest-date))
           (org-overriding-default-time (apply 'encode-time (decode-time))
            ;; (encode-time 0 0 7
            ;;              (calendar-extract-day pos)
            ;;              (calendar-extract-month pos)
            ;;              (calendar-extract-year pos))
            ))
      (org-journal-new-entry prefix org-overriding-default-time)
      (org-insert-time-stamp org-overriding-default-time t))))

(global-set-key (kbd "C-c c c") 'org-calfw-here)
(global-set-key (kbd "C-c C J") 'cfw:org-journal-entry-for-now)

(provide '018_calfw)
;;; 018_calfw.el ends here

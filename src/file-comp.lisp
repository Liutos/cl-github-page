(defpackage :cl-github-page.file-comp
  (:use :cl)
  (:nicknames :file-comp)
  (:import-from :local-time
		:timestamp>
		:universal-to-timestamp)
  (:export :file-mtime>
	   :file-date-string))

(in-package :cl-github-page.file-comp)

(defun file-mtime (file)
  (universal-to-timestamp (file-write-date file)))

(defun file-mtime> (file1 file2)
  (timestamp> (file-mtime file1) (file-mtime file2)))

(defun file-date-string (file)
  (multiple-value-bind (sec min hour date mon year)
      (decode-universal-time (file-write-date file))
    (declare (ignore sec min hour))
    (format nil "~D年~2D月~2D日"
	    year mon date)))
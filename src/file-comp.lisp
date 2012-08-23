(defpackage :cl-github-page.file-comp
  (:use :cl)
  (:import-from :local-time
		:universal-to-timestamp
		:timestamp>)
  (:export :file-mtime>
	   :file-date-string))

(in-package :cl-github-page.file-comp)

(defun file-mtime (file)
  (universal-to-timestamp (file-write-date file)))

(defun file-mtime> (file1 file2)
  (local-time:timestamp> (file-mtime file1) (file-mtime file2)))

(defun file-date-string (file)
  (multiple-value-bind (sec min hour date mon year)
      (decode-universal-time (file-write-date file))
    (declare (ignore sec))
    (format nil "~D-~2,'0D-~2,'0D ~2,'0D:~2,'0D"
	    year mon date hour min)))
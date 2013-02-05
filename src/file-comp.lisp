(defpackage :cl-github-page.file-comp
  (:use :cl)
  (:nicknames :file-comp)
  (:import-from :local-time
		:timestamp>
		:universal-to-timestamp)
  (:export #:last-modified>
           #:file-date-string))

(in-package :cl-github-page.file-comp)

(defun last-modified (pathspec)
  (universal-to-timestamp (file-write-date pathspec)))

(defun last-modified> (file-a file-b)
  (timestamp> (last-modified file-a) (last-modified file-b)))

(defun file-date-string (file)
  (multiple-value-bind (sec min hour date mon year)
      (decode-universal-time (file-write-date file))
    (declare (ignore sec min hour))
    (format nil "~D年~2D月~2D日"
	    year mon date)))

(defpackage :cl-github-page.path
  (:use :cl)
  (:nicknames :path)
  (:export :get-suffix-path
	   :chtype))

(in-package :path)

;;; get-suffix-path :: pathname -> pathname -> string
(defun get-suffix-path (path prefix)
  (subseq (namestring path)
	  (length (namestring prefix))))

;;; chtype :: pathname -> string -> string
(defun chtype (filespec obj-type)
  (format nil "~A.~A"
	  (subseq filespec 0 (position #\. (namestring filespec) :from-end t))
	  obj-type))
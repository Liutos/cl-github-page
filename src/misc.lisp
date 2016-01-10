(in-package :cl-github-page)

(defvar *about-me*)
(defvar *about-me-src*)
(defvar *about-me-tmpl*)
(defvar *atom*)
(defvar *atom-tmpl*)
(defvar *blog-dir*)
(defvar *blog-title*)
(defvar *blog-title-tmpl*)
(defvar *friends*)
(defvar *index*)
(defvar *index-tmpl*)
(defvar *posts-date*)
(defvar *post-tmpl*)
(defvar *posts-dir*)
(defvar *sources-dir*)
(defvar *tags*)

(defmacro with-cache (var val)
  `(or ,var
       (setf ,var ,val)))

(defun cl-github-page-dir ()
  (asdf:system-source-directory
   (asdf:find-system 'cl-github-page)))

(defun write-file-by-tmpl (target-file tmpl-file datum)
  (with-open-file (s target-file
		     :direction :output
		     :if-exists :supersede)
    (let ((*default-template-pathname* (merge-pathnames "tmpl/" (cl-github-page-dir)))
          (*string-modifier* #'identity))
      (fill-and-print-template
       tmpl-file datum :stream s))))

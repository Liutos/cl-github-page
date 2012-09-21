(defpackage :com.liutos.cl-github-page
  (:use :cl
	:cl-github-page.file-comp
	:cl-github-page.path)
  (:import-from :cl-fad
		:walk-directory)
  (:import-from :cl-markdown
		:markdown)
  (:import-from :cl-who
		:with-html-output-to-string)
  (:import-from :html-template
		:*default-template-pathname*
		:*string-modifier*
		:fill-and-print-template)
  (:import-from :local-time
		:format-rfc1123-timestring
		:timestamp>
		:universal-to-timestamp)
  (:export :main))

(in-package :com.liutos.cl-github-page)

(defparameter *blog-dir*
  (namestring (merge-pathnames "src/blog/" (user-homedir-pathname))))

(defmacro defblog-file (var filespec &optional doc)
  `(defparameter ,var
     (concatenate 'string *blog-dir* ,filespec) ,doc))

(defblog-file *sources-dir* "src/")
(defblog-file *posts-dir* "posts/")
(defblog-file *friends* "friends.lisp")
(defblog-file *rss* "atom.xml")
(defblog-file *index* "index.html")
(defblog-file *friends-page* "friends.html")

(defparameter *post-tmpl* #p"post.tmpl")
(defparameter *rss-tmpl* #p"atom.tmpl")
(defparameter *index-tmpl* #p"index.tmpl")
(defparameter *friends-tmpl* #p"friends.tmpl")

(defmacro with-cache (var val)
  `(or ,var
       (setf ,var ,val)))

(defun write-file-by-tmpl (target-file tmpl-file datum)
  (with-open-file (s target-file
		     :direction :output
		     :if-exists :supersede)
    (let ((*default-template-pathname* (merge-pathnames "tmpl/" *blog-dir*)))
      (fill-and-print-template
       tmpl-file datum :stream s))))
(defpackage :com.liutos.cl-github-page
  (:use :cl)
  (:nicknames :cl-github-page)
  (:import-from :cl-markdown
		:markdown)
  (:import-from :html-template
		:fill-and-print-template
		:*default-template-pathname*
		:*string-modifier*)
  (:import-from :cl-github-page.file-comp
		:file-mtime>
		:file-date-string)
  (:import-from :cl-fad
		:walk-directory)
  (:export :main))

(in-package :com.liutos.cl-github-page)

(defparameter *source-dir* "/home/liutos/src/blog/src/")
(defparameter *blog-dir* "/home/liutos/src/blog/")
(defparameter *target-dir*
  (concatenate 'string *blog-dir* "posts/"))
(setf *default-template-pathname*
      (merge-pathnames "tmpl/" *blog-dir*))
(defparameter *post-tmpl* #p"post.tmpl")
(defparameter *index-tmpl* #p"index.tmpl")
(defparameter *db*
  (concatenate 'string *blog-dir* "sqlite3.db"))
(defparameter *friends*
  (concatenate 'string *blog-dir* "friends.lisp"))
(defvar *friends-cache* nil)
(defvar *srcs* nil)

(defun relative-path (path parent)
  (subseq (namestring path)
	  (length (namestring parent))))

(defun chtype (path obj-type)
  (concatenate 'string
	       (subseq path 0 (position #\. (namestring path) :from-end t))
	       (string #\.)
	       obj-type))

(defun parse-categories (obj)
  (or (cdr (pathname-directory (relative-path obj *source-dir*)))
      '("default")))

(defun gen-obj-path (src)
  (let ((p (reduce #'(lambda (acc cat)
		       (concatenate 'string acc cat (string #\/)))
		   (parse-categories src) :initial-value *target-dir*)))
    (chtype (concatenate 'string p (pathname-name src)) "html")))

(defun ensure-categories-exist (cats)
  (labels ((aux (parent cats)
	     (when cats
	       (let ((p (merge-pathnames (concatenate 'string
						      (first cats)
						      (string #\/))
					 parent)))
		 (ensure-directories-exist p :verbose t)
		 (aux p (rest cats))))))
    (aux *target-dir* cats)))

(defun gen-markdown-string (md-src)
  (with-output-to-string (s)
    (markdown md-src :stream s)))

(defun gen-friends ()
  (or *friends-cache*
      (setf *friends-cache*
	    (with-open-file (s *friends*)
	      (let ((lns (read s)))
		(mapcar #'(lambda (lnc)
			    (destructuring-bind (link . name) lnc
			      `(:link ,link
				:name ,name)))
			lns))))))

(defun make-post-content (src)
  `(:post-title ,(pathname-name src)
    :blog-title "Liutos的博客"
    :post-content ,(gen-markdown-string src)
    :friends ,(gen-friends)))

(defun gen-infos (srcs)
  (mapcar #'(lambda (s)
	      `(:post-title ,(pathname-name s)
		:post-date ,(file-date-string s)
		:post-link ,(relative-path (gen-obj-path s) *blog-dir*)))
	  srcs))

(defun make-index-content (srcs)
  `(:blog-title "Liutos的博客"
    :posts-info ,(gen-infos srcs)
    :friends ,(gen-friends)))

(defun write-post (src)
  (let ((obj (gen-obj-path src)))
    (ensure-categories-exist (parse-categories src))
    (with-open-file (s obj
		       :direction :output
		       :if-exists :supersede)
      (let ((*string-modifier* #'identity))
	(fill-and-print-template
	 *post-tmpl* (make-post-content (pathname src)) :stream s)))))

(defun file-updatable-p (src)
  (let ((obj (gen-obj-path src)))
    (or (not (probe-file obj))
	(file-mtime> src obj))))

(defun all-srcs ()
  (or *srcs*
      (setf *srcs*
	    (let (srcs)
	      (walk-directory *source-dir* #'(lambda (f) (push f srcs)))
	      (sort srcs #'file-mtime>)))))

(defun update-posts (src-list &optional (forced-p nil))
  (dolist (src src-list)
    (when (or forced-p
	      (file-updatable-p src))
      (write-post src)
      (format t "~&Source file ~A updated!~%" src))))

(defun write-index ()
  (with-open-file (s (merge-pathnames "index.html" *blog-dir*)
		     :direction :output
		     :if-exists :supersede)
    (let ((*string-modifier* #'identity))
      (fill-and-print-template
       *index-tmpl* (make-index-content (all-srcs)) :stream s))))

(defun main (args)
  (declare (ignore args))
  (update-posts (all-srcs))
  (write-index))
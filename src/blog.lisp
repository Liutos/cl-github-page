(in-package :cl-github-page)

(defvar *blog-title* nil)

(defun make-blog-title ()
  (with-cache *blog-title*
    (with-output-to-string (s)
      (let ((*default-template-pathname* (merge-pathnames "tmpl/" *blog-dir*)))
        (fill-and-print-template
         *blog-title-tmpl* nil :stream s)))))

(defvar *friends-cache* nil)

(defun make-friends-list ()
  (with-cache *friends-cache*
    (with-open-file (s *friends*)
      (let ((lns (read s)))
	(loop
           :for (link . name) :in lns
           :collect (list :link link :name name))))))

(defun make-friends-page ()
  (let ((datum (list :friends (make-friends-list))))
    (write-file-by-tmpl *friends-page*
			*friends-tmpl*
			datum)))

(in-package :com.liutos.cl-github-page)

(defvar *blog-title* nil)

(defun make-blog-title ()
  (with-cache *blog-title*
    (with-html-output-to-string (s)
      (:h1 "Liutos的博客 - "
	   (:small "乍听之下，不无道理；仔细揣摩，胡说八道(￣ε(#￣)"))
      (:h3 "Powered By "
	   (:a :href "http://github.com/Liutos/cl-github-page"
	       "cl-github-page")))))

(defvar *friends-cache* nil)

(defun make-friends-list ()
  (with-cache *friends-cache*
    (with-open-file (s *friends*)
      (let ((lns (read s)))
	(loop :for (link . name) :in lns
	   :collect (list :link link :name name))))))

(defun make-friends-page ()
  (let ((datum (list :friends (make-friends-list))))
    (write-file-by-tmpl *friends-page*
			*friends-tmpl*
			datum)))
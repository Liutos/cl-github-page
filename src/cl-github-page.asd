(in-package :cl-user)

(defpackage :system-cl-github-page
  (:use :cl :asdf))

(in-package :system-cl-github-page)

(defsystem :cl-github-page
  :author "Liutos <mat.liutos@gmail.com>"
  :depends-on (:cl-fad :cl-markdown :cl-who :html-template :local-time)
  :components ((:file "about-me"
                      :depends-on ("package"))
               (:file "blog"
		      :depends-on ("package"))
	       (:file "category"
		      :depends-on ("class" "package"))
	       (:file "cl-github-page"
		      :depends-on ("post" "index" "rss"))
	       (:file "class"
		      :depends-on ("package"))
	       (:file "file-comp")
	       (:file "index"
		      :depends-on ("blog" "category" "post"))
	       (:file "package"
		      :depends-on ("file-comp" "path"))
	       (:file "path")
	       (:file "post"
		      :depends-on ("blog" "class" "category" "file-comp" "path"))
	       (:file "rss"
		      :depends-on ("post"))))

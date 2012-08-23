(in-package :cl-user)

(defpackage :system-cl-github-page
  (:use :cl :asdf))

(in-package :system-cl-github-page)

(defsystem :cl-github-page
  :author "Liutos <mat.liutos@gmail.com>"
  :depends-on (:cl-markdown :html-template :local-time :cl-fad)
  :components ((:file "main"
		      :depends-on ("file-comp"))
	       (:file "file-comp")))
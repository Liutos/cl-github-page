(in-package :cl-user)

(defpackage :system-cl-github-page
  (:use :cl :asdf))

(in-package :system-cl-github-page)

(defsystem :cl-github-page
  :author "Liutos <mat.liutos@gmail.com>"
  :depends-on (:cl-fad :local-time :cl-markdown :html-template)
  :components ((:file "cl-github-page")))
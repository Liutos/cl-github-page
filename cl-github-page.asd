(in-package :cl-user)

(defpackage :system-cl-github-page
  (:use :cl :asdf))

(in-package :system-cl-github-page)

(defsystem :cl-github-page
  :author "Liutos <mat.liutos@gmail.com>"
  :version "0.0.4"
  :description "Static Blog Generator for GitHub Pages."
  :depends-on (:cl-fad
               :cl-markdown
               :cl-who
               :html-template
               :local-time)
  :components
  ((:module "src"
            :components
            ((:file "file-comp")
             (:file "path")
             (:file "package" :depends-on ("file-comp" "path"))
             (:file "about-me" :depends-on ("package"))
             (:file "blog" :depends-on ("package"))
             (:file "cl-github-page" :depends-on ("post" "index" "rss"))
             (:file "class" :depends-on ("package"))
             (:file "category" :depends-on ("class"))
             (:file "post"
                    :depends-on ("blog" "class" "category"))
             (:file "index" :depends-on ("blog" "category"))
             (:file "rss" :depends-on ("post"))))))

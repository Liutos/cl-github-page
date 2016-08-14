(in-package :cl-user)

(defpackage :system-cl-github-page
  (:use :cl :asdf))

(in-package :system-cl-github-page)

(defsystem :cl-github-page
  :author "Liutos <mat.liutos@gmail.com>"
  :version "0.0.5"
  :description "Static Blog Generator for GitHub Pages."
  :depends-on (#:cl-fad
               #:cl-json
               #:cl-markdown
               #:cl-who
               #:drakma
               #:flexi-streams
               #:html-template
               #:local-time)
  :components
  ((:module "src"
            :serial t
            :components
            ((:module "compile"
                      :serial t
                      :components ((:file "package")
                                   (:file "index")))
             (:file "file-comp")
             (:file "path")
             (:file "package")
             (:file "misc")
             (:file "about-me")
             (:file "blog")
             (:file "config")
             (:file "class")
             (:file "category")
             (:file "post")
             (:file "rss")
             (:file "index")
             (:file "cl-github-page")))))

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
               #:cl-mysql
               #:cl-who
               #:drakma
               #:flexi-streams
               #:html-template
               #:local-time
               #:osicat)
  :components
  ((:module "src"
            :serial t
            :components
            ((:module "config"
                      :serial t
                      :components ((:file "package")
                                   (:file "index")))
             (:module "misc"
                      :serial t
                      :components ((:file "package")
                                   (:file "index")))
             (:module "compile"
                      :serial t
                      :components ((:file "package")
                                   (:file "index")))
             (:module "file"
                      :serial t
                      :components ((:file "package")
                                   (:file "index")))
             (:module "storage"
                      :serial t
                      :components ((:file "package")
                                   (:file "index")))
             (:module "template"
                      :serial t
                      :components ((:file "package")
                                   (:file "index")))
             (:module "post"
                      :serial t
                      :components ((:file "package")
                                   (:file "index")))
             (:module "page"
                      :serial t
                      :components ((:file "package")
                                   (:file "index")))))))

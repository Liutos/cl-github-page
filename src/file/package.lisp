(defpackage #:com.liutos.cl-github-page.file
  (:use :cl)
  (:import-from #:cl-fad
                #:directory-exists-p
                #:file-exists-p)
  (:export #:get-basename
           #:get-file-content
           #:is-file-exists
           #:set-file-content))

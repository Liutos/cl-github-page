(defpackage #:com.liutos.cl-github-page.compile
  (:use #:cl)
  (:import-from #:drakma
                #:http-request)
  (:import-from #:json
                #:encode-json-alist-to-string)
  (:export #:*mode*
           #:compile-from-markdown))

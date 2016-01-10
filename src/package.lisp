(defpackage :com.liutos.cl-github-page
  (:nicknames :cl-github-page
              :clgp
              :akashic)
  (:use #:cl
        #:cl-github-page.file-comp
        #:cl-github-page.path
        #:cl-ppcre
        #:json)
  (:import-from :cl-fad
		:walk-directory)
  (:import-from :cl-markdown
		:markdown)
  (:import-from :cl-who
		:with-html-output-to-string)
  (:import-from :html-template
		:*default-template-pathname*
		:*string-modifier*
		:fill-and-print-template)
  (:import-from :local-time
		:format-rfc1123-timestring
		:timestamp>
		:universal-to-timestamp)
  (:export #:main
           #:create))

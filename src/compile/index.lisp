(in-package #:com.liutos.cl-github-page.compile)

(defvar *accept* "application/vnd.github.v3+json")
(defvar *content-type* "application/json")
(defparameter *executor* :github)
(defvar *mode* "gfm")
(defvar *schema* "https://api.github.com")

(defun make-uri (path)
  (concatenate 'string *schema* path))

(defun compile-by-github (text
                          &key
                            (mode *mode*))
  (assert (member mode '("gfm" "markdown") :test #'equal))
  (let ((accept *accept*)
        content
        (content-type *content-type*)
        (method :post)
        parameters
        body
        (uri (make-uri "/markdown")))
    (setf parameters
          `(("mode" . ,mode)
            ("text" . ,text)))
    (setf content
          (encode-json-alist-to-string parameters))
    (setf body
          (http-request uri
                        :accept accept
                        :content content
                        :content-type content-type
                        :method method
                        :redirect t))
    body))

(defun compile-by-lib (text)
  (with-output-to-string (html)
    (cl-markdown:markdown text :stream html)))

;;; EXPORT

(defun compile-from-markdown (text
                              &key
                                (executor *executor*)
                                (mode *mode*))
  (ecase executor
    (:github (compile-by-github text :mode mode))
    (:lib (compile-by-lib text))))

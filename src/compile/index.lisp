(in-package #:com.liutos.cl-github-page.compile)

(defvar *accept* "application/vnd.github.v3+json")
(defvar *content-type* "application/json")
(defvar *schema* "https://api.github.com")

(defun make-uri (path)
  (concatenate 'string *schema* path))

(defun compile-from-markdown (text)
  (let ((accept *accept*)
        content
        (content-type *content-type*)
        (method :post)
        parameters
        body
        (uri (make-uri "/markdown")))
    (setf parameters
          `(("mode" . "gfm")
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

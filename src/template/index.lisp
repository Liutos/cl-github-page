(in-package #:com.liutos.cl-github-page.template)

(defvar *template-dir* #P"/home/liutos/src/cl/cl-github-page/src/template/tmpl/")

(defgeneric fill-template-and-print (destination template values))

(defmethod fill-template-and-print ((destination (eql nil)) template values)
  (with-output-to-string (string)
    (fill-template-and-print string template values)))

(defmethod fill-template-and-print ((destination pathname) template values)
  (with-open-file (file destination
                        :direction :output
                        :if-exists :supersede)
    (fill-template-and-print file template values)))

(defmethod fill-template-and-print ((destination stream) template values)
  (let ((html-template:*default-template-pathname* *template-dir*))
    (html-template:fill-and-print-template template
                                           values
                                           :stream destination)))

;;; EXPORT

(defun fill-index-template (blog-description
                            blog-title
                            categories
                            posts
                            &key
                              destination)
  (let ((template #p"/media/world2/liutos/src/cl/cl-github-page/src/template/tmpl/index.html")
        (values (list :blog-description blog-description
                      :blog-title blog-title
                      :categories categories
                      :posts posts)))
    (fill-template-and-print destination template values)))

(defun fill-post-template (blog-description
                           blog-title
                           categories
                           post-body
                           post-meta
                           post-title
                           &key
                             destination)
  (let ((html-template:*string-modifier* #'identity)
        (template #p"/media/world2/liutos/src/cl/cl-github-page/src/template/tmpl/post.html")
        (values (list :blog-description blog-description
                      :blog-title blog-title
                      :categories categories
                      :post-body post-body
                      :post-meta post-meta
                      :post-title post-title)))
    (fill-template-and-print destination template values)))

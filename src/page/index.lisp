(in-package #:com.liutos.cl-github-page.page)

(defparameter *blog-description* "由<a href=\"https://github.com/Liutos/cl-github-page\">cl-github-page</a>提供技术支持")
(defparameter *blog-root* #P"/home/liutos/src/blog2/")
(defvar *blog-title* "Liutos的博客")

(defun make-index-path ()
  (merge-pathnames "index.html" *blog-root*))

(defun make-post-path (post-id)
  (merge-pathnames (format nil "posts/~D.html" post-id) *blog-root*))

(defun make-post-url (post-id)
  (format nil "posts/~D.html" post-id))

;;; EXPORT

(defun write-index-page ()
  (let ((blog-description *blog-description*)
        (blog-title *blog-title*)
        (categories '())
        (destination (make-index-path))
        (post-list (com.liutos.cl-github-page.storage:get-post-list))
        posts)
    (setf posts
          (mapcar #'(lambda (post)
                      (list :post-title (getf post :title)
                            :post-url (make-post-url (getf post :post_id))))
                  post-list))
    (com.liutos.cl-github-page.template:fill-index-template blog-description
                                                            blog-title
                                                            categories
                                                            posts
                                                            :destination destination)))

(defun write-post-page (post-id)
  (let ((post (com.liutos.cl-github-page.storage:find-post post-id)))
    (unless post
      (error "~D: 文章不存在" post-id))
    (let ((blog-description *blog-description*)
          (blog-title *blog-title*)
          (categories '())
          (destination (make-post-path post-id))
          (post-body (getf post :body))
          (post-meta (com.liutos.cl-github-page.post:make-post-meta post))
          (post-title (getf post :title)))
      (com.liutos.cl-github-page.template:fill-post-template blog-description
                                                             blog-title
                                                             categories
                                                             post-body
                                                             post-meta
                                                             post-title
                                                             :destination destination))))

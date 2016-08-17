(in-package #:com.liutos.cl-github-page.page)

(defvar *blog-description* "")
(defvar *blog-title* "Liutos的博客")

(defun write-index-page ()
  (let ((blog-description *blog-description*)
        (blog-title *blog-title*)
        (categories '())
        (post-list (com.liutos.cl-github-page.storage:get-post-list))
        posts)
    (setf posts
          (mapcar #'(lambda (post)
                      (list :post-title (getf post :title)))
                  post-list))
    (com.liutos.cl-github-page.template:fill-index-template blog-description
                                                            blog-title
                                                            categories
                                                            posts
                                                            :destination #P"/tmp/index.html")))

(defun write-post-page (post-id)
  (let ((post (com.liutos.cl-github-page.storage:find-post post-id)))
    (unless post
      (error "~D: 文章不存在" post-id))
    (let ((blog-description *blog-description*)
          (blog-title *blog-title*)
          (categories '())
          (destination (pathname (format nil "/tmp/~D.html" post-id)))
          (post-body (getf post :body))
          (post-meta (getf post :create_at))
          (post-title (getf post :title)))
      (com.liutos.cl-github-page.template:fill-post-template blog-description
                                                             blog-title
                                                             categories
                                                             post-body
                                                             post-meta
                                                             post-title
                                                             :destination destination))))

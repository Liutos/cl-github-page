(in-package #:com.liutos.cl-github-page.page)

(defun make-index-path ()
  (merge-pathnames "index.html" (com.liutos.cl-github-page.config:get-blog-root)))

(defun make-post-path (post-id)
  (merge-pathnames (format nil "posts/~D.html" post-id) (com.liutos.cl-github-page.config:get-blog-root)))

(defun make-post-url (post-id)
  (format nil "posts/~D.html" post-id))

;;; EXPORT

(defun write-index-page ()
  (let ((blog-description (com.liutos.cl-github-page.config:get-blog-description))
        (blog-title (com.liutos.cl-github-page.config:get-blog-title))
        (categories '())
        (destination (make-index-path))
        (post-list (com.liutos.cl-github-page.storage:get-post-list))
        posts)
    (setf posts
          (mapcar #'(lambda (post)
                      (list :post-title (getf post :title)
                            :post-url (make-post-url (getf post :post_id))))
                  post-list))
    (com.liutos.cl-github-page.template:fill-index-template
     :blog-description blog-description
     :blog-title blog-title
     :categories categories
     :posts posts
     :destination destination)))

(defun write-post-page (post-id)
  (let ((post (com.liutos.cl-github-page.storage:find-post post-id)))
    (unless post
      (error "~D: 文章不存在" post-id))
    (let ((blog-description (com.liutos.cl-github-page.config:get-blog-description))
          (blog-title (com.liutos.cl-github-page.config:get-blog-title))
          (categories '())
          (destination (make-post-path post-id))
          (next-post (com.liutos.cl-github-page.storage:find-next-post post-id))
          (post-body (getf post :body))
          (post-meta (com.liutos.cl-github-page.post:make-post-meta post))
          (post-title (getf post :title))
          (prev-post (com.liutos.cl-github-page.storage:find-prev-post post-id)))
      (com.liutos.cl-github-page.template:fill-post-template
       :blog-description blog-description
       :blog-title blog-title
       :categories categories
       :next-post-id (getf next-post :post_id)
       :post-body post-body
       :post-id post-id
       :post-meta post-meta
       :post-title post-title
       :prev-post-id (getf prev-post :post_id)
       :destination destination)
      (com.liutos.cl-github-page.storage:update-post post-id
                                                     :build-at (com.liutos.cl-github-page.misc:make-datetime-of-now)))))

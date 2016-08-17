(in-package #:com.liutos.cl-github-page.page)

(defun write-index-page ()
  (let ((blog-description "")
        (blog-title "Liutos的博客")
        (categories '())
        html
        (post-list (com.liutos.cl-github-page.storage:get-post-list))
        posts)
    (setf posts
          (mapcar #'(lambda (post)
                      (list :post-title (getf post :title)))
                  post-list))
    (setf html
          (com.liutos.cl-github-page.template:fill-index-template blog-description
                                                                  blog-title
                                                                  categories
                                                                  posts))
    (with-open-file (file (format nil "/tmp/index.html")
                          :direction :output
                          :if-exists :supersede)
      (write-string html file))))

(defun write-post-page (post-id)
  (let ((post (com.liutos.cl-github-page.storage:find-post post-id)))
    (unless post
      (error "~D: 文章不存在" post-id))
    (let ((blog-description "")
          (blog-title "Liutos的博客")
          (categories '())
          html
          (post-body (getf post :body))
          (post-meta (getf post :create_at))
          (post-title (getf post :title)))
      (setf html
            (com.liutos.cl-github-page.template:fill-post-template blog-description
                                                                   blog-title
                                                                   categories
                                                                   post-body
                                                                   post-meta
                                                                   post-title))
      (with-open-file (file (format nil "/tmp/~D.html" post-id)
                            :direction :output
                            :if-exists :supersede)
        (write-string html file)))))

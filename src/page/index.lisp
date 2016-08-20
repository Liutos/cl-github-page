(in-package #:com.liutos.cl-github-page.page)

(defun make-pagination-path (page-number)
  (let ((path (if (zerop page-number)
                  "index.html"
                  (format nil "pages/~D.html" (1+ page-number)))))
    (merge-pathnames path (com.liutos.cl-github-page.config:get-blog-root))))

(defun make-pages-data (n)
  (let ((pages '()))
    (dotimes (i n (nreverse pages))
      (let ((file-name (if (= i 0)
                           "/index.html"
                           (format nil "/pages/~D.html" (1+ i)))))
        (push (list :file-name file-name
                    :page-number (1+ i))
              pages)))))

(defun make-post-path (post-id)
  (merge-pathnames (format nil "posts/~D.html" post-id) (com.liutos.cl-github-page.config:get-blog-root)))

(defun make-post-url (post-id)
  (format nil "/posts/~D.html" post-id))

;;; EXPORT

(defun write-all-posts ()
  (let ((posts (com.liutos.cl-github-page.storage:get-post-list)))
    (dolist (post posts)
      (write-post-page (getf post :post_id)))))

(defun write-index-page ()
  (write-pagination-page 0))

(defun write-pagination-page (page-number)
  (let ((blog-description (com.liutos.cl-github-page.config:get-blog-description))
        (blog-title (com.liutos.cl-github-page.config:get-blog-title))
        (categories '())
        (destination (make-pagination-path page-number))
        (post-list (com.liutos.cl-github-page.storage:get-post-list))
        (p3 (com.liutos.cl-github-page.config:get-posts-per-page))
        pages
        posts)
    (setf posts
          (mapcar #'(lambda (post)
                      (list :post-title (getf post :title)
                            :post-url (make-post-url (getf post :post_id))
                            :post-write-at (com.liutos.cl-github-page.post:make-post-write-at post)))
                  post-list))
    (setf pages
          (make-pages-data
           (ceiling (/ (length posts) p3))))
    (setf posts
          (subseq posts
                  (* page-number p3)
                  (min (length posts) (* (1+ page-number) p3))))
    (com.liutos.cl-github-page.template:fill-page-template
     :blog-description blog-description
     :blog-title blog-title
     :categories categories
     :pages pages
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
          (post-title (getf post :title))
          (post-write-at (com.liutos.cl-github-page.post:make-post-write-at post))
          (prev-post (com.liutos.cl-github-page.storage:find-prev-post post-id)))
      (com.liutos.cl-github-page.template:fill-post-template
       :blog-description blog-description
       :blog-title blog-title
       :categories categories
       :next-post-id (getf next-post :post_id)
       :post-author (getf post :author)
       :post-body post-body
       :post-id post-id
       :post-write-at post-write-at
       :post-title post-title
       :prev-post-id (getf prev-post :post_id)
       :destination destination)
      (com.liutos.cl-github-page.storage:update-post post-id
                                                     :build-at (com.liutos.cl-github-page.misc:make-datetime-of-now)))))

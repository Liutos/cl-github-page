(in-package #:com.liutos.cl-github-page.page)

(defun make-category-path (category-id)
  "返回指定分类的页面地址"
  (check-type category-id integer)
  (merge-pathnames (format nil "categories/~D.html" category-id)
                   (com.liutos.cl-github-page.config:get-blog-root)))

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

(defun make-post-link (post-id)
  (concatenate 'string
               (com.liutos.cl-github-page.config:get-blog-site)
               (make-post-url post-id)))

(defun make-post-path (post-id)
  (merge-pathnames (format nil "posts/~D.html" post-id) (com.liutos.cl-github-page.config:get-blog-root)))

(defun make-post-url (post-id)
  (format nil "/posts/~D.html" post-id))

(defun make-rss-path ()
  (merge-pathnames "rss.xml" (com.liutos.cl-github-page.config:get-blog-root)))

;;; EXPORT

(defun write-all-category-pages ()
  "生成所有分类的文章列表页"
  (let ((categories (com.liutos.cl-github-page.storage:get-category-list)))
    (dolist (category categories)
      (write-category-page (getf category :category_id)))))

(defun write-all-pagination-pages ()
  (let* ((posts (com.liutos.cl-github-page.storage:get-post-list))
         (p3 (com.liutos.cl-github-page.config:get-posts-per-page))
         (total-pages (ceiling (/ (length posts) p3))))
    (dotimes (i total-pages)
      (write-pagination-page i))))

(defun write-all-posts ()
  (let ((posts (com.liutos.cl-github-page.storage:get-post-list)))
    (dolist (post posts)
      (write-post-page (getf post :post_id)))))

(defun write-category-page (category-id)
  "生成指定分类的文章列表页"
  (let ((category (com.liutos.cl-github-page.storage:find-category category-id)))
    (unless category
      (error "~D: 分类不存在" category-id))
    (let* ((blog-description (com.liutos.cl-github-page.config:get-blog-description))
           (blog-title (com.liutos.cl-github-page.config:get-blog-title))
           (categories '())
           (destination (make-category-path category-id))
           (post-list (com.liutos.cl-github-page.storage:find-post-by-category category-id))
           (posts (mapcar #'(lambda (post)
                              (list :post-title (getf post :title)
                                    :post-url (make-post-url (getf post :post_id))
                                    :post-write-at (com.liutos.cl-github-page.post:make-post-write-at post)))
                          post-list)))
      (com.liutos.cl-github-page.template:fill-category-template
       :blog-description blog-description
       :blog-title blog-title
       :categories categories
       :posts posts
       :destination destination))))

(defun write-index-page ()
  (write-pagination-page 0))

(defun write-pagination-page (page-number)
  (let ((blog-description (com.liutos.cl-github-page.config:get-blog-description))
        (blog-title (com.liutos.cl-github-page.config:get-blog-title))
        (categories (mapcar #'(lambda (category)
                                (list :category-url (make-category-path (getf category :category_id))
                                      :name (getf category :name)))
                            (com.liutos.cl-github-page.storage:get-category-list)))
        (destination (make-pagination-path page-number))
        (friends (com.liutos.cl-github-page.storage:get-friend-list))
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
     :friends friends
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

(defun write-rss-page (&optional
                         (nposts (com.liutos.cl-github-page.config:get-nposts-in-rss)))
  (let* ((destination (make-rss-path))
         (post-list (com.liutos.cl-github-page.storage:get-post-list))
         (posts (mapcar #'(lambda (post)
                            (list :post-body (getf post :body)
                                  :post-title (getf post :title)
                                  :post-url (make-post-link (getf post :post_id))))
                        post-list)))
    (setf posts (subseq posts 0 (min (length posts) nposts)))
    (com.liutos.cl-github-page.template:fill-rss-template
     :blog-description (com.liutos.cl-github-page.config:get-blog-description)
     :blog-site (com.liutos.cl-github-page.config:get-blog-site)
     :blog-title (com.liutos.cl-github-page.config:get-blog-title)
     :destination destination
     :posts posts)))

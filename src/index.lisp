(in-package :com.liutos.cl-github-page)

(defun make-post-infos (posts)
  (assert (typep posts 'array))
  (loop
     :for post :being :the :elements :of posts
     :collect (list
	       :post-title (post-title post)
	       :post-date (post-date post)
	       :post-link (post-link post))))

(defun index/posts-datum (posts-list)
  (list
   :blog-title (make-blog-title)
   :posts-info (make-post-infos posts-list)
   :friends (make-friends-list)
   :categories (make-categories-list)))

(defun write-index (posts-list)
  (let ((*string-modifier* #'identity))
    (write-file-by-tmpl *index*
			*index-tmpl*
			(index/posts-datum posts-list))))

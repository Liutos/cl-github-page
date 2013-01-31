(in-package :cl-github-page)

(defun rss/posts-datum (posts)
  (assert (typep posts 'array))
  (map 'array
       #'(lambda (post)
           (list
            :post-title (post-title post)
            :post-url (post-url post)
            :post-date (post-date post)
            :post-id (post-id post)
            :post-content (post-content post)))
       posts))

(defun write-rss (posts-list)
  (write-file-by-tmpl *atom*
		      *atom-tmpl*
		      (list :post-entries (rss/posts-datum posts-list))))

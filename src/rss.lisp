(in-package :com.liutos.cl-github-page)

(defun rss/posts-datum (posts-list)
  (mapcar #'(lambda (post)
	      (list
	       :post-title (post-title post)
	       :post-url (post-url post)
	       :post-date (post-date post)
	       :post-id (post-id post)
	       :post-content (post-content post)))
	  posts-list))

(defun write-rss (posts-list)
  (write-file-by-tmpl *rss*
		      *rss-tmpl*
		      (list :post-entries (rss/posts-datum posts-list))))
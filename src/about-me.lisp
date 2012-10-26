(in-package :com.liutos.cl-github-page)

(defun make-tags ()
  (with-open-file (s *tags*)
    (let ((tags (read s)))
      (mapcar #'(lambda (entry) (list :tag-entry entry)) tags))))

(defun make-personal-info ()
  (markdown-to-html (pathname *about-me-src*)))

(defun make-about-me-datum ()
  (list
   :blog-title (make-blog-title)
   :tags (make-tags)
   :personal-info (make-personal-info)
   :categories (make-categories-list)
   :friends (make-friends-list)))

(defun write-about-me ()
  (let ((*string-modifier* #'identity))
    (write-file-by-tmpl *about-me*
                        *about-me-tmpl*
                        (make-about-me-datum))))

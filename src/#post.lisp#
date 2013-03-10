(in-package :akashic)

(defun markdown-to-html (filespec)
  (with-output-to-string (s)
    (markdown filespec :stream s)))

(defun post-date-string (src)
  (multiple-value-bind (s m h date mon year)
      (decode-universal-time (file-write-date src))
    (declare (ignore s m h))
    (format nil "~D年~2D月~2D日" year mon date)))

(defun gen-post-path (src)
  (let ((p (reduce #'(lambda (acc cat)
		       (format nil "~A~A/" acc cat))
		   (parse-categories src)
		   :initial-value *posts-dir*)))
    (chtype (format nil "~A~A" p (pathname-name src)) "html")))

(defun rss/post-date-string (src)
  (format-rfc1123-timestring nil (universal-to-timestamp (file-write-date src))))

(defun make-post (src)
  "Create a post from the file located in `src'."
  (assert (typep src 'pathname))
  (make-instance 'post
                 :title (pathname-name src)
                 :content (markdown-to-html src)
                 :date (post-date-string src)
                 :rss-date (rss/post-date-string src)
                 :path (gen-post-path src)
                 :source-path src
                 ;; :src-date (universal-to-timestamp (file-write-date src))
                 :src-date (file-write-date src)))

(defun post-updatable-p (post)
  (with-slots (source-path path) post
    (or (not (probe-file path))
	(last-modified> source-path path))))

(defun post-datetime> (post-a post-b)
  ;; (timestamp> (post-src-date p1) (post-src-date p2))
  (> (post-src-date post-a) (post-src-date post-b)))

(defun get-all-sources (&optional (source-dir *sources-dir*))
  "Walks through the directory `*sources-dir*` recursively, makes an instance of class POST for each .text file, collects them into a list, sorts the elements in the list and returns it."
  (let (srcs)
    (walk-directory source-dir
		    #'(lambda (s)
			(let ((post (make-post s)))
			  (record-category post)
			  (push post srcs))))
    (sort srcs #'post-datetime>)))

(defun post-datum (post)
  (list
   :blog-title (make-blog-title)
   :post-title (post-title post)
   :post-content (post-content post)
   :friends (make-friends-list)
   ;; :categories (make-categories-list)
   ))

(defun write-post (post)
  (with-slots (source-path path) post
    (ensure-categories-exist (parse-categories source-path))
    (let ((*string-modifier* #'identity))
      (write-file-by-tmpl path
			  *post-tmpl*
			  (post-datum post)))))

(defun update-all-posts (posts &optional (forced-p nil))
  (dolist (post posts)
    (when (or forced-p (post-updatable-p post))
      (write-post post)
      (format t "~&Source file ~A updated!~%" (post-source-path post)))))

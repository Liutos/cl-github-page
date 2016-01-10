(in-package :akashic)

(defun markdown-to-html (filespec)
  (with-output-to-string (s)
    (markdown filespec :stream s)))

(defun get-write-date (path)
  "Get date of `path' stored in `*posts-date*', or the result of calling `file-write-date' on `path'."
  (declare (pathname path))
  (or (and (boundp '*posts-date*)
           *posts-date*
           (assoc (pathname-name path) *posts-date* :test #'equal)
           (let ((tm (getf (cdr (assoc (pathname-name path) *posts-date* :test #'equal)) :write-date)))
             (destructuring-bind (year month day)
                 (cl-ppcre:all-matches-as-strings "[0-9]+" tm)
               (encode-universal-time 0 0 0
                                      (parse-integer day)
                                      (parse-integer month)
                                      (parse-integer year)))))
      (file-write-date path)))

(defun post-date-string (write-date)
  (multiple-value-bind (s m h date mon year)
      (decode-universal-time write-date)
    (declare (ignore s m h))
    (format nil "~D年~2D月~2D日" year mon date)))

(defun make-post-path-mapper (conf
                              &aux (src (config-dir-src conf)) (dest (config-dir-dest conf)))
  "返回一个函数，这个函数接收一个参数`path'，根据其在`src'下的相对路径，返回对应的在`dest'下的完整路径的字符串"
  (declare (pathname src dest))
  (lambda (path)
    (declare (pathname path))
    (let* ((l (length (namestring src)))
           (path (subseq (namestring path) l))
           (parts (cl-ppcre:split "[/.]" path)))
      (when (= (length parts) 2)
        (push "default" parts))
      (merge-pathnames (format nil "~{~A~^/~}.html" (butlast parts)) dest))))

(defun rss/post-date-string (write-date)
  (format-rfc1123-timestring nil (universal-to-timestamp write-date)))

(defun make-post-maker (conf)
  (lambda (src)
    "Create a post from the file located in `src'."
    (declare (pathname src))
    (let ((gen-post-path (make-post-path-mapper conf))
          (write-date (get-write-date src)))
      (make-instance 'post
                     :content (markdown-to-html src)
                     :date (post-date-string write-date)
                     :path (funcall gen-post-path src)
                     :rss-date (rss/post-date-string write-date)
                     :source-path src
                     :src-date write-date
                     :title (pathname-name src)))))

(defun post-updatable-p (post)
  (with-slots (source-path path) post
    (or (not (probe-file path))
	(last-modified> source-path path))))

(defun post-datetime> (post-a post-b)
  (> (post-src-date post-a) (post-src-date post-b)))

(defun get-all-sources (conf)
  "Walks through the directory `*sources-dir*` recursively, makes an instance of class POST for each .text file, collects them into a list, sorts the elements in the list and returns it."
  (let ((dir-src (config-dir-src conf))
        (make-post (make-post-maker conf)))
    (let (srcs)
      (walk-directory dir-src
                      #'(lambda (s)
                          (let ((post (funcall make-post s)))
                            (record-category post)
                            (push post srcs))))
      (sort srcs #'post-datetime>))))

(defun post-datum (post)
  (list
   :blog-title (make-blog-title)
   :post-title (post-title post)
   :post-content (post-content post)
   :friends (make-friends-list)))

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

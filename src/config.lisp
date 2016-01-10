(in-package #:cl-github-page)

(defun config-parse (path)
  "读取以 JSON 记录的运行配置"
  (declare (pathname path))
  (when *verbose*
    (format t "从~A中读取配置~%" (namestring path)))
  (json:decode-json-from-source path))

(defun config-blog-title (conf)
  (cdr (assoc :title conf)))

(defun config-dir-blog (conf)
  (let ((dir-blog (cdr (assoc :path conf))))
    (if (char= #\/ (char dir-blog (1- (length dir-blog))))
        dir-blog
        (concatenate 'string dir-blog "/"))))

(defun config-about-me (conf)
  (let ((dir-blog (config-dir-blog conf)))
    (cl-fad:merge-pathnames-as-file dir-blog "about-me.html")))

(defun config-about-me-src (conf)
  (let ((dir-blog (config-dir-blog conf)))
    (cl-fad:merge-pathnames-as-file dir-blog "about-me.text")))

(defun config-atom (conf)
  (let ((dir-blog (config-dir-blog conf)))
    (cl-fad:merge-pathnames-as-file dir-blog "atom.xml")))

(defun config-dir-dest (conf)
  (let ((dir-blog (config-dir-blog conf)))
    (cl-fad:pathname-as-directory
     (merge-pathnames (cdr (assoc :dest conf)) dir-blog))))

(defun config-dir-src (conf)
  (let ((dir-blog (config-dir-blog conf)))
    (cl-fad:pathname-as-directory
     (merge-pathnames (cdr (assoc :src conf)) dir-blog))))

(defun config-friends (conf)
  (let ((dir-blog (config-dir-blog conf)))
    (cl-fad:merge-pathnames-as-file dir-blog "friends.lisp")))

(defun config-index (conf)
  (let ((dir-blog (config-dir-blog conf)))
    (cl-fad:merge-pathnames-as-file dir-blog "index.html")))

(defun config-posts-date (conf)
  (let ((dir-blog (config-dir-blog conf)))
    (cl-fad:merge-pathnames-as-file dir-blog "date.lisp")))

(defun config-tags (conf)
  (let ((dir-blog (config-dir-blog conf)))
    (cl-fad:merge-pathnames-as-file dir-blog "tags.lisp")))

(defun config-tmpl (conf)
  (cdr (assoc :tmpl conf)))

(defun config-tmpl-about-me (conf)
  (let ((tmpl (config-tmpl conf)))
    (cl-fad:pathname-as-file (or (cdr (assoc :atom tmpl)) "about-me.tmpl"))))

(defun config-tmpl-atom (conf)
  (let ((tmpl (config-tmpl conf)))
    (cl-fad:pathname-as-file (or (cdr (assoc :atom tmpl)) "atom.tmpl"))))

(defun config-tmpl-index (conf)
  (let ((tmpl (config-tmpl conf)))
    (cl-fad:pathname-as-file (or (cdr (assoc :atom tmpl)) "index.tmpl"))))

(defun config-tmpl-post (conf)
  (let ((tmpl (config-tmpl conf)))
    (cl-fad:pathname-as-file (or (cdr (assoc :post tmpl)) "post.tmpl"))))

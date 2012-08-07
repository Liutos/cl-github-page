(defpackage :com.liutos.cl-github-page
  (:use :cl)
  (:nicknames :cl-github-page)
  (:import-from :cl-fad
		:walk-directory)
  (:import-from :local-time
		:universal-to-timestamp
		:timestamp>)
  (:import-from :cl-markdown
		:markdown)
  (:import-from :html-template
		:fill-and-print-template
		:*default-template-pathname*
		:*string-modifier*)
  (:export :gen-post
	   :make-index-file))

(in-package :com.liutos.cl-github-page)

(defun parse-source-file (filespec source-dir)
  (declare (pathname filespec source-dir))
  (values filespec
	  (or (cdr (pathname-directory
		    (pathname (subseq (namestring filespec)
				      (length (namestring source-dir))))))
	      '("default"))))

(defun gen-post-content (src)
  (with-output-to-string (s)
    (markdown src :stream s)))

(defun read-file (filespec)
  "Reads a file's content as a string and return it."
  (with-open-file (s filespec)
    (let ((data (make-string (file-length s))))
      (read-sequence data s)
      data)))

(defun ensure-categories (target-dir category-list)
  "Creates the essential categories if they don't exist."
  (declare (pathname target-dir))
  (when category-list
    (let ((dir (merge-pathnames (first category-list) target-dir)))
      (ensure-directories-exist dir :verbose t)
      (ensure-categories dir (rest category-list)))))

(defun gen-target-pathname (filespec source-dir target-dir)
  (multiple-value-bind (file categories)
      (parse-source-file filespec source-dir)
    (format nil "~A~{~A/~}~A.html"
	    target-dir categories (pathname-name file))))

(defparameter *source-dir* #p"/home/liutos/src/blog/src/"
	      "The default directory contains all the source file and category subdirectories.")
(defparameter *target-dir* #p"/home/liutos/src/blog/posts/"
	      "The default directory contains all the target HTML files.")
(setq *default-template-pathname* #p"/home/liutos/src/blog/tmpl/")

(defmacro with-output-file ((stream filespec) &body body)
  `(with-open-file (,stream ,filespec
			    :direction :output
			    :if-exists :supersede)
     ,@body))

;;; 这里可以采用另一种策略来利用经由cl-markdown生成的HTML内容，即将它们作为纯粹的内容填充到模板文件中去，而评论相关的代码，甚至是其它的代码都可以直接在模板文件中书写，然后一劳永逸。对于html-template库对填充内容的自动转义策略，可以通过动态绑定*string-modifier*变量为符号identity来取消。这里还有改进的余地，就是把filespec也设置为可选参数，默认值为nil。在函数内部处理时，如果遇到了nil，那么就在指定的source-dir目录搜索出最后修改时间最近的一个源文件，来生成目标文件。
(defun gen-post (filespec &optional (source-dir *source-dir*) (target-dir *target-dir*))
  "Creates a target HTML file in the target directory contains the content according to the source file."
  (multiple-value-bind (file category-list)
      (parse-source-file filespec source-dir)
    (let ((content (gen-post-content (pathname file))))
      (ensure-categories target-dir
			 (mapcar #'(lambda (c) (concatenate 'string c "/"))
				 category-list)) ;保证分类都以/结尾这样才能被Common Lisp的文件系统识别为目录
      (let ((*string-modifier* #'identity))
	(with-output-file (s (gen-target-pathname
			      filespec source-dir target-dir))
	  (fill-and-print-template
	   #p"post.tmpl" `(:content ,content) :stream s))))))

(defun file-mtime (filespec)
  "The last modify time of a file"
  (universal-to-timestamp (file-write-date filespec)))

(defun file-mtime> (file1 file2)
  "Return non-nil if the last modify time of file1 is earlier than file2"
  (timestamp> (file-mtime file1) (file-mtime file2)))

(defun sort-files (file-list)
  "Sort the files throught their last-modify time."
  (sort (copy-list file-list) #'file-mtime>))

(defun get-posts-list (posts-dir)
  "Traverses the directory and collects all the post files."
  (let (files)
    (walk-directory posts-dir #'(lambda (f) (push f files)))
    files))

(defun post-info (filespec source-dir)
  "Generates a tag contains the information of a post."
  (declare (pathname filespec))
  (multiple-value-bind (file category-list)
      (parse-source-file filespec source-dir)
    `(:link
      ,(format nil "posts~{/~A~}/~A.html" category-list (pathname-name file))
      :title ,(pathname-name file))))

(defun gen-posts-info (posts-list source-dir)
  "Generates the information of posts for filling template."
  `(:posts
    ,(mapcar #'(lambda (post) (post-info post source-dir)) posts-list)))

(defun make-index-file (&optional (posts-dir *target-dir*)
			(blog-dir #p"/home/liutos/src/blog/")
			(tmpl #p"/home/liutos/src/markdown/index.tmpl"))
  (with-output-file (s (merge-pathnames "index.html" blog-dir))
    (fill-and-print-template
     tmpl
     (gen-posts-info (sort-files (get-posts-list posts-dir)) posts-dir)
     :stream s)))
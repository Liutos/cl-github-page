(defpackage :com.lt.cl-github-page
  (:use :cl)
  (:nicknames :cl-github-page)
  (:import-from :cl-fad
		:walk-directory)
  (:import-from :local-time
		:universal-to-timestamp
		:timestamp<)
  (:import-from :cl-markdown
		:markdown))

(in-package :com.lt.cl-github-page)

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

(defparameter *source-dir* #p"/home/liutos/src/blog/src/")
(defparameter *target-dir* #p"/home/liutos/src/blog/posts/")

(defun gen-post (filespec &optional (source-dir *source-dir*) (target-dir *target-dir*))
  "Creates a target HTML file in the target directory contains the content according to the source file."
  (multiple-value-bind (file category-list)
      (parse-source-file filespec source-dir)
    (let ((content (gen-post-content (pathname file))))
      (ensure-categories target-dir category-list)
      (with-open-file (s (gen-target-pathname
			  filespec source-dir target-dir)
			 :direction :output
			 :if-exists :supersede)
	(format s "~A" content)))))

(defun file-mtime (filespec)
  "The last modify time of a file"
  (universal-to-timestamp
   (file-write-date filespec)))

(defun file-mtime< (file1 file2)
  "Return non-nil if the last modify time of file1 is earlier than file2"
  (timestamp<
   (file-mtime file1) (file-mtime file2)))

(defun sort-files (file-list)
  "Sort the files throught their last-modify time."
  (sort (copy-list file-list) #'file-mtime<))

(defun get-posts-list (posts-dir)
  "Traverses the directory and collects all the post files."
  (let (files)
    (walk-directory posts-dir #'(lambda (f) (push f files)))
    files))

(defun post-info (filespec source-dir)
  "Generates a tag contains the information of a post."
  (multiple-value-bind (file category-list)
      (parse-source-file filespec source-dir)
    `(:link
      ,(format nil "posts~{/~A~}/~A.html"
	       category-list (pathname-name file))
      :title ,(pathname-name file))))

(defun gen-posts-info (posts-list source-dir)
  "Generates the information of posts for filling template."
  `(:posts
    ,(mapcar #'(lambda (post) (post-info post source-dir)) posts-list)))

(defun make-index-file (&optional (posts-dir *target-dir*) (blog-dir #p"/home/liutos/src/blog/") (tmpl #p"/home/liutos/src/markdown/index.tmpl"))
  (with-open-file (s (merge-pathnames "index.html" blog-dir)
		     :direction :output
		     :if-exists :supersede)
    (html-template:fill-and-print-template
     tmpl
     (gen-posts-info (get-posts-list posts-dir) posts-dir)
     :stream s)))

(defun gen-post-spec (file-name)
  (gen-post (merge-pathnames file-name
			     #p"/home/liutos/src/blog/src/")
	    #p"/home/liutos/src/blog/src/"
	    #p"/home/liutos/src/blog/posts/"))
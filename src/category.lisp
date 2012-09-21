(in-package :com.liutos.cl-github-page)

(defparameter *categories*
  (make-hash-table :test #'equal))

(defun parse-categories (src)
  (or (cdr (pathname-directory (get-suffix-path src *sources-dir*)))
      '("default")))

(defun ensure-categories-exist (cats)
  (labels ((aux (parent cats)
	     (when cats
	       (let ((p (merge-pathnames
			 (concatenate 'string (first cats) "/")
			 parent)))
		 (ensure-directories-exist p :verbose t)
		 (aux p (rest cats))))))
    (aux *posts-dir* cats)))

(defun concat-cats (cats)
  (with-output-to-string (s)
    (format s "~{~A~^, ~}" cats)))

(defgeneric record-category (post))

(defmethod record-category ((post post))
  (with-slots (title source-path) post
    (let ((cat (concat-cats (parse-categories source-path))))
      (push post (gethash cat *categories*)))))

(defun make-categories-list ()
  (loop :for cat :being :the :hash-keys :of *categories*
     :using (hash-value articles)
     :collect (list
	       :category cat
	       :category-name cat
	       :articles (mapcar #'(lambda (p)
				     (list
				      :post-link (concatenate 'string "/" (post-link p))
				      :post-title (post-title p)))
				 articles))))
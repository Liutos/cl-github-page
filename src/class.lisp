(in-package :com.liutos.cl-github-page)

(defclass post ()
  ((title
    :initarg :title
    :reader post-title)
   (content
    :initarg :content
    :reader post-content)
   (date
    :initarg :date
    :reader post-date)
   (src-date
    :initarg :src-date
    :reader post-src-date)
   (link
    :accessor post-link
    :accessor post-url
    :accessor post-id)
   (rss-date
    :initarg :rss-date
    :reader post-rss-date)
   (path
    :initarg :path
    :reader post-path)
   (source-path
    :initarg :source-path
    :reader post-source-path)))

(defmethod initialize-instance :after ((instance post) &rest initargs)
  (declare (ignore initargs))
  (setf (post-link instance) (get-suffix-path (post-path instance) *blog-dir*)))

(defmethod print-object ((post post) stream)
  (print-unreadable-object (post stream :type t)
    (format stream "~A" (post-title post))))
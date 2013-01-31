(in-package :cl-github-page)

(defclass post ()
  ((title
    :initarg :title
    :reader post-title
    :documentation "The name of a .text file"
    :type string)
   (content
    :initarg :content
    :reader post-content
    :documentation "The HTML converted from Markdown text."
    :type string)
   (date
    :initarg :date
    :reader post-date
    :type string)
   (src-date
    :initarg :src-date
    :reader post-src-date
    ;; :type local-time:timestamp
    :type integer)
   (link
    :accessor post-link
    :accessor post-url
    :accessor post-id
    :type string)
   (rss-date
    :initarg :rss-date
    :reader post-rss-date
    :type string)
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

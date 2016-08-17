(in-package #:com.liutos.cl-github-page.storage)

(defun delete-by-alist (alist table)
  (let (query
        where-part)
    (setf where-part
          (encode-sql-alist-to-string alist))
    (setf query
          (format nil "DELETE FROM `~A` WHERE ~A" table where-part))
    (query query)))

(defun encode-sql-alist-to-string (alist)
  (let ((is-empty t))
    (with-output-to-string (sql)
      (dolist (element alist)
        (destructuring-bind (col-name . expr) element
          (when expr
            (when (not is-empty)
              (write-string ", " sql))
            (let (part)
              (setf part (format nil "`~A` = ~S" col-name expr))
              (write-string part sql)
              (setf is-empty nil))))))))

(defun insert-one-row (alist table)
  (let (query
        set-part)
    (setf set-part
          (encode-sql-alist-to-string alist))
    (setf query
          (format nil "INSERT INTO `~A` SET ~A" table set-part))
    (query query)))

(defun make-datetime-of-now ()
  (let ((timestamp (local-time:now))
        (format '(:year "-" :month "-" :day " " :hour ":" :min ":" :sec)))
    (local-time:format-timestring nil timestamp :format format)))

(defun make-plist-from-rows (result-set)
  (let ((fields (cadar result-set))
        (rows (caar result-set)))
    (mapcar #'(lambda (row)
                (mapcan #'(lambda (field expr)
                            (list (intern (string-upcase (car field)) :keyword)
                                  expr))
                        fields
                        row))
            rows)))

(defun update-by-id (alist id table)
  (let (query
        set-part)
    (setf set-part
          (encode-sql-alist-to-string alist))
    (setf query
          (format nil "UPDATE `~A` SET ~A WHERE `~A_id` = ~D" table set-part table id))
    (query query)))

;;; EXPORT

(defun bind-category-post (category-id post-id)
  (insert-one-row `(("category_id" . ,category-id)
                    ("post_id" . ,post-id))
                  "category_post"))

(defun bind-post-tag (post-id tag-id)
  (insert-one-row `(("post_id" . ,post-id)
                    ("tag_id" . ,tag-id))
                  "post_tag"))

(defun create-category (name)
  (insert-one-row `(("name" . ,name)) "category"))

(defun create-post (body is-active source title)
  (insert-one-row `(("body" . ,body)
                    ("create_at" . ,(make-datetime-of-now))
                    ("is_active" . ,is-active)
                    ("source" . ,source)
                    ("title" . ,title)
                    ("update_at" . ,(make-datetime-of-now)))
                  "post"))

(defun create-tag (name)
  (insert-one-row `(("name" . ,name)) "tag"))

(defun delete-post (post-id)
  (delete-by-alist `(("post_id" . ,post-id))
                   "post"))

(defun find-post (post-id)
  (let (query
        result-set)
    (setf query
          (format nil "SELECT * FROM `post` WHERE `post_id` = ~D" post-id))
    (setf result-set
          (query query))
    (car (make-plist-from-rows result-set))))

(defun find-post-by-source (source)
  (let (query
        result-set)
    (setf query
          (format nil "SELECT * FROM `post` WHERE `source` = ~S LIMIT 1" source))
    (setf result-set
          (query query))
    (caaar result-set)))

(defun start ()
  (connect
   :database "cl_github_page"
   :host "127.0.0.1"
   :password "2617267"
   :port 3306
   :user "root")
  (query "SET NAMES utf8"))

(defun stop ()
  (disconnect))

(defun unbind-category-post (category-id post-id)
  (delete-by-alist `(("category_id" . ,category-id)
                     ("post_id" . ,post-id))
                   "category_post"))

(defun unbind-post-tag (post-id tag-id)
  (delete-by-alist `(("post_id" . ,post-id)
                     ("tag_id" . ,tag-id))
                   "post_tag"))

(defun update-category (category-id
                        &key
                          name)
  (update-by-id `(("name" . ,name)) category-id "category"))

(defun update-post (post-id
                    &key
                      body
                      is-active
                      source
                      title)
  (update-by-id `(("body" . ,body)
                  ("is_active" . ,is-active)
                  ("source" . ,source)
                  ("title" . ,title)
                  ("update_at" . ,(make-datetime-of-now)))
                post-id
                "post"))

(defun update-tag (tag-id
                   &key
                     name)
  (update-by-id `(("name" . ,name)) tag-id "tag"))

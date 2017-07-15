(in-package #:com.liutos.cl-github-page.config)

(defparameter *config* (py-configparser:make-config))

;;; EXPORT

(defun get-blog-description ()
  (py-configparser:get-option *config* "blog" "description"))

(defun get-blog-root ()
  (pathname (py-configparser:get-option *config* "blog" "root")))

(defun get-blog-title ()
  (py-configparser:get-option *config* "blog" "title"))

(defun get-blog-site ()
  (py-configparser:get-option *config* "blog" "site"))

(defun get-database-options ()
  (list :database (py-configparser:get-option *config* "mysql" "database")
        :host (py-configparser:get-option *config* "mysql" "host")
        :password (py-configparser:get-option *config* "mysql" "password")
        :port (parse-integer (py-configparser:get-option *config* "mysql" "port"))
        :user (py-configparser:get-option *config* "mysql" "user")))

(defun get-default-category ()
  (py-configparser:get-option *config* "post" "category"))

(defun get-nposts-in-rss ()
  (parse-integer (py-configparser:get-option *config* "rss" "count")))

(defun get-posts-per-page ()
  (parse-integer (py-configparser:get-option *config* "post" "p3")))

(defun get-template-root ()
  (or (py-configparser:get-option *config* "template" "root")
      (merge-pathnames "src/template/tmpl/"
                       (asdf:system-source-directory 'cl-github-page))))

(defun init (&optional path)
  (unless path
    (setf path (merge-pathnames ".blog.ini" (user-homedir-pathname))))
  (py-configparser:read-files *config* (list path)))

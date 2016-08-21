(in-package #:com.liutos.cl-github-page.config)

(defun get-blog-description ()
  "乍听之下，不无道理；仔细揣摩，胡说八道(￣ε(#￣)")

(defun get-blog-root ()
  #P"/home/liutos/src/blog/")

(defun get-blog-title ()
  "Liutos的博客")

(defun get-database-options ()
  (list :database "cl_github_page"
        :host "127.0.0.1"
        :password "2617267"
        :port 3306
        :user "root"))

(defun get-posts-per-page ()
  14)

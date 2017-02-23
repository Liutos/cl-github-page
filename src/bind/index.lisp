(in-package #:com.liutos.cl-github-page.bind)

(defun bind-category-post (category-id post-id)
  "绑定分类与文章"
  (check-type category-id integer)
  (check-type post-id integer)
  (when (com.liutos.cl-github-page.storage:find-category-post-binding category-id post-id)
    (error "分类与文章已绑定"))
  (com.liutos.cl-github-page.storage:bind-category-post category-id post-id))

(defun unbind-category-post (category-id post-id)
  "解除分类与文章的绑定"
  (check-type category-id integer)
  (check-type post-id integer)
  (com.liutos.cl-github-page.storage:unbind-category-post category-id post-id))

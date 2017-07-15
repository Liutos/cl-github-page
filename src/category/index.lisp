(in-package #:com.liutos.cl-github-page.category)

(defun add-category (name)
  "新增一个分类"
  (check-type name string)
  (when (com.liutos.cl-github-page.storage:find-category-by-name name)
    (error "分类已存在"))
  (com.liutos.cl-github-page.storage:create-category name))

(defun find-by-name (name)
  "查找一个同名分类。"
  (check-type name string)
  (com.liutos.cl-github-page.storage:find-category-by-name name))

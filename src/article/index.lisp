(in-package #:com.liutos.cl-github-page.post)

(defun add-post (source
                 title)
  (when (pathnamep source)
    (if (com.liutos.cl-github-page.file:is-file-exists source)
        (setf source (com.liutos.cl-github-page.file:get-file-content source))
        (error "~A: 文件不存在" source)))
  (when (com.liutos.cl-github-page.storage:find-post-by-source source)
    (error "存在一模一样的文章"))
  (let (body)
    (setf body
          (com.liutos.cl-github-page.compile:compile-from-markdown source))
    (com.liutos.cl-github-page.storage:create-post body
                                                   1
                                                   source
                                                   title)))

(defun modify-post (post-id
                    source
                    title)
  (when (pathnamep source)
    (if (com.liutos.cl-github-page.file:is-file-exists source)
        (setf source (com.liutos.cl-github-page.file:get-file-content source))
        (error "~A: 文件不存在" source)))
  (when (com.liutos.cl-github-page.storage:find-post-by-source source)
    (error "存在一模一样的文章"))
  (unless (com.liutos.cl-github-page.storage:find-post post-id)
    (error "~D: 文章不存在" post-id))
  (let (body)
    (setf body
          (com.liutos.cl-github-page.compile:compile-from-markdown source))
    (com.liutos.cl-github-page.storage:update-post post-id
                                                   :body body
                                                   :source source
                                                   :title title)))

(defun unshelve-post (post-id)
  (unless (com.liutos.cl-github-page.storage:find-post post-id)
    (error "~D: 文章不存在" post-id))
  (com.liutos.cl-github-page.storage:update-post post-id
                                                 :is-active 0))

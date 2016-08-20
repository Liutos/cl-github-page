(in-package #:com.liutos.cl-github-page.post)

(defun universal-to-string (universal)
  (let ((timestamp (local-time:universal-to-timestamp universal)))
    (local-time:format-timestring
     nil timestamp
     :format '(:year "年" :month "月" :day "日"))))

;;; EXPORT

(defun add-post (source
                 &key
                   title
                   write-at)
  (when (and (pathnamep source) (null title))
    (setf title (com.liutos.cl-github-page.file:get-basename source)))
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
                                                   title
                                                   write-at)))

(defun delete-post (post-id)
  (unless (com.liutos.cl-github-page.storage:find-post post-id)
    (error "~D: 文章不存在" post-id))
  (com.liutos.cl-github-page.storage:delete-post post-id))

(defun make-post-meta (post)
  (let ((create-at (getf post :create_at))
        meta
        (update-at (getf post :update_at)))
    (setf meta
          (format nil "首次创建于~A" (universal-to-string create-at)))
    (unless (= update-at create-at)
      (setf meta
            (format nil "~A 最后更新于~A" meta (universal-to-string update-at))))
    meta))

(defun modify-post (post-id
                    source
                    title
                    &key
                      write-at)
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
                                                   :title title
                                                   :write-at write-at)))

(defun unshelve-post (post-id)
  (unless (com.liutos.cl-github-page.storage:find-post post-id)
    (error "~D: 文章不存在" post-id))
  (com.liutos.cl-github-page.storage:update-post post-id
                                                 :is-active 0))

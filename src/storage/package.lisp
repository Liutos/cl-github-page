(defpackage #:com.liutos.cl-github-page.storage
  (:use :cl
        :com.liutos.cl-github-page.misc)
  (:import-from #:cl-mysql
                #:connect
                #:disconnect
                #:query)
  (:export #:bind-category-post
           #:bind-post-tag
           #:create-category
           #:create-friend
           #:create-post
           #:create-tag
           #:delete-post
           #:find-category
           #:find-category-by-name
           #:find-category-post-binding
           #:find-max-post-id
           #:find-next-post
           #:find-post
           #:find-post-by-category
           #:find-post-by-source
           #:find-prev-post
           #:get-category-list
           #:get-friend-list
           #:get-post-list
           #:start
           #:stop
           #:unbind-category-post
           #:unbind-post-tag
           #:update-category
           #:update-post
           #:update-tag))

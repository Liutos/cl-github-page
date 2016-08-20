(defpackage #:com.liutos.cl-github-page.storage
  (:use :cl)
  (:import-from #:cl-mysql
                #:connect
                #:disconnect
                #:query)
  (:export #:bind-category-post
           #:bind-post-tag
           #:create-category
           #:create-post
           #:create-tag
           #:delete-post
           #:find-next-post
           #:find-post
           #:find-post-by-source
           #:find-prev-post
           #:get-post-list
           #:start
           #:stop
           #:unbind-category-post
           #:unbind-post-tag
           #:update-category
           #:update-post
           #:update-tag))

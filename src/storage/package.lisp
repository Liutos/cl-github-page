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
           #:find-post
           #:find-post-by-source
           #:start
           #:stop
           #:unbind-category-post
           #:unbind-post-tag
           #:update-category
           #:update-post
           #:update-tag))

(in-package :com.liutos.cl-github-page)

(defun main (&optional (forced-p nil))
  (clrhash *categories*)
  (let ((srcs (get-all-posts)))
    (update-all-posts srcs forced-p)
    ;; (write-rss srcs)
    (write-about-me)
    (write-index srcs)))

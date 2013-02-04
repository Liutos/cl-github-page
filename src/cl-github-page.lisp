(in-package :cl-github-page)

(defun main (&optional (forced-p nil))
  (clrhash *categories*)
  (let ((srcs (get-all-posts)))
    (update-all-posts srcs forced-p)
    ;; (write-rss srcs)
    (write-about-me)
    (write-index srcs)))

(defblog-file *debug-source-dir* "debug/src/")
(defblog-file *debug-post-dir* "debug/posts/")
(defblog-file *debug-index* "debug/index.html")

(defun test-main ()
  (let ((*sources-dir* *debug-source-dir*)
        (*posts-dir* *debug-post-dir*)
        (*index* *debug-index*))
    (main t)))

(in-package #:com.liutos.cl-github-page.file)

(defun get-file-content (filespec)
  (with-open-file (stream filespec)
    (let (content
          length)
      (setf length
            (file-length stream))
      (setf content
            (make-string length))
      (read-sequence content stream)
      content)))

(defun is-file-exists (pathspec)
  (and (file-exists-p pathspec)
       (not (directory-exists-p pathspec))))

(defun set-file-content (content filespec)
  (with-open-file (stream filespec
                          :direction :output
                          :if-exists :supersede)
    (write-string content stream)))

(in-package #:com.liutos.cl-github-page.file)

(defun get-basename (pathname)
  (when (pathnamep pathname)
    (setf pathname (namestring pathname)))
  (let ((dot-position (position #\. pathname :from-end t))
        (slash-position (position #\/ pathname :from-end t)))
    (subseq pathname (1+ slash-position) dot-position)))

(defun get-file-content (filespec)
  (with-open-file (stream filespec
                          :element-type '(unsigned-byte 8))
    (let* ((length (file-length stream))
           (content (make-array length
                                :element-type '(unsigned-byte 8))))
      (read-sequence content stream)
      (flexi-streams:octets-to-string content
                                      :external-format :utf-8))))

(defun is-file-exists (pathspec)
  (and (file-exists-p pathspec)
       (not (directory-exists-p pathspec))))

(defun set-file-content (content filespec)
  (with-open-file (stream filespec
                          :direction :output
                          :if-exists :supersede)
    (write-string content stream)))

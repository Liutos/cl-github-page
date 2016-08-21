(in-package #:com.liutos.cl-github-page.misc)

(defun make-datetime-of-now ()
  (let ((timestamp (local-time:now))
        (format '(:year "-" :month "-" :day " " :hour ":" :min ":" :sec)))
    (local-time:format-timestring nil timestamp :format format)))

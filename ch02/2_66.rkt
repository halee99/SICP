#lang racket

(define (lookup given-key set-of-records)
  (if (null? set-of-records)
      false
      (let ((k (key (entry set-of-records))))
        (cond ((equal? given-key k)
                (entry set-of-records))
              ((lt? given-key k)
                (lookup given-key (left-branch set-of-records)))
              ((gt? given-key k)
                (lookup given-key (right-branch set-of-records)))))))

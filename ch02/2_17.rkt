#lang planet neil/sicp

(define (last_pair lt)
  (list (list-ref lt (- (length lt) 1))))

(let ((l (last_pair (list 23 72 149 34))))
  (display l))
(list )

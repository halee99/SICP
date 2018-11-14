#lang planet neil/sicp

(define (reverse lt)
  (define (rec n)
    (if (< n 0)
      nil
      (cons (list-ref lt n)
              (rec (- n 1)))))
  (rec (- (length lt) 1)))


(define x (list (list 1 2) (list 3 4)))
(reverse x)
; (deep_reverse x)

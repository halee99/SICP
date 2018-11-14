#lang planet neil/sicp

(define (reverse lt)
  (define (rec n)
    (if (< n 0)
      nil
      (cons (list-ref lt n)
              (rec (- n 1)))))
  (rec (- (length lt) 1)))

(reverse (list 1 4 9 16 25))

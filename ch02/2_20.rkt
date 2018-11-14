#lang planet neil/sicp

(define (even_0_odd_1 x)
  (if (= (remainder x 2) 0)
      0
      1))

(define (same_parity x . w)
  (define parity (even_0_odd_1 x))
  (define (rec lt)
    (cond ((= (length lt) 0)
            nil)
          ((= parity (even_0_odd_1 (car lt)))
            (cons (car lt) (rec (cdr lt))))
          (else
            (rec (cdr lt)))))
  (cons x (rec w)))

(same_parity 1 2 3 4 5 6 7)
(same_parity 2 3 4 5 6 7)

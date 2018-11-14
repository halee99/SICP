#lang planet neil/sicp

(define (double f)
  (lambda (x) (f (f x))))

(define (inc x)
  (+ x 1))

((double inc) 1)

(((double (double double)) inc) 5)
; 5 + (2 x 2) x (2 x 2)

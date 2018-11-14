#lang racket

(define (double x)
  (+ x x))

(define (halve x)
  (/ x 2))

(define (sub x)
  (- x 1))

(define (even? n)
  (= (remainder n 2) 0))

(define (fast_mul a b)
  (if (= b 1)
      a
      (if (even? b)
          (fast_mul (double a) (halve b))
          (+ a (fast_mul a (sub b))))))


(fast_mul 100 100)
(fast_mul 4 3)

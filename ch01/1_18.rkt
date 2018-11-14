#lang racket

(define (double x)
  (+ x x))

(define (halve x)
  (/ x 2))

(define (sub x)
  (- x 1))

(define (even? n)
  (= (remainder n 2) 0))

(define (fast_mul a b r)
  (if (= b 1)
      (+ a r)
      (if (even? b)
          (fast_mul (double a) (halve b) r)
          (fast_mul a (sub b) (+ r a)))))

(define (mul a b)
  (fast_mul a b 0))

(mul 100 100)
(mul 4 5)

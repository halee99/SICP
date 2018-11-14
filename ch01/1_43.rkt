#lang planet neil/sicp

(define (repeated f n)
  (define (repeat i x)
    (if (= i 1)
        (f x)
        (repeat (- i 1) (f x))))
  (lambda (x) (repeat n x)))

(define (inc x)
  (+ x 1))

(define (square x)
  (* x x))

((repeated inc 5) 1)
((repeated square 3) 2)

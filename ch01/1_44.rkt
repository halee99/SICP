#lang planet neil/sicp

(define (repeated f n)
  (define (repeat i x)
    (if (= i 1)
        (f x)
        (repeat (- i 1) (f x))))
  (lambda (x) (repeat n x)))

(define dx 0.00001)

(define (smooth f)
  (lambda (x) (/ (+ (f x) (f (- x dx)) (f (+ x dx)))
                 3.0)))

(define (smooth_repeated f n)
  (repeat (smooth f) n))

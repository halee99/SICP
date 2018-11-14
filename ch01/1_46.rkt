#lang planet neil/sicp

(define (iterative_improve good_enough? f)
  (define (try guess)
    (let ((next (f guess)))
      (if (good_enough? guess next)
          next
          (try next))))
  (lambda (x) (try x)))

; 重写
(define tolerance 0.00001)

(define (close_enough? v1 v2)
  (< (abs (- v1 v2)) tolerance))

(define (average a b)
  (/ (+ a b)
     2))

(define (sqrt x)
  ((iterative_improve close_enough?
                      (lambda (y) (average y (/ x y))))
    1.0))

(define (fixed_point f first_guess)
  ((iterative_improve close_enough?
                      f)
    first_guess))

(define (sqrt2 x)
  (fixed_point (lambda (y) (average y (/ x y)))
               1.0))

(sqrt 4)
(sqrt2 4)
;

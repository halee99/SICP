#lang planet neil/sicp

(define tolerance 0.00001)

(define (print x count)
  (display count)
  (display " : ")
  (display x)
  (newline))

(define (fixed_point f first_guess)
  (define (close_enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess count)
    (let ((next (f guess)))
      (print next count)
      (if (close_enough? guess next)
          next
          (try next (+ count 1)))))
  (try first_guess 1))

; 普通法
(fixed_point (lambda (x) (/ (log 1000) (log x)))
             2)

; 平均阻尼法
(define (average a b)
  (/ (+ a b) 2))

(fixed_point (lambda (x) (average x (/ (log 1000) (log x))))
             2)

#lang planet neil/sicp

(define tolerance 0.00001)

(define (fixed_point f first_guess)
  (define (close_enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close_enough? guess next)
          next
          (try next))))
  (try first_guess))

; golden section
(define (find_golden_section x)
  (fixed_point (lambda (x) (+ 1 (/ 1 x)))
               x))

(define golden_section
  (find_golden_section 1.0))

golden_section
(/ 1 golden_section)

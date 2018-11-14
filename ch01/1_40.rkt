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

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))

(define dx 0.00001)

(define (newton_transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))

(define (newtons_method g guess)
  (fixed_point (newton_transform g) guess))

(define (cubic a b c)
  (lambda (x)
          (+ (* x x x)
             (* a x x)
             (* b x)
             c)))

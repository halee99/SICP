#lang racket

(require "deriv.rkt")

(define (make-exponentiation b e)
  (cond ((=number? e 0) 1)
        ((=number? e 1) b)
        ((and (number? b) (number? e))
          (expt b e))
        (else
          (list '** b e))))

(define (base x) (cadr x))

(define (exponent x) (caddr x))

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        ((exponentiation? exp)
         (make-product
           (make-product (exponent exp)
                         (make-exponentiation
                           (base exp)
                           (make-sum (exponent exp) -1)))
           (deriv (base exp) var)))
        (else
         (error "unknown expression type -- DERIV" exp))))


(deriv '(** x 5) 'x)

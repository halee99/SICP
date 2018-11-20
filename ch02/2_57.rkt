#lang racket

(require "deriv.rkt")

(define (expression? w)
  (or (sum? w)
      (product? w)
      (exponentiation? w)))

(define (parameter-simple? w)
  (and (pair? w) (= (length w) 1)))

;
(define (make-sum-simple a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else
          (list '+ a1 a2))))

(define (make-sum a1 . a2)
  (cond ((parameter-simple? a2)
          (make-sum-simple a1 (car a2)))
        (else
          (list '+ a1 a2))))

(define (augend s)
  (let ((a (cddr s)))
    (if (or (expression? a)
            (parameter-simple? a))
        (car a)
        (apply make-product a))))

(define (make-product-simple m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))

(define (make-product m1 . m2)
  (cond ((parameter-simple? m2)
          (make-product-simple m1 (car m2)))
        (else
          (list '* m1 m2))))

(define (multiplicand p)
  (let ((a (cddr p)))
    (if (or (expression? a)
            (parameter-simple? a))
        (car a)
        (apply make-product a))))

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
        (else
         (error "unknown expression type -- DERIV" exp))))


(deriv '(* x y (+ x 3)) 'x)

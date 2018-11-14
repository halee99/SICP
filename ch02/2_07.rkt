#lang planet neil/sicp

(define (make-interval a b) (cons a b))

(define (lower_bound x)
  (if (< (car x) (cdr x))
      (car x)
      (cdr x)))

(define (uper_bound x)
  (if (> (car x) (cdr x))
      (car x)
      (cdr x)))

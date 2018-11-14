#lang planet neil/sicp

(define (make_interval a b) (cons a b))

(define (lower_bound x)
  (if (< (car x) (cdr x))
      (car x)
      (cdr x)))

(define (upper_bound x)
  (if (> (car x) (cdr x))
      (car x)
      (cdr x)))

(define (sub_interval x y)
  (make_interval (- (car x) (cdr y))
                 (- (cdr x) (car y))))

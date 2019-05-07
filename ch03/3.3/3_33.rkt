#lang racket
(require "constraint_system.rkt")


(define (averager a b c)
  (let ((u (make-connector))
        (d (make-connector)))
    (adder a b u)
    (multiplier c d u)
    (constant 2 d)
    'averager-ok))

(define a (make-connector))
(define b (make-connector))
(define c (make-connector))
(averager a b c)

(probe "a" a)
(probe "b" b)
(probe "c" c)

(set-value! a 5 'user)
(set-value! b 7 'user)
(forget-value! a 'user)
(set-value! a 8 'user)

#lang racket
(require "constraint_system.rkt")

(define (squarer a b)
  (define (square x)
    (* x x))
  (define (process-new-value)
    (cond ((has-value? b)
            (if (< (get-value b) 0)
                (error "square less than 0 -- SQUARER" (get-value b))
                (set-value! a (sqrt (get-value b)) me)))
          ((has-value? a)
              (set-value! b (square (get-value a)) me))))
  (define (process-forget-value)
    (forget-value! a me)
    (forget-value! b me)
    (process-new-value))
  (define (me request)
    (cond ((eq? request 'I-have-a-value)
           (process-new-value))
          ((eq? request 'I-lost-my-value)
           (process-forget-value))
          (else
           (error "Unknown request -- SQUARER" request))))
  (connect a me)
  (connect b me)
  me)

; test
(define a (make-connector))
(define b (make-connector))
(squarer a b)
(probe "a" a)
(probe "b" b)

(set-value! a 5 'user)
(forget-value! a 'user)
; (forget-value! b 'user)
(set-value! b 9 'user)
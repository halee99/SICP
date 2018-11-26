#lang racket

; 能用 racket 的题我将用racket
; 因为速度快一点

(define (make-accumulator number)
  (lambda (x)
    (begin (set! number (+ number x))
      number)))

; test
(define A (make-accumulator 5))
(A 10)
(A 10)

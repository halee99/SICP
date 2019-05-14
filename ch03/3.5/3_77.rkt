#lang racket
(require "stream_utils.rkt")

(define (integral delayed-integrand initial-value dt)
  (cons-stream initial-value
               (let ((integrand (force delayed-integrand)))
                 (if (stream-null? integrand)
                     the-empty-stream
                     (integral (stream-cdr integrand)
                               (+ (* dt (stream-car integrand))
                                  initial-value)
                               dt)))))

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

; (stream-ref (solve (lambda (y) y) 1 0.001) 1000)

; 可能版本或其他原因出现错误:
; dy: undefined; cannot use before initialization

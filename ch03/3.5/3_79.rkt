#lang racket
(require "stream_utils.rkt")

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (let ((integrand (force delayed-integrand)))
                   (add-streams (scale-stream integrand dt)
                                int))))
  int)

; 可能版本或其他原因出现错误:
; dy: undefined; cannot use before initialization
(define (solve-2nd f dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (stream-map f dy y))
  y)

; (stream-ref (solve-2nd (lambda (dy y) y) 1 1 0.001) 1000)

; 可能版本或其他原因出现错误:
; dy: undefined; cannot use before initialization

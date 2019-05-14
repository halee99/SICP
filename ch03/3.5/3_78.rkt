#lang racket
(require "stream_utils.rkt")

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (let ((integrand (force delayed-integrand)))
                   (add-streams (scale-stream integrand dt)
                                int))))
  int)

(define (solve-2nd a b dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay
                         (add-streams (scale-stream dy a)
                                      (scale-stream y b)))
                       dy0
                       dt))
  y)

; (stream-ref (solve-2nd 1 1 0 1 0.001) 1000)

; 可能版本或其他原因出现错误:
; dy: undefined; cannot use before initialization

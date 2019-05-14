#lang racket
(require "stream_utils.rkt")

(define (integral integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (add-streams (scale-stream integrand dt)
                              int)))
  int)

(define (RC r c step)
  (lambda (i v0)
    (add-streams (scale-stream i r)
                 (integral (scale-stream i (/ 1.0 c)) v0 step))))


(define RC1 (RC 5 1 0.5))

; test
(display-stream (RC1 ones 2))
; 7
; 7.5
; 8.0
; 8.5
; 9.0
; 9.5
; 10.0
; 10.5
; 11.0
; 11.5
; 12.0
; 12.5
; 13.0
; 13.5
; ...

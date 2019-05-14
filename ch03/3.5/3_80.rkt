#lang racket
(require "stream_utils.rkt")

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (let ((integrand (force delayed-integrand)))
                   (add-streams (scale-stream integrand dt)
                                int))))
  int)

(define (RLC r l c dt)
  (lambda (vc0 il0)
    (define vc (integral (delay dvc) vc0 dt))
    (define il (integral (delay dil) il0 dt))
    (define dvc (scale-stream il (/ -1.0 c)))
    (define dil (add-streams
                  (scale-stream vc (/ 1.0 l))
                  (scale-stream il (/ (- 0 r) l))))
    (cons vc il)))

; (stream-ref ((RLC 1 1 0.2 0.1) 10 0) 1000)

; 可能版本或其他原因出现错误:
; dvc: undefined;
;  cannot use before initialization

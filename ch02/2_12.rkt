#lang planet neil/sicp

(define (make_center_precent c p)
  (make_interval (- c (* c p)) (+ c (* c p))))

(define (center i)
  (/ (+ (lower_bound i) (upper_bound i)) 2))

; c - c*p = lower
; c * (1 - p) = lower
; 1 - p = lower / c
; p = 1 - lower / c
(define (percent x)
  (- 1
     (/ (lower_bound x) (center x))))

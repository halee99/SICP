#lang racket
(require "stream_utils.rkt")

(define (sub-streams s1 s2)
(stream-map - s1 s2))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (mul-streams s1 s2)
  (stream-map * s1 s2))

(define (div-streams s1 s2)
  (stream-map / s1 s2))

(define (x-stream x)
  (cons-stream x (x-stream x)))

(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1)
                  (stream-car s2))
               (add-streams
                 (mul-series (stream-cdr s1) s2)
                 (mul-streams (x-stream (stream-car s1)) (stream-cdr s2)))))

(define zeros (cons-stream 0 zeros))

(define ones (cons-stream 1 ones))

(define (reciprocal-series s)
  (cons-stream 1
    (mul-series (sub-streams zeros (stream-cdr s))
                (reciprocal-series s))))

; test
; 1/(1-x) 的泰勒展开级数系数是 ones
; 因为 1/(1-x) 的倒数为 1-x, 级数系数是 1 -1 0 0 0 0 0 0 ...
(display-stream (reciprocal-series ones))
; 1
; -1
; 0
; 0
; 0
; 重复 0

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

(define (div-series s1 s2)
  (mul-series s1 (reciprocal-series s2)))

; test
(define integers
  (cons-stream 1 (add-streams ones integers)))

(define reciprocal
  (div-streams ones integers))

(define (integrate-series s)
  (mul-streams reciprocal s))

(define cosine-series
  (cons-stream 1 (integrate-series (sub-streams zeros sine-series))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

; 正切函数
(define tangent-series
  (div-series sine-series cosine-series))

(display-stream tangent-series)
; 0
; 1
; 0
; 1/3
; 0
; 2/15
; 0
; 17/315
; ...

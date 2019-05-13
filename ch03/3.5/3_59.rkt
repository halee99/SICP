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

(define ones (cons-stream 1 ones))

(define zeros (cons-stream 0 zeros))

(define integers
  (cons-stream 1 (add-streams ones integers)))

; a)
(define reciprocal
  (div-streams ones integers))

(define (integrate-series s)
  (mul-streams reciprocal s))

; test
; (display-stream (integrate-series integers))
; 1
; 1
; 1
; 1
; 重复 1


; b)
(define cosine-series
  (cons-stream 1 (integrate-series (sub-streams zeros sine-series))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

; test
; (display-stream cosine-series)
; 1
; 0
; -1/2
; 0
; 1/24
; 0
; -1/720
; ...

; (display-stream sine-series)
; 0
; 1
; 0
; -1/6
; 0
; 1/120
; ...

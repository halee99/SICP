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

; 原理
; (a0+a1+a2+a3+...)(b0+b1+b2+b3+...)
; a0(b0+b1+b2+b3+...) + (a1+a2+a3+...)(b0+b1+b2+b3+...)
; a0b0 + a0(b1+b2+b3+...) + (a1+a2+a3+...)(b0+b1+b2+b3+...)
(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1)
                  (stream-car s2))
               (add-streams
                 (mul-series (stream-cdr s1) s2)
                 (mul-streams (x-stream (stream-car s1)) (stream-cdr s2)))))

; get sin and cos for test
(define ones (cons-stream 1 ones))

(define zeros (cons-stream 0 zeros))

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

(display-stream
  (add-streams
    (mul-series cosine-series cosine-series)
    (mul-series sine-series sine-series)))
; 1
; 0
; 0
; 0
; 重复 0

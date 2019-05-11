#lang racket
(require "stream_utils.rkt")

(define ones (cons-stream 1 ones))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define integers-begin-two
  (cons-stream 2 (add-streams ones integers-begin-two)))


(define (mul-stream s1 s2)
  (stream-map * s1 s2))

(define factorials
  (cons-stream 1 (mul-stream integers-begin-two factorials)))

(stream-ref factorials 0)
; 1
(stream-ref factorials 1)
; 2
(stream-ref factorials 2)
; 6
(stream-ref factorials 3)
; 24
(stream-ref factorials 4)
; 120

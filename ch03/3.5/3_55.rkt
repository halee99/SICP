#lang racket
(require "stream_utils.rkt")

(define ones (cons-stream 1 ones))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define integers
  (cons-stream 1 (add-streams ones integers)))

(define (partial-sums s)
  (define streams
    (cons-stream (stream-car s)
                 (add-streams (stream-cdr s) streams)))
  streams)


(stream-ref (partial-sums integers) 0)
; 1
(stream-ref (partial-sums integers) 1)
; 3
(stream-ref (partial-sums integers) 2)
; 6
(stream-ref (partial-sums integers) 3)
; 10
(stream-ref (partial-sums integers) 4)
; 15

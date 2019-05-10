#lang racket
(require "stream_utils.rkt")

(define (stream-map proc . argstrams)
  (if (null? (car argstrams))
      the-empty-stream
      (cons-stream
        (apply proc
               (map (lambda (s) (stream-car s)) argstrams))
        (apply stream-map
               (cons
               proc
               (map (lambda (s) (stream-cdr s)) argstrams))))))


; test
(define one-ten (stream-enumerate-interval 0 10))

(stream-map (lambda (x) (* x x)) one-ten)
; (mcons 0 #<procedure:...stream_utils.rkt:28:4>)
(display-stream (stream-map + one-ten one-ten))
; 0
; 2
; 4
; 6
; 8
; 10
; 12
; 14
; 16
; 18
; 20'stream-for-each-done

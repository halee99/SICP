#lang racket
(require "stream_utils.rkt")

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define s (cons-stream 1 (add-streams s s)))

; s 是从 1 开始倍数为 2 的无穷流
; test
(display-stream s)
; 1
; 2
; 4
; 8
; 16
; 32

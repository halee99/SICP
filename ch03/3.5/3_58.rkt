#lang racket
(require "stream_utils.rkt")

(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) den radix)))


; (display-stream (expand 1 7 10))
; 1
; 4
; 2
; 8
; 5
; 7
; 重复 1 4 2 8 5 7

; (display-stream (expand 3 8 10))
; 3
; 7
; 5
; 0
; 0
; 重复 0

; 如果 (expand a b 10) 其中 a < b
; 可得 a 除以 b 的小数流

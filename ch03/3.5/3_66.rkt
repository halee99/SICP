#lang racket
(require "stream_utils.rkt")

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define ones (cons-stream 1 ones))

(define integers
  (cons-stream 1 (add-streams ones integers)))

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))

; (display-stream (pairs integers integers))
; (1 1)
; (1 2)
; (2 2)
; (1 3)
; (2 3)
; (1 4)
; (3 3)
; (1 5)
; (2 4)
; (1 6)
; (3 4)
; (1 7)
; (2 5)
; (1 8)
; (4 4)
; (1 9)
; ...

; 序列对 (1, 100) 之前大约有 99*2-1 = 197 个
; 序列对 (100, 100) 不知道

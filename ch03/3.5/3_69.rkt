#lang racket
(require "stream_utils.rkt")

(define (square x)
  (* x x))

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

(define (triples s t u)
  (cons-stream
    (list (stream-car s) (stream-car t) (stream-car u))
    (interleave
      (stream-map (lambda (x) (cons (stream-car s) x))
                  (pairs (stream-cdr s) (stream-cdr t)))
      (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(define pythagoras-triples
  (stream-filter
    (lambda (t)
      (let ((x (car t))
            (y (cadr t))
            (z (caddr t)))
            (= (+ (square x) (square y))
               (square z))))
    (triples integers integers integers)))

(display-stream pythagoras-triples)
; (3 4 5)
; (6 8 10)
; (5 12 13)
; (9 12 15)
; (8 15 17)
; (12 16 20)
; ... 计算量过大

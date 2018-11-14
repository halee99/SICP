#lang planet neil/sicp

(define x (list 1 2 3))
(define y (list 4 5 6))

(append x y)
(cons x y)
(list x y)
; list 会在末尾自动加一个 nil

#lang racket
(require "constraint_system.rkt")

(define (squarer a b)
  (multiplier a a b))


(define a (make-connector))
(define b (make-connector))
(squarer a b)
(probe "a" a)
(probe "b" b)

(set-value! a 5 'user)
(forget-value! a 'user)
(set-value! b 9 'user)

; 乘法器 multiplier 有三个参数.
; 如果用 multiplier 实现平方器 squarer:
; 当求平方时,
; 设置一个 squarer 参数相当于设置两个 multiplier 参数,
; 则可以自动求出另外一个参数.
; 当求平方根时,
; 设置一个 squarer 参数相当于只设置一个 multiplier 参数,
; 则不能自动求出另外两个参数, 即使这两个参数相等, 但我们未告知.

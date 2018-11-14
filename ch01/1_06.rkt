#lang racket

(define (average x y)
  (/ (+ x y) 2))

(define (improve guess x)
  (average guess (/ x guess)))

(define (good_enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (square x)
  (* x x))

(define (sqrt_iter guess x)
  (if (good_enough? guess x)
      guess
      (sqrt_iter (improve guess x)
                  x)))

(sqrt_iter 1.0 2)

(define (new_if predicate then_clause else_clause)
  (cond (predicate then_clause)
        (else else_clause)))

(define (sqrt_iter1 guess x)
  (new_if (good_enough? guess x)
    guess
    (sqrt_iter1 (improve guess x)
                x)))

; (sqrt_iter1 1.0 2)

; 运行结果是无限循环
; 因为解释器使用 应用序求值模型
; new_if 是函数，对 cond 的抽象
; new_if 的参数是一个递归，递归终止条件在 new_if 的 body
; 矛盾

#lang racket

(define f
  (let ((a 1))
    (lambda (x)
      (begin (set! a (* a x))
             a))))

; test
; 以下两句要分别运行

; (+ (f 0) (f 1))
; 0
; 可知对子表达式是从左到右求值

; (+ (f 1) (f 0))
; 1
; 用这个式子来模拟 (+ (f 0) (f 1)) 从右到左的结果

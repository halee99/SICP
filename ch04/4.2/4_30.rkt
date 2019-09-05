#lang racket

(require "../ch4-leval.rkt")

; todo，这题结果原文结论有点出入，不知道是否编译器不同的问题


; a)
; (let ((env the-global-environment))
;   (eval '(define (for-each proc items) (if (null? items) 'done (begin (proc (car items)) (for-each proc (cdr items))))) env)
;   (eval '(define (log1 x) (newline) (display x)) env)
;   (eval '(for-each (lambda (x) (newline) (display x)) (list 57 321 88)) env))

; 注释 ch4-leval 中的 eval-sequence 定义，将使用正文版本的 eval-sequence
; 我认为书本错了，(lambda (x) (newline) (display x)) 当做参数传给 for-each 的时候，会被 delay-it
; 而在 for-each 中由 begin 转为正文版本 eval-sequence 时，没有对带有 thunk 的 lambda 使用 force-it，解析出错


; b)

; (let ((env the-global-environment))
;   (eval '(define (p1 x) (set! x (cons x '(2))) x) env)
;   (eval '(define (p2 x) (define (p e) e x) (p (set! x (cons x '(2))))) env)
;   (announce-output (actual-value '(p1 1) env))
;   (announce-output (actual-value '(p2 1) env)))

; 都是 ((thunk 1 env) . 2)


; c)
; 不会有影响，如果不是 thunk 值会放回原值不会调用 actual-value


; d)
; i perfer Cy method

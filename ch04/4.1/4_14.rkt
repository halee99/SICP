#lang racket

(require "../ch4_mceval.rkt")

; (driver-loop)

; input: (define a (list 1 2))
; input: (map (lambda (x) (+ x 1)) a)

; application: not a procedure;
; expected a procedure that can be applied to arguments
;  given: (mcons 'procedure (mcons (mcons 'x '()) (mcons (mcons (mcons '+ (mcons 'x (mcons 1 '()))) '()) (mcons (mcons (mcons (mcons 'a (mcons 'false (mcons 'true (mcons 'car (mcons 'cdr (mcons 'cons (mcons 'null? (mcons 'list (mcons '+ (mcons '- (mcons '* (mcons...
;  arguments...:
;   1


; 如果使用系统 map, 解释器中传给 map 的第二个参数是待解析带有 'procedure 列表

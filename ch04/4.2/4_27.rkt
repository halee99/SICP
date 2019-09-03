#lang racket

(require "../ch4-leval.rkt")

(let ((env the-global-environment))
 (eval '(define count 0) env)
 (eval '(define (id x) (set! count (+ count 1)) x) env)
 (eval '(define w (id (id 10))) env)
 (announce-output (eval 'count env))
 (announce-output (eval 'w env))
 (announce-output (eval 'count env)))


; count -> 2  定义过程没有用到惰性求值
; w -> 10
; count -> 2 定义时已求值，并且“记忆”

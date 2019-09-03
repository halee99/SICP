#lang racket

(require "../ch4-leval.rkt")

(let ((env the-global-environment))
 (eval '(define count 0) env)
 (eval '(define (id x) (set! count (+ count 1)) x) env)
 (eval '(define (square x) (* x x)) env)
 (announce-output (eval '(square (id 10)) env))
 (announce-output (eval 'count env)))

; 有记忆功能
; 100
; 1

; 没有记忆功能
; 100
; 2

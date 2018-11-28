#lang planet neil/sicp

(define (mystery x)
    (define (loop x y)
        (if (null? x)
            y
            (let ((temp (cdr x)))
                (set-cdr! x y)
                (loop temp x))))
    (loop x '()))

(define v (list 'a 'b 'c 'd))
v
; (mcons 'a (mcons 'b (mcons 'c (mcons 'd '()))))

(define w (mystery v))
w
; (mcons 'd (mcons 'c (mcons 'b (mcons 'a '()))))
v
; (mcons 'a '())

; mystery 的工作与 reverse 一样

; v------------------------+
;                          |
;                          v
; w --> [*]----> [*]----> [*]----> '()
;        |        |        |
;        v        v        v
;        'c       'b       'a

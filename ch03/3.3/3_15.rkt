#lang planet neil/sicp

(define x (list 'a 'b))
(define z1 (cons x x))
(define z2 (cons (list 'a 'b) (list 'a 'b)))

(define (set-to-wow! x)
  (set-car! (car x) 'wow)
  x)

z1
; (mcons #0=(mcons 'a (mcons 'b '())) #0#)

(set-to-wow! z1)
; (mcons #0=(mcons 'wow (mcons 'b '())) #0#)

z2
; (mcons (mcons 'a (mcons 'b '())) (mcons 'a (mcons 'b '())))

(set-to-wow! z2)
; (mcons (mcons 'wow (mcons 'b '())) (mcons 'a (mcons 'b '())))



; 以下是 z1 执行 set-to-wow! 之后的盒子图形：
; z1 --> [*][*]
;         |  |
;         v  v
;  x --> [*][*]--> [*][/]
;         |         |
;         v         v
;       'wow!     'wow!
;
;
; 以下是执行 set-to-wow! 之后的 z2 的盒子图形：
; z2 --> [*][*]--> [*][*]--> [*][/]
;         |         |         |
;         |         v         v
;         |        'a        'b
;         |                   ^
;         |                   |
;         +------> [*][*]--> [*][/]
;                   |
;                   v
;                 'wow!

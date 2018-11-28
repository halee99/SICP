#lang planet neil/sicp
; 因为 racket 没有 set-car! set-cdr!

(define (append x y)
  (if (null? x)
      y
      (cons (car x) (append (cdr x) y))))

(define (append! x y)
  (set-cdr! (last-pair x) y)
  x)

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define x (list 'a 'b))
(define y (list 'c 'd))
(define z (append  x y))
z
; (mcons 'a (mcons 'b (mcons 'c (mcons 'd '()))))
(cdr x)
; (mcons 'b '())

(define w (append! x y))
w
; (mcons 'a (mcons 'b (mcons 'c (mcons 'd '()))))
(cdr x)
; (mcons 'b (mcons 'c (mcons 'd '())))



; x --> [*]----> [*]----> '()
;        |        |
;        v        v
;        'a       'b
;
; y --> [*]----> [*]----> '()
;        |        |
;        v        v
;        'c       'd
;
; z --> [*]---->[*]---->[*]---->[*]----> '()
;        |       |       |       |
;        v       v       v       v
;       'a      'b      'c      'd
; 之后，继续进行输入：
; (cdr x)
;
; (b)
;
; 1 ]=> (define w (append! x y))  ; 这个是修改函数
; w
;
; (cdr x)
; (b c d)
; 这时几个变量的盒子图形为：
; w------+
;        |
;        |
;        v
; x --> [*]----> [*]----+
;        |        |     |
;        v        v     |
;        'a       'b    |
;                       |
;        +--------------+
;        |
;        v
; y --> [*]----> [*]----> '()
;        |        |
;        v        v
;        'c       'd
;
; z --> [*]---->[*]---->[*]---->[*]----> '()
;        |       |       |       |
;        v       v       v       v
;       'a      'b      'c      'd

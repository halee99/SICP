#lang planet neil/sicp

; 懒得猜
; https://sicp.readthedocs.io/en/latest/chp3/16.html
(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1)))

; 有环的序对就会无限循环无法返回
(define crycle (cons 1 (cons 2 (cons 3 '()))))

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(set-cdr! (last-pair crycle) crycle)

; (count-pairs crycle)

; 盒模图形如下
;             +--------------+
;             |              |
;             v              |
; crycle --> [*]---> [*]-----+
;             |       |
;             v       v
;             1       2


; 返回 3 的序对
(define three (cons (cons 1 '()) (cons 2 '())))
(count-pairs three)

; three --> [*]---> [*]---> [/]
;            |       |
;            |       v
;            |       2
;            v
;           [*]---> [/]
;            |
;            v
;            1


; 返回 4 的序对
(define two (cons 1 (cons 2 '())))
(define four (cons two (cdr two)))
(count-pairs four)

;        [*]------+
;          |       |
;          |       |
;          v       v
; two --> [*]---> [*]---> [/]
;          |       |
;          v       v
;          1       2


; 返回 7 的序对
(define one (list 1))
(define three-2 (cons one one))
(define seven (cons three-2 three-2))
(count-pairs seven)

; seven --> [*]
;           ||
;           ||
;           vv
; three --> [*]
;           ||
;           ||
;           vv
;   one --> [*]---> [/]
;            |
;            v
;            1

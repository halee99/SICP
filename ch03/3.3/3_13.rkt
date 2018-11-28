#lang planet neil/sicp

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define z (make-cycle (list 'a 'b 'c)))
z
; #0=(mcons 'a (mcons 'b (mcons 'c #0#)))
;
;          +-----------------------+
;          |                       |
;          v                       |
; z ----> [*]----> [*]----> [*]----+
;          |        |        |
;          v        v        v
;         'a       'b       'c

; (last-pair z)
; 会无限循环

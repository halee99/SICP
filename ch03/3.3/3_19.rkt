#lang planet neil/sicp

; a 步进为 1, b 步进为 2, 同时循环，相遇有环，其中一个遇到 nil 无环
(define (cycle? x)
  ; a
  (define (iter a b)
    (cond ((null? a)
            #f)
          ((null? b)
            #f)
          ; 为了下文能执行 (cddr b)
          ((null? (cdr b))
            #f)
          ((eq? a b)
            #t)
          (else
            (iter (cdr a) (cddr b)))))
  (cond ((null? x)
          #f)
        ((null? (cdr x))
          #f)
        (else
          (iter x (cdr x)))))

;
(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define z (make-cycle (list 'a 'b 'c)))

(cycle? z)
(cycle? (list 1 2 3 4 5))

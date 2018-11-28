#lang planet neil/sicp

; 检查是否有环
(define (in-list? marks x)
  (cond ((null? marks)
          #f)
        ((eq? (car marks) x)
          #t)
        (else
          (in-list? (cdr marks) x))))

(define (cycle? x)
  (let ((marks '()))
    (define (iter x)
      (cond ((null? x)
              #f)
            ((in-list? marks x)
              #t)
            (else
              (begin (set! marks (cons x marks))
                     (iter (cdr x))))))
    (iter x)))


; 环
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

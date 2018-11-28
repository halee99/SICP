#lang planet neil/sicp

(define (count-pairs x)
  (let ((marks '()))
    (define (in-marks? marks x)
      (cond ((null? marks)
              #f)
            ((eq? (car marks) x)
              #t)
            (else
              (in-marks? (cdr marks) x))))

    (define (iter x)
      (cond ((not (pair? x))
              0)
            ; 访问过
            ((in-marks? marks x)
              0)
            (else
              (begin (set! marks (cons x marks))
                     (+ (iter (car x))
                        (iter (cdr x))
                        1)))))
    (iter x)))


(define three (cons (cons 1 '()) (cons 2 '())))
(count-pairs three)
; 3

(define two (cons 1 (cons 2 '())))
(define four (cons two (cdr two)))
(count-pairs four)
; 3

(define one (list 1))
(define three-2 (cons one one))
(define seven (cons three-2 three-2))
(count-pairs seven)
; 3

(define crycle (cons 1 (cons 2 (cons 3 '()))))
(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))
(set-cdr! (last-pair crycle) crycle)
(count-pairs crycle)
; 3

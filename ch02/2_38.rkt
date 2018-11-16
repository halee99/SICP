#lang planet neil/sicp

(define (fold-right op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (fold-right op initial (cdr sequence)))))


(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(fold-right / 1 (list 1 2 3))
(fold-left / 1 (list 1 2 3))
(fold-right list nil (list 1 2 3))
(fold-left list nil (list 1 2 3))
;
; 3/2
; 1/6
; (mcons 1 (mcons (mcons 2 (mcons (mcons 3 (mcons '() '())) '())) '()))
; (mcons (mcons (mcons '() (mcons 1 '())) (mcons 2 '())) (mcons 3 '()))

; op 应该具备交换律
; 如 (op x y) = (op y x)
; 这类 op 典型的有 +, *,

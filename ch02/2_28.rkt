#lang planet neil/sicp

; 将树叶也化成表，用 append 函数同一处理，就不用过多考虑 nil情况
(define (fringe tree)
  (define (rec tr)
    (cond ((null? tr) ; 如果是空树
            nil)
          ((not (pair? tr)) ; 如果是树叶
            (list tr))
          (else
            (append (rec (car tr))
                    (rec (cdr tr))))))
  (rec tree))

(define x (list (list 1 2) (list 3 4)))
(fringe x)
(fringe (list x x))

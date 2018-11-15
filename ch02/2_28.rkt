#lang planet neil/sicp

; 将树叶也化成表，用 append 函数同一处理，就不用过多考虑 nil情况
(define (fringe tree)
  (cond ((null? tree) ; 如果是空树
          nil)
        ((not (pair? tree)) ; 如果是树叶
          (list tree))
        (else
          (append (fringe (car tree))
                  (fringe (cdr tree))))))

(define x (list (list 1 2) (list 3 4)))
(fringe x)
(fringe (list x x))

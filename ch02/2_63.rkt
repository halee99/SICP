#lang racket

(require "set-tree.rkt")

(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
              (cons (entry tree)
                    (tree->list-1 (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
  (copy-to-list tree '()))

; a)
(define (list2tree lt)
  (define (iter lt tree)
    (if (null? lt)
        tree
        (iter (cdr lt) (adjoin-set (car lt) tree))))
  (iter lt '()))

(define t1 (list2tree '(7 3 9 1 5 11)))
(define t2 (list2tree '(3 1 7 5 9 11)))
(define t3 (list2tree '(5 3 9 1 7 11)))

(tree->list-1 t1)
(tree->list-2 t1)
(tree->list-1 t2)
(tree->list-2 t2)
(tree->list-1 t3)
(tree->list-2 t3)
; 都是 '(1 3 5 7 9 11)
; 这两个算法都是树的中序遍历 对排序树遍历得到递增有序表

;b)
; tree->list-1 用到 append 操作，append 时间复杂度为 O(n)
; 所以 tree->list-1 时间复杂度为 O(n^2)
; tree->list-2 只用到 cons cons 时间复杂度为 O(1)
; 所以 tree->list-2 时间复杂度为 O(n)

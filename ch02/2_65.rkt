#lang racket

(require "set-tree.rkt")

(define (intersection-set set1 set2)
  (if (or (null? set1) (null? set2))
      '()
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1
                     (intersection-set (cdr set1)
                                       (cdr set2))))
              ((< x1 x2)
               (intersection-set (cdr set1) set2))
              ((< x2 x1)
               (intersection-set set1 (cdr set2)))))))

;
(define (union-set set1 set2)
  (cond ((null? set1)
          set2)
        ((null? set2)
          set1)
        (else
          (let ((x1 (car set1)) (x2 (car set2)))
            (cond ((= x1 x2)
                    (cons x1
                          (union-set (cdr set1)
                                     (cdr set2))))
                  ((< x1 x2)
                    (cons x1
                          (union-set (cdr set1) set2)))
                  ((< x2 x1)
                    (cons x2
                          (union-set set1 (cdr set2)))))))))


(define (intersection-tree tree1 tree2)
  (list->tree
    (intersection-set (tree->list tree1)
                      (tree->list tree2))))

;
(define (union-tree tree1 tree2)
  (list->tree
    (union-set (tree->list tree1)
               (tree->list tree2))))

; test
(define (list2tree lt)
  (define (iter lt tree)
    (if (null? lt)
        tree
        (iter (cdr lt) (adjoin-set (car lt) tree))))
  (iter lt '()))
(define a (list->tree (list 1 3 5 7)))
(define b (list->tree (list 0 3 7 8 9)))

(intersection-tree a b)
(union-tree a b)

;tree->list list->tree intersection-set union-set
; 以上四种函数时间复杂度都是 O(n)
; 对以上函数有限 O(1) 次组合成的 intersection-tree union-trees 时间复杂度也为 O(n)

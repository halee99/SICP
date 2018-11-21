#lang racket

(require "huffman.rkt")

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (successive-merge trees)
  (if (null? (cdr trees))
      (car trees)
      (let ((first-tree (car trees))
            (second-tree (cadr trees))
            (remain-trees (cddr trees)))
        (let ((merge-tree (make-code-tree first-tree
                                          second-tree)))
          (successive-merge (adjoin-set merge-tree
                                        remain-trees))))))

; test
(define sample-leafs '((C 1) (D 1) (B 2) (A 4)))
(define sample-tree (generate-huffman-tree sample-leafs))
(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

(decode sample-message sample-tree)
; '(A D A B B C A)

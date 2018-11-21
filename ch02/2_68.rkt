#lang racket

(require "huffman.rkt")

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

(define (encode-symbol x tree)
  (cond ((and (leaf? tree) (eq? x (symbol-leaf tree))
          '()))
        ((element-of-set? x (symbols (left-branch tree)))
          (cons '0 (encode-symbol x (left-branch tree))))
        ((element-of-set? x (symbols (right-branch tree)))
          (cons '1 (encode-symbol x (right-branch tree))))
        (else
          (error "bad letter -- encode-symbol" x))))

; test
(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree
                    (make-leaf 'B 2)
                    (make-code-tree (make-leaf 'D 1)
                                    (make-leaf 'C 1)))))

(encode '(A D A B B C A) sample-tree)
; '(0 1 1 0 0 1 0 1 0 1 1 1 0)

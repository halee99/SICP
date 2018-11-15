#lang planet neil/sicp

(define (square x)
  (* x x))

(define (tree_map proc items)
  (map (lambda (sub_items)
          (if (pair? sub_items)
              (tree_map proc sub_items)
              (proc sub_items)))
       items))

(define (square_tree tree)
  (tree_map square tree))

;
(square_tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

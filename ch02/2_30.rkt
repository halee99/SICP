#lang planet neil/sicp

(define (square x)
  (* x x))

(define (square_tree tree)
  (map (lambda (sub_tree)
          (if (pair? sub_tree)
              (square_tree sub_tree)
              (square sub_tree)))
       tree))
;
(square_tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

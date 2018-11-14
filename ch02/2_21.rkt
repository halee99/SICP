#lang planet neil/sicp

(define (square x)
  (* x x))

(define (square_list_1 items)
  (if (null? items)
      nil
      (cons (square (car items))
            (square_list_1 (cdr items)))))

(define (square_list_2 items)
  (map square items))

(square_list_1 (list 1 2 3 4))
(square_list_2 (list 1 2 3 4))

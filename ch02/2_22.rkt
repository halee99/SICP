#lang planet neil/sicp

(define (square x)
  (* x x))

; Louis Reasoner 重写
(define (square_list_1 items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter items nil))
; Louis 修订
(define (square_list_2 items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil))

(square_list_1 (list 1 2 3 4))
(square_list_2 (list 1 2 3 4))

; (mcons 16 (mcons 9 (mcons 4 (mcons 1 '()))))
; (mcons (mcons (mcons (mcons '() 1) 4) 9) 16)

; 虽然 Louis 写的是迭代版本，但是实际运行过程依然是 “先进后出”

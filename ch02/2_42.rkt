#lang racket

(require "utils.rkt")

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
          (lambda (positions) (safe? k positions))
          (flatmap  (lambda (rest-of-queens)
                      (map  (lambda (new-row)
                              (adjoin-position new-row k rest-of-queens))
                            (enumerate-interval 1 board-size)))
                    (queen-cols (- k 1))))))
  (queen-cols board-size))

(define (adjoin-position row col rest-of-queens)
  (cons (cons row col)
        rest-of-queens))

(define empty-board nil)

(define (non-attack? a b)
  (define a1 (car a))
  (define a2 (cdr a))
  (define b1 (car b))
  (define b2 (cdr b))
  (not (or (= a1 b1)
           (= a2 b2)
           (= (- a1 b1) (- a2 b2))
           (= (- b1 a1) (- a2 b2)))))

(define (safe? k positions)
  (define x (car positions))
  (define (rec ps)
    (if (null? ps)
        #t
        (and (non-attack? x (car ps))
             (rec (cdr ps)))))
  ; (display (rec (cdr positions)))
  (rec (cdr positions)))

(length (queens 8))
; 八皇后的解有 92 种

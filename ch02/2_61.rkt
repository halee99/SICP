#lang racket

(define (adjoin-set x set)
  (if (null? set)
      (list x)
      (let ((a (car set)))
        (cond ((= x a) set)
              ((< x a)
                (cons x set))
              ((> x a)
                (cons a (adjoin-set x (cdr set))))))))

; test
(define a (list 1 3 5 6 7))
(adjoin-set 4 a)
(adjoin-set 3 a)
(adjoin-set 9 a)

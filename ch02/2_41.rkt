#lang racket

(require "utils.rkt")

(define (unique-triples n)
  (flatmap
    (lambda (i)
      (flatmap  (lambda (j)
                (map (lambda (k) (list k j i))
                     (enumerate-interval 1 (- j 1))))
                (enumerate-interval 1 (- i 1))))
    (enumerate-interval 1 n)))

(define (sum-triples-equal-s n s)
  (define (equal-s? triple)
    (= (+ (car triple)
          (cadr triple)
          (caddr triple))
       s))
  (filter equal-s? (unique-triples n)))

(sum-triples-equal-s 10 20)

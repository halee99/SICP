#lang racket

(require "utils.rkt")

(define (unique-threes n)
  (flatmap
    (lambda (i)
      (map (lambda (j)
            ((map (lambda (k) (list i j k))
                  (enumerate-interval 1 (- j 1)))))
           (enumerate-interval 1 (- i 1))))
   (enumerate-interval 1 n)))

(unique-threes 6)

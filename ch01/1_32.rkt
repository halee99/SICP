#lang planet neil/sicp

(define (accumulate combiner null_value term a next b)
  (if (> a b)
      null_value
      (combiner (term a)
         (accumulate combiner null_value term (next a) next b))))

(define (accumulate_iter combiner null_value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a)
              (combiner result
                        (term a)))))
  (iter a null_value))

(accumulate_iter (lambda (x y) (* x y))
                 1
                 (lambda (x) x)
                 1
                 (lambda (x) (+ x 1))
                 5)

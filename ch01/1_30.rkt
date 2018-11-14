#lang planet neil/sicp

; 线性递归
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

; 迭代
(define (sum_iter term a next b)
  (define (iter result a)
      (if (> a b)
          result
          (iter (+ result (term a)) (next a))))
  (iter 0 a))


(sum_iter (lambda (x) x)
          1
          (lambda (x) (+ x 1))
          10)

(sum_iter (lambda (x) (* x x x))
          1
          (lambda (x) (+ x 1))
          10)

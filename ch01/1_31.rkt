#lang planet neil/sicp

(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))

(define (product_iter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a)
              (* result (term a)))))
  (iter a 1))


(product_iter (lambda (x) x)
              1
              (lambda (x) (+ x 1))
              5)
;numerator denominator
(define (pi_get n)
  (define (numerator k)
    (if (even? k)
        (+ k 2)
        (+ k 1)))
  (define (denominator k)
    (if (even? k)
        (+ k 1)
        (+ k 2)))
  (define (factor k)
    (/ (numerator k)
       (denominator k)
       1.0))
  (define (next i)
    (+ i 1))
  (* (product_iter factor 1 next n)
     4.0))

(pi_get 10000)
(pi_get 100000000)

#lang planet neil/sicp

; 迭代
(define (cont_frac_iter n d k)
  (define (iter i result)
    (if (= i 0)
        result
        (iter (- i 1)
              (/ (n i) (- (d i) result)))))
  (iter k 0.0))

(define (tan_new x)
  (define (n i)
    (if (= i 1)
        x
        (* x x)))
  (define (d i)
    (- (* 2 i) 1))
  (cont_frac_iter n d 100))

(tan 0)
(tan_new 0)
(tan 3.14)
(tan_new 3.14)

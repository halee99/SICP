#lang racket

(define (fib_iter a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib_iter a
                  b
                  (+ (* p p) (* q q))
                  (+ (* 2 p q) (* q q))
                  (/ count 2)))
        (else (fib_iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))

(define (fib n)
  (fib_iter 1 0 0 1 n))


(define (fib_linear a b count)
  (if (= count 0)
      b
      (fib_linear (+ a b) a (- count 1))))

(define (fib_lin n)
  (fib_linear 1 0 n))

(fib_lin 10)
(fib 10)

#lang racket

(define (fast_expt a b n)
  (cond ((= n 0) a)
        ((even? n) (fast_expt a (square b) (/ n 2)))
        (else (fast_expt (* a b) b (- n 1)))))

(define (even? n)
  (= (remainder n 2) 0))

(define (square x)
  (* x x))

(define (expt b n)
  (fast_expt 1 b n))

(expt 2 10)

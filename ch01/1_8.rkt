#lang racket

(define (improve guess x)
  (/ (+ (/ x (* guess guess)) (* 2 guess)) 3))

(define (good_enough? guess x)
  (< (abs (- (cube guess) x)) 0.001))

(define (cube x)
  (* x x x))

(define (cubic_root_iter guess x)
  (if (good_enough? guess x)
      guess
      (cubic_root_iter (improve guess x)
                  x)))


(cubic_root_iter 1.0 27)
(cube (cubic_root_iter 1.0 27))

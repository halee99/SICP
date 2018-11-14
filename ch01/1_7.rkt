#lang racket

(define (average x y)
  (/ (+ x y) 2))

(define (improve guess x)
  (average guess (/ x guess)))

(define (good_enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (square x)
  (* x x))

(define (sqrt_iter guess x)
  (if (good_enough? guess x)
      guess
      (sqrt_iter (improve guess x)
                  x)))


; (sqrt_iter 1.0 1e-32)
; (sqrt_iter 1.0 2e+32)

; 当计算一个比误差值小的平方根时，牛顿法不work
; 当计算一个比精度范围大的平方根时，溢出，牛顿法不work


(define (well_enough? guess pre_guess)
    (< (/ (abs (- guess pre_guess)) guess) 1e-16))

(define (sqrt_iter2 guess pre_guess x)
    (if (well_enough? guess pre_guess)
        guess
        (sqrt_iter2 (improve guess x)
                    guess
                    x)))

; (sqrt_iter2 1.0 0.1 4)
;
(sqrt_iter2 1.0 0.1 1e-32)
(sqrt_iter2 1.0 0.1 4e+128)
;; work

#lang racket

(define (cube x)
  (* x x x))

(define (p x)
  (- (* 3 x) (* 4 (cube x))))

(define (sine angle)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))))

(sine 12.15)

; a)
; 12.15, 4.05, 1.35, 0.45, 0.15, 0.05(停止，不使用 p)
; 所以 p 被调用 5 次

; b)
; 空间复杂度 O(log3 a)
; 时间复杂度 O(log3 a)

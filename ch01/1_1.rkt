#lang racket

;; 10
10

;; 12
(+ 5 3 4)

;; 8
(- 9 1)

;; 3
(/ 6 2)

;; 6
(+ (* 2 4) (- 4 6))

(define a 3)
(define b (+ a 1))

;; 19
(+ a b (* a b))

;; false
(= a b)

;; 4
(if (and (> b a) (< b (* a b)))
  b
  a)

;; 16
(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))

;; 6
(+ 2 (if (> b a) b a))

;; 16
(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
  (+ a 1))

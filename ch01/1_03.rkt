#lang racket

(define (min a b)
  (if (> a b) b a))

(define (min-three a b c)
  (min a (min b c)))

(define (add-two-max a b c)
  (- (+ a b c) (min-three a b c)))

(define (test-equal a b)
  (= a b))

(test-equal (add-two-max 1 2 3) 5)
(test-equal (add-two-max 1 2 2) 4)
(test-equal (add-two-max 3 4 2) 7)

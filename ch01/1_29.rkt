#lang planet neil/sicp

(define (cube x)
  (* x x x))

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))


(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2)) add-dx b)
     dx))

(newline)
(display "common integral")
(newline)
(integral cube 0 1 0.01)
(integral cube 0 1 0.001)

; Simpson 积分法
(define (simpson_integral f a b n)
  (define h (/ (- b a) (* n 1.0)))
  (define (para k)
     (+ a (* k h)))
  (define (factor k)
     (cond ((= k 0) 1)
           ((= k n) 1)
           ((even? k) 2)
           (else 4)))
  (define (term x)
     (* (factor x)
        (f (para x))))
  (define (next i)
     (+ i 1))
  (* (/ h 3.0)
     (sum term 0 next n)))

(newline)
(display "Simpson integral")
(newline)
(simpson_integral cube 0 1 100)
(simpson_integral cube 0 1 1000)

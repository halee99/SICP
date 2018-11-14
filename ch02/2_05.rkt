#lang planet neil/sicp

(define (cons a b)
  (* (expt 2 a)
     (expt 3 b)))

(define (car z)
  (cond ((= (remainder z 2) 1)
          0)
        (else
          (+ 1 (car (/ z 2))))))

(define (cdr z)
  (cond ((= (remainder z 3) 1)
          0)
        ((= (remainder z 3) 2)
          0)
        (else
          (+ 1 (cdr (/ z 3))))))


(car (cons 4 5))
(car (cons 0 5))
(cdr (cons 4 3))
(cdr (cons 4 0))

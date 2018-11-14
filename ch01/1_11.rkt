#lang racket

(define (foo n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        ((= n 2) 2)
        (else (+ (* 1 (foo (- n 1)))
                 (* 2 (foo (- n 2)))
                 (* 3 (foo (- n 3)))))))

(define (f n)
  (f_iter 2 1 0 n))

(define (f_iter a b c count)
  (define (operation x y z)
      (+ (* 1 x)
         (* 2 y)
         (* 3 z)))

  (if (= count 0)
      c
      (f_iter (operation a b c)
              a
              b
              (- count 1))))

(f 35)
(foo 35)

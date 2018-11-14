#lang planet neil/sicp

; 迭代
(define (cont_frac_iter n d k)
  (define (iter i result)
    (if (= i 0)
        result
        (iter (- i 1)
              (/ (n i) (+ (d i) result)))))
  (iter k 0.0))

(define (d i)
  (cond ((= (remainder i 3) 0) 1)
        ((= (remainder i 3) 1) 1)
        (else (- (+ i 1) (/ (+ i 1) 3)))))

(define e
  (+ (cont_frac_iter (lambda (i) 1)
                     d
                     100)
     2))

e

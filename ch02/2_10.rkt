#lang planet neil/sicp

(define (div-interval x y)
  (cond ((= (lower_bound y) 0 )
          (error "0 不能为除数"))
        ((= (upper_bound y) 0 )
          (error "0 不能为除数"))
        (else
          (mul_interval
            x
            (make_interval (/ 1.0 (upper_bound y))
                           (/ 1.0 (lower_bound y)))))))

#lang planet neil/sicp

(define (square x)
  (* x x))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
              (remainder (square (expmod base (/ exp 2) m))
                         m))
         (else
              (remainder (* base (expmod base (- exp 1) m))
                         m))))

; random 参数范围 1-4294967087
(define (fermat_test n)
  (define (try_it a)
    (= (expmod a n n) a))
  (if (< n 4294967087)
      (try_it (+ 1 (random (- n 1))))
      (try_it (+ 1 (random 4294967087)))))

(define (fast_prime? n times)
  (cond ((= times 0) true)
        ((fermat_test n) (fast_prime? n (- times 1)))
        (else false)))

(define (prime? n)
  (fast_prime? n 20))

(define (carmichael n)
  (newline)
  (display " carmichael ")
  (display n)
  (display " ")
  (if (prime? n)
      (display "is prime")
      (display "isn't prime"))
  )

; carmichael数，561 1105 1729 2465 2821 6601
(carmichael 561)
(carmichael 1105)
(carmichael 1729)
(carmichael 2465)
(carmichael 2821)
(carmichael 6601)

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

; prime test
(define (timed_prime_test n)
  ; (newline)
  ; (display n)
  (start_prime_test n (runtime)))

(define (start_prime_test n start_time)
  (if (prime? n)
      (report_prime n (- (runtime) start_time))
      false))

(define (report_prime n elapsed_time)
  (newline)
  (display n)
  (display " *** ")
  (display elapsed_time)
  true)


(define (search_for_primes b e count)
  (cond ((> b e) (display " out of range"))
        ((= count 0) (display " end"))
        (else (if (timed_prime_test b)
                  (search_for_primes (+ b 1)
                                     e
                                     (- count 1))
                  (search_for_primes (+ b 1)
                                     e
                                     count)))))


(search_for_primes 10000000000 100000000000 3)
(search_for_primes 100000000000 1000000000000 3)
(search_for_primes 1000000000000 10000000000000 3)
(search_for_primes 10000000000000 100000000000000 3)

; 10000000019 *** 997
; 10000000033 *** 963
; 10000000061 *** 0 end
; 100000000003 *** 0
; 100000000019 *** 0
; 100000000057 *** 0 end
; 1000000000039 *** 0
; 1000000000061 *** 0
; 1000000000063 *** 0 end
; 10000000000037 *** 0
; 10000000000051 *** 0
; 10000000000099 *** 1003 end

; CPU 速度过快，且进程调度占无用计算过大，导致得不到理想的数据
; 就不讨论时间复杂度啦    O(logn)

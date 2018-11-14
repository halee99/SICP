#lang planet neil/sicp

(define (square x)
  (* x x))

(define (fast_expt a b n)
  (cond ((= n 0) a)
        ((even? n) (fast_expt a (square b) (/ n 2)))
        (else (fast_expt (* a b) b (- n 1)))))

(define (f_expt b n)
  (fast_expt 1 b n))

(define (expmod base exp m)
  (remainder (f_expt base exp) m))

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

; (search_for_primes 10000 100000 3)
; (search_for_primes 10000000000 100000000000 3)
; (search_for_primes 100000000000 1000000000000 3)
; (search_for_primes 1000000000000 10000000000000 3)
; (search_for_primes 10000000000000 100000000000000 3)

; 不能快速素检查程序。因为大数乘法运算花费大把时间

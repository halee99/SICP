#lang planet neil/sicp

(define (square x)
  (* x x))

(define (expmod base exp m)
  (define (miller_rabin? x)
      ; x != 1, x != m - 1, exp ！= m - 1
      (and (not (= x 1))
           (not (= x (- m 1)))
           ; miller rabin 检查
           (= (remainder (square x) m) 1)))
  (cond ((= exp 0) 1)
        ((miller_rabin? base) 0)
        ((even? exp)
              (remainder (square (expmod base (/ exp 2) m))
                         m))
         (else
              (remainder (* base (expmod base (- exp 1) m))
                         m))))


; random 参数范围 1-4294967087
(define (non_zero_random n)
  (let ((r (random n)))
       (if (= r 0)
           (non_zero_random n)
           r)))

(define (miller_test n)
  (define (try_it a)
      (= (expmod a (- n 1) n) 1))
  (if (< n 4294967087)
      (try_it (+ 1 (non_zero_random (- n 1))))
      (try_it (+ 1 (non_zero_random 4294967087)))))

(define (fast_prime? n times)
  (cond ((= times 0) true)
        ((miller_test n) (fast_prime? n (- times 1)))
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

(search_for_primes 10000000000 100000000000 3)
(search_for_primes 100000000000 1000000000000 3)
(search_for_primes 1000000000000 10000000000000 3)
(search_for_primes 10000000000000 100000000000000 3)

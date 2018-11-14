#lang planet neil/sicp

; prime
(define (smallest_divisor n)
  (find_divisor n 2))

(define (square x)
  (* x x))

(define (next n)
  (if (= n 2)
      3
      (+ n 2)))

(define (find_divisor n test_divisor)
  (cond ((> (square test_divisor) n) n)
        ((divides? test_divisor n) test_divisor)
        (else (find_divisor n (next test_divisor)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest_divisor n)))

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

; (search_for_primes 1000 10000 3)
; (search_for_primes 10000 100000 3)
(search_for_primes 10000000000 100000000000 3)
(search_for_primes 100000000000 1000000000000 3)
(search_for_primes 1000000000000 10000000000000 3)
(search_for_primes 10000000000000 100000000000000 3)



; 10000000019 *** 997
; 10000000033 *** 966
; 10000000061 *** 973 end
; 100000000003 *** 1995
; 100000000019 *** 1996
; 100000000057 *** 1995 end
; 1000000000039 *** 5983
; 1000000000061 *** 7214
; 1000000000063 *** 5996 end
; 10000000000037 *** 18950
; 10000000000051 *** 21229
; 10000000000099 *** 18986 end

; 与 22 题相比基本符合 2 倍的预期
; 对于大于 10000000000 素数的测试，与22题 1：1 的关系
; 我认为是数据值过小的原因，无用计算占比大

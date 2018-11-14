#lang planet neil/sicp

; prime
(define (smallest_divisor n)
  (find_divisor n 2))

(define (square x)
  (* x x))

(define (find_divisor n test_divisor)
  (cond ((> (square test_divisor) n) n)
        ((divides? test_divisor n) test_divisor)
        (else (find_divisor n (+ test_divisor 1)))))

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


; 由于测试机 CPU 速度太快，且 racket 的时间库精度不够
; 修改为以上数据
; 得到运行时间如下
; 10000000019 *** 997
; 10000000033 *** 997
; 10000000061 *** 997 end
; 100000000003 *** 4986
; 100000000019 *** 3990
; 100000000057 *** 3991 end
; 1000000000039 *** 11955
; 1000000000061 *** 11968
; 1000000000063 *** 11968 end
; 10000000000037 *** 37906
; 10000000000051 *** 37901
; 10000000000099 *** 37906 end

; 1000 * sqrt(10) = 3162
; 4000 * sqrt(10) = 12649
; 12000 * sqrt(10) = 37947
; 考虑到误差和打印时间，正比 10^(0.5)
; 数据值越大， 越接近比值 10^(0.5)

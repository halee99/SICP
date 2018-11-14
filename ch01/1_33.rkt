#lang planet neil/sicp

; 递归
(define (filtered_accmulate filter combiner null_value term a next b)
  (cond ((> a b) null_value)
        ((filter (term a))
         (combiner (term a)
             (filtered_accmulate filter combiner null_value term (next a) next b)))
        (else (filtered_accmulate filter combiner null_value term (next a) next b))))

; 迭代
(define (filtered_accmulate_iter filter combiner null_value term a next b)
  (define (iter a result)
    (cond ((> a b) result)
          ((filter (term a))
           (iter (next a)
                 (combiner result (term a))))
          (else (iter (next a) result))))
  (iter a null_value))

; 素数检查
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
  (if (< n 2)
      false
      (= n (smallest_divisor n))))

; 最大公约数
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))


(define (sum_prime_a2b a b)
  (filtered_accmulate_iter prime?
                      (lambda (x y) (+ x y))
                      0
                      (lambda (x) x)
                      a
                      (lambda (x) (+ x 1))
                      b))

(define (mul_coprime n)
  ; 互素 coprime
  (define (coprime? x)
    (= (gcd x n) 1))
  (filtered_accmulate_iter coprime?
                           (lambda (x y) (* x y))
                           1
                           (lambda (x) x)
                           1
                           (lambda (x) (+ x 1))
                           (- n 1)))

(sum_prime_a2b 1 10)
(mul_coprime 5)
(mul_coprime 10)

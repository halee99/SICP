#lang planet neil/sicp

(define us_coins (list 50 25 10 5 1))

(define uk_coins (list 100 50 20 10 5 2 1 0.5))

(define (cc amount coin_values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no_more? coin_values)) 0)
        (else
         (+ (cc amount
                (except_first_denomination coin_values))
            (cc (- amount
                   (first_denomination coin_values))
                coin_values)))))

(define (no_more? coin_values)
  (= (length coin_values) 0))

(define (first_denomination coin_values)
  (car coin_values))

(define (except_first_denomination coin_values)
  (cdr coin_values))


(cc 100 us_coins)
(define us_coins_reverse (list 1 5 10 25 50))
(cc 100 us_coins_reverse)

; 表 coin_values 的排序顺序不会影响 cc 给出的回答
; 这个算法是个穷举法

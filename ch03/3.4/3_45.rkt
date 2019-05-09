#lang racket
(require "make_serializer.rkt")

; 原版
(define (make-account-and-serializer balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) balance-serializer)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

; 3.45 版
(define (make-account-and-serializer-45 balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (balance-serializer withdraw))
            ((eq? m 'deposit) (balance-serializer deposit))
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) balance-serializer)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

(define (deposit account amount)
 ((account 'deposit) amount))

(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
                       (account2 'balance))))
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))

(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer)))
    ((serializer1 (serializer2 exchange))
     account1
     account2)))

; test
; 原版
(define peter-acc (make-account-and-serializer 100))
(define mary-acc (make-account-and-serializer 50))
(serialized-exchange peter-acc mary-acc)

(log "peter-acc" (peter-acc 'balance))
(log "mary-acc" (mary-acc 'balance))

; 45版 死锁
; (define peter-acc-45 (make-account-and-serializer-45 100))
; (define mary-acc-45 (make-account-and-serializer-45 50))
; (serialized-exchange peter-acc-45 mary-acc-45)
;
; (log "peter-acc" (peter-acc-45 'balance))
; (log "mary-acc" (mary-acc-45 'balance))

; Louis的推理是错误的,
; 如, serialized-exchange 中并且还未结束,
; peter-acc 的 mutex 还未释放, 需要等 serialized-exchange 结束才能释放 mutex
; 而 serialized-exchange 需要 peter-acc 的 withdraw 需要获取peter-acc 的 mutex
; 所以
; serialized-exchange 的结束条件是 withdraw 完成, 才能释放 mutex
; withdraw 的开始条件是 mutex 被释放, 即 serialized-exchange 结束
; 产生死锁🔒 无限循环

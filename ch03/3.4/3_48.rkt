#lang racket
(require "make_serializer.rkt")

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
            ((eq? m 'id) (random 1000))  ; +
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
                       (account2 'balance))))
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))

(define (ordered-serialized-exchange low-account high-account)
  (let ((serializer1 (low-account 'serializer))
        (serializer2 (high-account 'serializer)))
    ((serializer2 (serializer1 exchange))
     low-account
     high-account)))

(define (serialized-exchange account1 account2)
  (if (< (account1 'id) (account2 'id))
      (ordered-serialized-exchange account1 account2)
      (ordered-serialized-exchange account2 account1)))

; test
(define peter-acc (make-account-and-serializer 100))
(define mary-acc (make-account-and-serializer 50))
(serialized-exchange peter-acc mary-acc)

(log "peter-acc" (peter-acc 'balance))
(log "mary-acc" (mary-acc 'balance))

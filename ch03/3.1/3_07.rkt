#lang racket

(define (make-account balance secret-password)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch password m)
    (cond ((eq? m 'pass?) ; pass? 只验证密码
            (eq? password secret-password))
          ((eq? password secret-password)
            (cond ((eq? m 'withdraw) withdraw)
                  ((eq? m 'deposit) deposit)
                  (else (error "Unknown request -- MAKE-ACCOUNT"
                               m))))
          (else
            (error "Incorrect password"))))
  dispatch)

(define (make-joint account old-password new-password)
  (if (account old-password 'pass?)
      (lambda (password m)
        (if (eq? password new-password)
            (account old-password m)
            (error "Incorrect password")))
      (error "Incorrect old password")))

; test
(define peter-acc (make-account 100 'open-sesame))

(define paul-acc
  (make-joint peter-acc 'open-sesame 'rosebud))

((peter-acc 'open-sesame 'withdraw) 40)
((paul-acc 'rosebud 'deposit) 50)
((peter-acc 'open-sesame 'withdraw) 40)
((paul-acc 'open-sesame 'deposit) 50)

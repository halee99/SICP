
(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (protected withdraw))
            ((eq? m 'deposit) (protected deposit))
            ((eq? m 'balance)
             ((protected (lambda () balance))))
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))


; 不同意ben的观点
; 只读 balance 相当于原子操作,
; 不会因为并发的 deposit 和 withdraw 影响到账号的逻辑错误

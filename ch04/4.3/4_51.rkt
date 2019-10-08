(define (analyze-pernamenant-set exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp))))
    (lambda (env succeed fail)
      (vproc env
             (lambda (val fail2)
               (set-variable-value! var val env)
               (succeed 'ok fail2)))
             fail)))


; 如果这里使用的是 set! 得:
; (a b 1)
; (a c 1)

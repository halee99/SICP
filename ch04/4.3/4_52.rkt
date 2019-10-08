
(define (analyze-if-fail exp)
  (let ((pproc (analyze (cadr exp)))
        (fproc (analyze (caddr exp))))
    (lambda (env succeed fail)
      (pproc env
             (lambda (pred-value fail2)
               (succeed pred-value fail2))
             (lambda ()
               (fproc env succeed fail))))))

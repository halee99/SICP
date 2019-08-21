
(define (first-seq seq) (car seq))
(define (rest-seq seq) (cdr seq))
(define ((exp->seq exp) (cdr exp)))

; and
(define (eval-and exp env)
  (define (eval-and-seq seq env)
    (cond ((last-seq? seq) (ture? (eval (first-seq seq) env)))
          ((ture? (eval (first-seq seq) env)) (eval-and-seq (rest-seq seq) env))
          (else 'false)))
  (eval-and-seq (exp->seq exp) env))

(define (and? exp) (tagged-list? exp 'and))
(define (make-and seq) (cons 'and seq))

; or
(define (eval-or exp env)
  (define (eval-or-seq seq env)
    (cond ((last-seq? seq) (false? (eval (first-seq seq) env)))
          ((false? (eval (first-seq seq) env)) (eval-or-seq (rest-seq seq) env))
          (else 'ture)))
  (eval-and-seq (exp->seq exp) env))

(define (or? exp) (tagged-list? exp 'or))
(define (make-or seq) (cons 'or seq))

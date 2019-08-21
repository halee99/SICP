; 只需修改 cond-actions
(define (cond-actions clause)
  (if (and (pair? (cdr clause))
           (eq? (cadr clause) '=>))
      (cddr clause)
      (cdr clause)))

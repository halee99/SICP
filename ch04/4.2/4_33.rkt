(define (cons x y)
  (lambda (m) (m x y)))

(define (car z)
  (z (lambda (p q) p)))

(define (cdr z)
  (z (lambda (p q) q)))

(define (text-of-quotation exp env)
  (let ((text (cadr exp)))
    (if (pair? text)
        (eval (make-list text) env)
        text)))

(define (make-list text)
  (if (null? text)
      (list 'quote '())
      (list 'cons
            (list 'quote (car text))
            (make-list (cdr text)))))

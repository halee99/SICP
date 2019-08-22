(define (last-parameters? seq) (null? (cdr seq)))

(define (let*? exp) (tagged-list? exp 'let*))
(define (let*-parameters exp) (cadr exp))
(define (let*-body exp) (caddr exp))

(define (make-let* parameters body)
  (list 'let* parameters body))

(define (let*->nested-lets exp)
  (let ((parameters (let*-parameters exp))
        (body (let*-body exp)))
    (if (last-parameters? parameters)
        (make-let parameters body)
        (make-let (car parameters)
                  (make-let* (cdr parameters) body)))))

; a)

(define (letrec-param exp) (cadr exp))
(define (letrec-body exp) (caddr exp))

(define (param->let-parameters param)
  (define (convert param)
    (if (null? param)
        '()
        (cons (cons (caar param) '*unassigned*) (convert (cdr param)))))
  (convert param))

; param->lambda-exp 的返回值是没有 '() 是list
(define (param->let-exp param)
  (define (convert param)
    (if (null? (cdr param))
        (list 'set! (caar param) (cdar param))
        (cons (list 'set! (caar param) (cdar param))
              (convert (cdr param)))))
  (convert param))

(define (letrec->let exp)
  (let ((param (letrec-param exp))
        (body (letrec-body exp)))
    (make-let (param->let-parameters param) (cons (param->let-exp param) body))))


; b)
; 求值到 <rest of body of f>时的环境在 Louis 认为的内部定义都可以用 let 代替情况下，多产生了环境框架

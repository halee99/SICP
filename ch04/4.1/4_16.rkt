; a)
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (if (eq? (car vals) '*unassigned*)
                 (error "Unassigned variable" var)
                 (car vals)))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))


; b)
(define (lambda-definitions exp)
  (define (definitions body)
    (cond ((null? body)
            '())
          (definition? (car body)
            (cons (car body) (definitions (cdr body))))
          (else
            '())))
  (definitions (lambda-body exp)))

(define (lambda-rest-body exp)
  (define (rest-body body)
    (cond ((null? body)
            '())
          (definition? (car body)
            (rest-body (cdr body)))
          (else
            (cons (car body) (rest-body (cdr body))))))
  (rest-body (lambda-body exp)))

; 变换中转，定义 抽象成 '声明' 和 '设置' 两个部分
(define (definitions-params definitions)
  (if (null? definitions)
      '()
      (cons (cons (definition-variable (car definitions)) '*unassigned*)
            (definitions-params (cdr definitions)))))

; definitions-set 返回值是没有 '() 的 list
(define (definitions-sets definitions)
  (if (null? (cdr definitions))
      '()
      (cons (list 'let! (definition-variable (car definitions))
                        (definition-value (car definitions)))
            (definitions-sets (cdr definitions)))))

(define (scan-out-defines exp)
  (let ((parameters (lambda-parameters exp))
        (definitions (lambda-definitions exp))
        (rest-body (lambda-rest-body exp))
        (params (definitions-params definitions))
        (sets (definitions-sets definitions)))
    (make-lambda parameters (make-let params (cons sets rest-body)))))


; c)
(define (contain-defines? exps)
 (if (null? exps)
   false
   (or (if (definition? (car exps))
         true
         false)
       (contain-defines? (cdr exps)))))

(define (make-procedure parameters body env)
 (if (contain-defines? body)
     (list 'procedure parameters (scan-out-defines body) env)
     (list 'procedure parameters body env)))

; 安装到 make-procedure 里。
; 因为可以通过判断该 procedure 里是否包含 defines，以此决定是否调用 scan-out-defines

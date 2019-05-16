
; 不能直接运行

; 从左到右执行
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((first-value (eval (first-operand exps) env)))
      (cons first-value
            (list-of-values (rest-operands exps) env)))))

; 从右到左执行
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((rest-value (list-of-values (rest-operands exps) env)))
      (cons (eval (first-operand exps) env)
            rest-value))))

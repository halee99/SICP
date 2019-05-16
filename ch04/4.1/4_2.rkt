
; a) Louis 大错特错
; 如果把过程应用放在有关赋值子句前面,
; 那么对于表达式 (define x 3) 误以为是调用函数 define 参数 x 和 3

; b)
(define (procedure-call? exp)
  (tagged-list? exp 'call))
(define (operator exp) (cadr exp))
(define (operands exp) (cddr exp))

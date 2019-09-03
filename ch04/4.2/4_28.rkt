; 例子
(define (square x) (* x x))
(define (foo f x) (f x))
(foo square 2)

; 惰性求值中，在 (foo square 2)处 square 被处理成 thunk list
; 解析成 (square 2) 的时候，square 是 thunk list
; 如果在 apply 之前没有 actual-value 运算符, 那么无法识别 square

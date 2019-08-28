(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))

(define (factorial n)
  (unless (= n 1)
          (* n (factorial (- n 1)))
          1))


; 如果定义在应用序语言中, 会无限递归
; 正则序可以正常运行

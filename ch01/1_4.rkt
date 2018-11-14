#lang racket
;; 运算符可以为组合式

(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

;;把对数据的条件判断求值，转换成对运算符的条件判断求值

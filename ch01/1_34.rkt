#lang planet neil/sicp

(define (f g)
  (g 2))

(f f)

; application: not a procedure;
;  expected a procedure that can be applied to arguments
;   given: 2
;   arguments...:
;    2

; 虽然解释器使用的是 应用序计算模型
; 但是 (f f) 第二个 f 是过程不需要也不能求值
; (f f) ; “展开”后得
; (f 2) ; 此时第二个参数是 2 不是我们期待的 过程参数

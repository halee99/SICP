#lang racket

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

; 正则序
; 1) (gcd 206 40)
; 2) (gcd 40 (remainder 206 40))  ; b == 6, 1 次
; 3) (gcd (remainder 206 40)
;         (remainder 40 (remainder 206 40)))  ; b == 4, 2 次
; 4) (gcd (remainder 40 (remainder 206 40))
;         (remainder (remainder 206 40)
;                    (remainder 40 (remainder 206 40))))  ; b == 2, 4次
; 5) (gcd (remainder (remainder 206 40)
;                    (remainder 40 (remainder 206 40)))
;         (remainder (remainder 40 (remainder 206 40))
;                    (remainder (remainder 206 40)
;                               (remainder 40 (remainder 206 40)))))  ; b = 0, 7次
; 6) (remainder (remainder 206 40)
;                    (remainder 40 (remainder 206 40)))  ; 4次
; 7) 2
; 共 18 次 remainder 操作


; 应用序
; (gcd 206 40)
; (gcd 40 (remainder 206 40))
; (gcd 40 6)
; (gcd 6 (remainder 40 6))
; (gcd 6 4)
; (gcd 4 (remainder 6 4))
; (gcd 4 2)
; (gcd 4 (remainder 4 2))
; (gcd 2 0)
; 共 4 次 remainder 操作

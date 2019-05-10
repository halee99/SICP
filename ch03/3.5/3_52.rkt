#lang racket
(require "stream_utils.rkt")

(define sum 0)

(define (accum x)
  (set! sum (+ x sum))
  sum)

(define seq (stream-map accum (stream-enumerate-interval 1 20)))
(define y (stream-filter even? seq))
(define z (stream-filter (lambda (x) (= (remainder x 5) 0))
                          seq))

; (stream-ref y 7)
; (display-stream z)
; (display "sum:")
; (display sum)

; memo-proc 版
; (stream-ref y 7)
; ; 136
; (display-stream z)
; ; 10
; ; 15
; ; 45
; ; 55
; ; 105
; ; 120
; ; 190
; ; 210
; ; 'stream-for-each-done
; (display "sum: ")
; (display sum)
; ; sum: 210


; 非 memo-proc 版
(stream-ref y 7)
; 136
(display-stream z)
; 10
; 15
; 45
; 55
; 105
; 120
; 190
; 210
; 'stream-for-each-done
(display "sum: ")
(display sum)
; sum: 210


; TODO 没有不同
; 理论上非 memo-proc 版的sum得到一个比 210 大的值
; 因为没有存储功能 sum被多次计算

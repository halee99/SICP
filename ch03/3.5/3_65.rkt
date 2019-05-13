#lang racket
(require "stream_utils.rkt")

(define (square x)
  (* x x))

; 欧拉加速器
(define (euler-transform s)
  (let ((s0 (stream-ref s 0))
        (s1 (stream-ref s 1))
        (s2 (stream-ref s 2)))
    (cons-stream (- s2 (/ (square (- s2 s1))
                          (+ s0 (* -2 s1) s2)))
                 (euler-transform (stream-cdr s)))))

; 超级加速器
(define (make-tableau transform s)
  (cons-stream s
               (make-tableau transform
                             (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car
              (make-tableau transform s)))

(define ones (cons-stream 1 ones))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define integers
  (cons-stream 1 (add-streams ones integers)))

(define (partial-sums s)
  (define streams
    (cons-stream (stream-car s)
                 (add-streams (stream-cdr s) streams)))
  streams)

(define (ln2-summands n)
  (cons-stream (/ 1.0 n)
               (stream-map - (ln2-summands (+ n 1)))))

(define ln2-stream
  (partial-sums (ln2-summands 1)))

; test
; ln2 = 0.6931471805599..

;没有加速器
; (display-stream ln2-stream)
; 1.0
; 0.5
; 0.8333333333333333
; 0.5833333333333333
; 0.7833333333333332
; 0.6166666666666666
; 0.7595238095238095
; 0.6345238095238095
; 0.7456349206349207
; 0.6456349206349207
; 0.7365440115440116
; 0.6532106782106782
; 0.7301337551337552
; 0.6587051837051838
; 0.7253718503718505
; 0.6628718503718505
; 0.7216953797836152
; 0.6661398242280596
; 0.718771403175428
; 0.6687714031754279
; 0.7163904507944756 还没步上正轨

; 欧拉加速器
; (display-stream (euler-transform ln2-stream))
; 0.7
; 0.6904761904761905
; 0.6944444444444444
; 0.6924242424242424
; 0.6935897435897436
; 0.6928571428571428
; 0.6933473389355742
; 0.6930033416875522
; 0.6932539682539683
; 0.6930657506744464
; 0.6932106782106783
; 0.6930967180967181
; 0.6931879423258734
; 0.6931137858557215
; 0.6931748806748808
; 0.6931239512121866
; 0.6931668512550866 接近, 但是比较慢

; (display-stream (accelerated-sequence euler-transform ln2-stream))
; 1.0
; 0.7
; 0.6932773109243697
; 0.6931488693329254
; 0.6931471960735491
; 0.6931471806635636
; 0.6931471805604039
; 0.6931471805599445
; 0.6931471805599427
; 0.6931471805599454
; +nan.0
; +nan.0 超出精度

#lang racket
(require "stream_utils.rkt")

(define (square x)
  (* x x))

(define (random-in-range low high)
  ; random 的参数只能是整数型
  ; 例如我要 -1 到 1 的随机值
  ; 我可以把它们放大 1000000
  ; 再产生随机值后在除以 1000000
  (define amplified 1000000)
  (let ((low (* low amplified))
         (high (* high amplified)))
    (let ((range (- high low)))
      (/ (+ low (random range))
         (* amplified 1.0)))))

(define (random-in-range-stream low high)
  (cons-stream (random-in-range low high)
               (random-in-range-stream low high)))

(define (monte-carlo-stream experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
     (* (/ passed (+ passed failed)) 1.0)
     (monte-carlo-stream
      (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
      (next (+ passed 1) failed)
      (next passed (+ failed 1))))

(define (estimate-integral-stream predicate x1 y1 x2 y2)
  (let* ((area (* (- x2 x1) (- y2 y1)))
		 (x-stream (random-in-range-stream x1 x2))
		 (y-stream (random-in-range-stream y1 y2))
		 (passed-ratio-stream (monte-carlo-stream
							   (stream-map predicate
										   x-stream
										   y-stream)
							   0 0)))
	(scale-stream passed-ratio-stream area)))

; test
(define s (estimate-integral-stream
	(lambda (x y)
	  (<= (+ (square x) (square y)) 1.0))
	-1 -1 1 1))

(stream-ref s 100)
(stream-ref s 1000)
(stream-ref s 10000)
(stream-ref s 100000)
(stream-ref s 1000000)
; 3.3267326732673266
; 3.1928071928071926
; 3.1396860313968604
; 3.140688593114069
; 3.1424728575271423

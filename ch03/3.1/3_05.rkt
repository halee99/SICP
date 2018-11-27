#lang racket
; #lang planet neil/sicp

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

(define (square x)
  (* x x))

(define (estimate-pi trials)
  (define (func estimate-number)
      (* 4.0 estimate-number))
  (func (estimate-intergral (lambda (x y)
                              (not (> (+ (square x)
                                         (square y))
                                      (square 1.0))))
                            -1
                            1
                            -1
                            1
                            trials)))

(define (estimate-intergral P? x1 x2 y1 y2 trials)
  (monte-carlo trials (lambda () (P? (random-in-range x1 x2)
                                     (random-in-range y1 y2)))))

(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
           (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))


; test
(estimate-pi 100)
(estimate-pi 1000)
(estimate-pi 10000)
(estimate-pi 100000)
(estimate-pi 1000000)

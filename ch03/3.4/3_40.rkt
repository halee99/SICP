(define x 10)
(parallel-execute (lambda () (set! x (* x x)))
                  (lambda () (set! x (* x x x))))

; https://sicp.readthedocs.io/en/latest/chp3/40.html

(define x 10)
(define s (make-serializer))
(parallel-execute (s (lambda () (set! x (* x x))))
                  (s (lambda () (set! x (* x x x)))))

; (* 10 10) => 100 => (* 100 100 100) => 1,000,000
; (* 10 10 10) => 1000 => (* 1000 1000) => 1,000,000

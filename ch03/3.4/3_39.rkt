; 未实现 make-serializer parallel-execute 无法运行
(define x 10)
(define s (make-serializer))
(parallel-execute (lambda () (set! x ((s (lambda () (* x x))))))
                  (s (lambda () (set! x (+ x 1)))))


; 产生3种结果

; 1 (set! x (+ 10 1)) => x = 11 => (set! x (* 11 11)) => x = 121
; 2 (set! x ?)[打断] => (set! x (+ 10 1)) => x = 11 => (set! x (* 11 11)) => x = 121
; 3 (set! x (* 10 10)) => x = 100 => (set! x (+ 100 1)) => x = 101

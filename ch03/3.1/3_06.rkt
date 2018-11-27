#lang racket

(define (rand-update x)
  (let ((a 27) (b 26) (m 127))
    (modulo (+ (* a x) b) m)))

(define random-init 7)			;**not in book**
(define rand
  (let ((x random-init))
    (lambda (command)
      (cond ((eq? command 'generate)
              (begin (set! x (rand-update x))
                     x))
            ((eq? command 'reset)
              (lambda (new-value)
                (set! x new-value)))
            (else
              (error "bad command -RAND" command))))))

; test
(rand 'generate)
(rand 'generate)
(rand 'generate)
((rand 'reset) 0)
(rand 'generate)
(rand 'generate)

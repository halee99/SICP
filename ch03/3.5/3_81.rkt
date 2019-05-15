#lang racket
(require "stream_utils.rkt")

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

(define (rand-stream s)
  (let ((m (stream-car s)))
    (cons-stream
      (if (eq? m 'generate)
          (rand 'generate)
          (begin ((rand 'reset) m)
                 (rand 'generate)))
      (rand-stream (stream-cdr s)))))

; test
(define (list2stream lis)
  (if (null? lis)
      '()
      (cons-stream (car lis) (list2stream (cdr lis)))))

(define data-l
  (list 'generate 2 'generate 'generate 'generate 'generate 8 'generate))

(define rand-s (rand-stream (list2stream data-l)))

(display-stream rand-s)
; 88
; 80
; 27
; 120
; 91
; 70
; 115
; 83

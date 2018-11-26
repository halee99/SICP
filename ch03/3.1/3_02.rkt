#lang racket

(define (make-monitored f)
  (let ((calls 0))
    (lambda (input)
      (cond ((eq? input 'how-many-calls?)
              calls)
            ((eq? input 'reset-count)
              (set! calls 0))
            (else
              (begin (set! calls (+ calls 1))
                     (f input)))))))

; test
(define s (make-monitored sqrt))
(s 100)
(s 'how-many-calls?)
(s 2)
(s 'how-many-calls?)
(s 'reset-count)
(s 2)
(s 'how-many-calls?)

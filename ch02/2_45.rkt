#lang racket

(require ( planet "sicp.ss" ( "soegaard" "sicp.plt" 2 1)))

(define (split proc1 proc2)
  (lambda (painter n)
    (if (= n 0)
        painter
        (let ((smaller ((split proc1 proc2) painter (- n 1))))
            (proc1 painter (proc2 smaller smaller))))))

(define right-split (split beside below))

(define up-split (split below beside))

(paint (right-split einstein 4))
(paint (up-split einstein 4))

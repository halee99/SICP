#lang racket
(require "stream_utils.rkt")

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (merge-weighted weight s1 s2)
  (define (merge s1 s2)
    (cond ((stream-null? s1) s2)
          ((stream-null? s2) s1)
          (else
           (let ((s1car (stream-car s1))
                 (s2car (stream-car s2)))
             (cond ((< (weight s1car) (weight s2car))
                    (cons-stream s1car (merge (stream-cdr s1) s2)))
                   ((> (weight s1car) (weight s2car))
                    (cons-stream s2car (merge s1 (stream-cdr s2))))
                   (else
                    (cons-stream s1car
                                 (merge (stream-cdr s1)
                                        (stream-cdr s2)))))))))
  (merge s1 s2))

(define ones (cons-stream 1 ones))

(define integers
  (cons-stream 1 (add-streams ones integers)))

(define (weighted-pairs weight s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (merge-weighted
     weight
     (stream-map (lambda (x) (list (stream-car s) x))
                 (stream-cdr t))
     (weighted-pairs weight (stream-cdr s) (stream-cdr t)))))

; a)
(define (weight-a s)
  (let ((i (car s))
        (j (cadr s)))
    (+ i j)))

; (display-stream
;   (weighted-pairs weight-a integers integers))
; (1 1)
; (1 2)
; (1 3)
; (1 4)
; (1 5)
; (1 6)
; (1 7)
; (1 8)
; (1 9)
; (1 10)

; b)
(define (weight-b s)
  (let ((i (car s))
        (j (cadr s)))
    (+ (* 2 i) (* 3 j) (* 5 i j))))

(define (weight-c x)
  x)

(define s
  (cons-stream
    1
    (merge-weighted
      weight-c
      (scale-stream s 2)
      (merge-weighted
        weight-c
        (scale-stream s 3)
        (scale-stream s 5)))))

; (display-stream
;   (weighted-pairs weight-b s s))
; (1 1)
; (1 2)
; (1 3)
; (2 2)
; (1 4)
; (1 5)
; (2 3)
; (1 6)
; (2 4)
; (3 3)
; (1 8)
; (2 5)
; (1 9)
; (3 4)
; (1 10)

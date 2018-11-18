#lang racket
;
(define (make-frame-1 origin edge1 edge2)
  (list origin edge1 edge2))

(define (make-frame-2 origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define (origin-frame frame)
  (car frame))

(define (origin-frame frame)
  (car frame))

(define (edge1-frame frame)
  (cadr frame))

(define (edge2-frame-1 frame)
  (caddr frame))

(define (edge2-frame-2 frame)
  (cddr frame))

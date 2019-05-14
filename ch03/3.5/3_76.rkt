#lang racket
(require "stream_utils.rkt")

(define (sign-change-detector now-value last-value)
  (let ((a now-value)
        (b last-value))
    (cond ((and (> a 0) (> b 0)) 0)
          ((and (< a 0) (< b 0)) 0)
          ((and (> a 0) (< b 0)) 1)
          ((and (< a 0) (> b 0)) -1)
          (else 0))))

(define (smooth input-stream)
  (define (smooth-iter input-stream last-value)
    (if (stream-null? input-stream)
        the-empty-stream
        (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
          (cons-stream avpt
                       (smooth-iter (stream-cdr input-stream) avpt)))))
  (smooth-iter input-stream 0))

(define (make-zero-crossings input-stream last-value)
  (cons-stream
   (sign-change-detector (stream-car input-stream) last-value)
   (make-zero-crossings (stream-cdr input-stream)
                        (stream-car input-stream))))

; test
(define (make-sense-data data)
  (if (null? data)
      '()
      (cons-stream (car data) (make-sense-data (cdr data)))))

(define data-pre (list 1 2 1.5 1 0.5 -0.1 -2 -3 -2 -0.5 0.2 3 4))

(define sense-data (make-sense-data data-pre))

(define smoothed-data (smooth sense-data))

(display-stream (make-zero-crossings smoothed-data 0))
; 0
; 0
; 0
; 0
; 0
; 0
; -1
; 0
; 0
; 0
; 0
; 1
; 0

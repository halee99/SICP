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
                                        ; fix: (stream-cdr s2) to s2
                                        s2))))))))
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

(define (weight-cube s)
  (let ((i (car s))
        (j (cadr s)))
    (+ (expt i 3) (expt j 3))))

(define ramanujan-pre
  (weighted-pairs weight-cube integers integers))

; (display-stream ramanujan-pre)

(define (stream-filter-2 pred stream)
  (let ((s1 (stream-car stream))
        (s2 (stream-car (stream-cdr stream))))
    (cond ((stream-null? stream) the-empty-stream)
          ((pred s1 s2)
           (cons-stream (stream-car stream)
                        (stream-filter-2 pred
                                         (stream-cdr (stream-cdr stream)))))
          (else (stream-filter-2 pred (stream-cdr stream))))))

(define ramanujan
  (stream-map weight-cube
              (stream-filter-2 (lambda (x y) (= (weight-cube x) (weight-cube y)))
                               ramanujan-pre)))

(display-stream ramanujan)
; 1729
; 4104
; 13832
; 20683
; 32832
; 39312
; 40033
; 46683
; 64232
; 65728
; 110656

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

(define (weight-square s)
  (let ((i (car s))
        (j (cadr s)))
    (+ (expt i 2) (expt j 2))))

(define new-ramanujan-pre
  (weighted-pairs weight-square integers integers))

; (display-stream new-ramanujan-pre)

(define (stream-filter-3 pred stream)
  (let ((s1 (stream-car stream))
        (s2 (stream-car (stream-cdr stream)))
        (s3 (stream-car (stream-cdr (stream-cdr stream)))))
    (cond ((stream-null? stream) the-empty-stream)
          ((pred s1 s2 s3)
           (cons-stream s1
             (cons-stream s2
               (cons-stream s3
                 (stream-filter-3 pred
                                  (stream-cdr (stream-cdr (stream-cdr stream))))))))
          (else (stream-filter-3 pred (stream-cdr stream))))))

(define new-ramanujan
  (stream-map (lambda (s) (cons (weight-square s) s))
              (stream-filter-3 (lambda (x y z) (= (weight-square x)
                                                  (weight-square y)
                                                  (weight-square z)))
                               new-ramanujan-pre)))

(display-stream new-ramanujan)
; (325 1 18)
; (325 6 17)
; (325 10 15)
; (425 5 20)
; (425 8 19)
; (425 13 16)
; (650 5 25)
; (650 11 23)
; (650 17 19)
; (725 7 26)
; (725 10 25)
; (725 14 23)
; (845 2 29)
; (845 13 26)
; (845 19 22)
; (850 3 29)
; (850 11 27)
; (850 15 25)
; (925 5 30)
; (925 14 27)
; (925 21 22)

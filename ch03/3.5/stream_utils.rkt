#lang racket
(require r5rs)

(define (log . w)
  (define (print . w)
    (display (car w))
    (display " ")
    (apply log (cdr w)))
  (if (null? w)
      (newline)
      (apply print w)))

; accumulate
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

; enumerate-interval
(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))

; filter
(define (filter predicate sequence)
  (cond ((null? sequence) '())
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

; stream
(define (memo-proc proc)
  (let ((already-run? false) (result false))
    (lambda ()
      (if (not already-run?)
          (begin (set! result (proc))
                 (set! already-run? true)
                 result)
          result))))

; 非 memo-proc 版
; (define (delay exp)
;   (lambda () exp))

; memo-proc 版
(define (delay exp)
  (memo-proc (lambda () exp)))

(define (force delayed-object)
  (delayed-object))

; 使用宏定义 cons-stream
(define-syntax cons-stream
  (syntax-rules ()
	((_ a b) (cons a (memo-proc (lambda () b))))))

(define (stream-null? stream) (null? stream))
(define the-empty-stream '())
(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))


(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

; (define (stream-map proc s)
;   (if (stream-null? s)
;       the-empty-stream
;       (cons-stream (proc (stream-car s))
;                    (stream-map proc (stream-cdr s)))))

; 扩展版 stream-map
(define (stream-map proc . argstrams)
  (if (null? (car argstrams))
      the-empty-stream
      (cons-stream
        (apply proc
               (map (lambda (s) (stream-car s)) argstrams))
        (apply stream-map
               (cons
                 proc
                 (map (lambda (s) (stream-cdr s)) argstrams))))))

(define (stream-for-each proc s)
  (if (stream-null? s)
      'stream-for-each-done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (display x)
  (newline))

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter pred
                                     (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

(provide (all-defined-out))

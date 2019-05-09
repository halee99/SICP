#lang racket
(require "make_serializer.rkt")

; 基于互斥元
(define (make-semaphore-1 n)
  (let ((mutex (make-mutex)))
    (define (acquire)
      ; 对 n 操作需要使用互斥元
      (mutex 'acquire)
      (if (> n 0)
          (begin (set! n (- n 1))
                 (mutex 'release)
                 'ok)
          (begin (mutex 'release)
                 (acquire))))
    (define (release)
      (mutex 'acquire)
      (set! n (+ n 1))
      (mutex 'release)
      'ok)
    (define (dispatch m)
      (cond ((eq? m 'acquire)
              (acquire))
            ((eq? m 'release)
              (release))
            (else
              (error "Unknown mode MAKE-SEMAPHORE" m))))
    dispatch))

; 基于原子(假设是)操作test-and-set!
(define (test-and-set! n)
    (if (= n 0)
        (begin
          #t)
        (begin (set! n (- n 1))
          #f)))

(define (make-semaphore-2 n)
    (define (acquire)
        (if (test-and-set! n)
            (acquire)
            'ok))
    (define (release)
        (set! n (+ n 1))
        'ok)
    (define (dispatch m)
        (cond ((eq? m 'acquire)
                (acquire))
              ((eq? m 'release)
                (release))
              (else
                (error "Unknown mode MAKE-SEMAPHORE" m))))
    dispatch)

; test
; (define se (make-semaphore-1 3))
; (se 'acquire)
; (se 'acquire)
; (se 'acquire)
; (se 'acquire)

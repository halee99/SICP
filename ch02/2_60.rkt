#lang racket

(define (to-set set)
  (define (iter s result)
    (cond ((null? s)
            (reverse result))
          ((element-of-set? (car s) result)
            (iter (cdr s) result))
          (else
            (iter (cdr s)
                  (cons (car s) result)))))
  (iter set '()))

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (cons x set))

(define (intersection-set set1 set2)
  (let ((set1 (to-set set1))
        (set2 (to-set set2)))
    (cond ((or (null? set1) (null? set2)) '())
          ((element-of-set? (car set1) set2)
           (cons (car set1)
                 (intersection-set (cdr set1) set2)))
          (else (intersection-set (cdr set1) set2)))))

(define (union-set set1 set2)
  (let ((set1 (to-set set1))
        (set2 (to-set set2)))
    (cond ((null? set1)
            set2)
          ((null? set2)
            set1)
          ((element-of-set? (car set1) set2)
            (union-set (cdr set1) set2))
          (else
            (cons (car set1)
                  (union-set (cdr set1) set2))))))

; test
(define a (list 1 2 3 2 1))
(define b (list 1 3 4 6 5 1))
(intersection-set a b)
(union-set a b)

;        element-of-set?  adjoin-set  intersection-set  union-set
; 无重复  O(n)              O(n)       O(n^2)            O(n^2)
; 重复   O(n)              O(1)       O(n^2)            O(n^2)

; 无重复 set 适合用于频繁 intersection-set union-set
; 重复 set 适合用于频繁 adjoin-set

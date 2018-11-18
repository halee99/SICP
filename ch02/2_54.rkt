#lang racket

(define (equal? a b)
  (cond ((and (symbol? a) (symbol? b)) ; 都是引用
          (eq? a b))
        ((and (list? a) (list? b))
          (equal-list? a b))))

(define (equal-list? a b)
  (cond ((and (null? a) (null? b))
          #t)
        ((or (null? a) (null? b))
          #f)
        ((equal? (car a) (car b))
          (equal? (cdr a) (cdr b)))
        (else
          #f)))

(equal? '(this is a list) '(this is a list))
(equal? '(this is a list) '(this (is a) list))

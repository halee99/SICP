#lang racket

(define (make-vect x y)
  (cons x y))

(define (xcor-vect v)
  (car v))

(define (ycor-vect v)
  (cdr v))

(define (add-cor ob cor-vect v1 v2)
  (ob (cor-vect v1) (cor-vect v2)))

(define (add-vect v1 v2)
  (make-vect (add-cor + xcor-vect v1 v2)
             (add-cor + ycor-vect v1 v2)))

(define (sub-vect v1 v2)
  (make-vect (add-cor - xcor-vect v1 v2)
             (add-cor - ycor-vect v1 v2)))

(define (scale-vect s v)
  (make-vect (* s (xcor-vect v))
             (* s (ycor-vect v))))

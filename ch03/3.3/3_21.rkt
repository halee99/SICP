#lang planet neil/sicp

(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))

(define (empty-queue? queue) (null? (front-ptr queue)))
(define (make-queue) (cons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (car (front-ptr queue))))

(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair)
           queue)
          (else
           (set-cdr! (rear-ptr queue) new-pair)
           (set-rear-ptr! queue new-pair)
           queue))))

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
         (set-front-ptr! queue (cdr (front-ptr queue)))
         queue)))


(define q1 (make-queue))
(insert-queue! q1 'a)
; (mcons #0=(mcons 'a '()) #0#)
(insert-queue! q1 'b)
; (mcons (mcons 'a #0=(mcons 'b '())) #0#)
(delete-queue! q1)
; (mcons #0=(mcons 'b '()) #0#)
(delete-queue! q1)
; (mcons '() (mcons 'b '()))


; 当队列只有一个节点 a 时，queue 的 front-ptr 和 rear-ptr 都指向 a
; 所以用该算法对 a 进行删除后，rear-ptr 没有修改依然指向 a

(define (print-queue queue)
  (display (front-ptr queue))
  (newline))

(define q2 (make-queue))
(print-queue (insert-queue! q2 'a))
; (a)
(print-queue (insert-queue! q2 'b))
; (a b)
(print-queue (delete-queue! q2))
; (b)
(print-queue (delete-queue! q2))
; ()

#lang planet neil/sicp

; 为了使双端队列的队尾删除的时间复杂度为 O(1)
; 队列的实现需要使用双链表
(define (make-node x) (cons x (cons '() '())))
(define (pre-node node) (cadr node))
(define (next-node node) (cddr node))
(define (data-node node) (car node))
(define (set-pre-node! node x) (set-car! (cdr node) x))
(define (set-next-node! node x) (set-cdr! (cdr node) x))

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

(define (rear-insert-queue! queue item)
  (let ((new-node (make-node item)))
    (cond ((empty-queue? queue)
            (set-front-ptr! queue new-node)
            (set-rear-ptr! queue new-node)
            queue)
          (else
            (set-next-node! (rear-ptr queue) new-node)
            (set-pre-node! new-node (rear-ptr queue))
            (set-rear-ptr! queue new-node)
            queue))))

(define (front-insert-queue! queue item)
  (let ((new-node (make-node item)))
    (cond ((empty-queue? queue)
            (set-front-ptr! queue new-node)
            (set-rear-ptr! queue new-node)
            queue)
          (else
            (set-next-node! new-node (front-ptr queue))
            (set-pre-node! (front-ptr queue) new-node)
            (set-front-ptr! queue new-node)
            queue))))

(define (front-delete-queue! queue)
  (cond ((empty-queue? queue)
          (error "DELETE! called with an empty queue" queue))
        ; 当队列里只有一个节点时
        ((eq? (front-ptr queue) (rear-ptr queue))
          (set-front-ptr! queue '())
          (set-rear-ptr! queue '())
          queue)
        (else
          (set-front-ptr! queue (next-node (front-ptr queue)))
          (set-pre-node! (front-ptr queue) '())
          queue)))

(define (rear-delete-queue! queue)
  (cond ((empty-queue? queue)
          (error "DELETE! called with an empty queue" queue))
        ; 当队列里只有一个节点时
        ((eq? (front-ptr queue) (rear-ptr queue))
          (set-front-ptr! queue '())
          (set-rear-ptr! queue '())
          queue)
        (else
          (set-rear-ptr! queue (pre-node (rear-ptr queue)))
          (set-next-node! (rear-ptr queue) '())
          queue)))

; dirty print
(define (print-queue queue)
  (let ((front (front-ptr queue)))
    (define (iter x)
      (cond ((null? x)
              (newline))
            (else
              (display (data-node x))
              (display " ")
              (iter (next-node x)))))
    (iter front)))

(define q (make-queue))

(print-queue (front-insert-queue! q 'a))
; a
(print-queue (front-insert-queue! q 'b))
; b a
(print-queue (rear-insert-queue! q 'c))
; b a c
(print-queue (rear-insert-queue! q 'd))
; b a c d
(print-queue (front-delete-queue! q))
; a c d
(print-queue (rear-delete-queue! q))
; a c
(print-queue (front-delete-queue! q))
; c
(print-queue (rear-delete-queue! q))
;

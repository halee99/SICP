#lang racket
(require r5rs)

(define (make-queue)
  (let ((front-ptr '())
        (rear-ptr '()))

        (define (empty-queue?)
          (null? front-ptr))

        (define (front-queue)
          (if (empty-queue?)
             (error "FRONT called with an empty queue")
             (car front-ptr)))

        (define (insert-queue! item)
          (let ((new-pair (cons item '())))
            (cond ((empty-queue?)
                    (set! front-ptr new-pair)
                    (set! rear-ptr new-pair)
                    front-ptr)
                  (else
                    (set-cdr! rear-ptr new-pair)
                    (set! rear-ptr new-pair)
                    front-ptr))))

        (define (delete-queue!)
          (cond ((empty-queue?)
                 (error "DELETE! called with an empty queue"))
                (else
                 (set! front-ptr (cdr front-ptr))
                 front-ptr)))

        (define (dispatch m)
          (cond ((eq? m 'empty-queue?)
                  empty-queue?)
                ((eq? m 'front-queue)
                  front-queue)
                ((eq? m 'insert-queue!)
                  insert-queue!)
                ((eq? m 'delete-queue!)
                  delete-queue!)
                (else
                  (error "command no find -- QUEUE" m))))
  dispatch))

(define (empty-queue? q)
  ((q 'empty-queue?)))
(define (front-queue q)
  ((q 'front-queue)))
(define (insert-queue! q item)
  ((q 'insert-queue!) item))
(define (delete-queue! q)
  ((q 'delete-queue!)))

(provide (all-defined-out))

#lang planet neil/sicp

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
                  (empty-queue?))
                ((eq? m 'insert-queue!)
                  insert-queue!)
                ((eq? m 'delete-queue!)
                  (delete-queue!))
                (else
                  (error "command no find -- QUEUE" m))))
  dispatch))


; test
(define q1 (make-queue))
((q1 'insert-queue!) 'a)
; (mcons 'a '())
((q1 'insert-queue!) 'b)
; (mcons 'a (mcons 'b '()))
(q1 'delete-queue!)
; (mcons 'b '())
(q1 'delete-queue!)
; '()

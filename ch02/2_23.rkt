#lang planet neil/sicp

(define (for_each func items)
  (if (null? items) #t)
  (func (car items))
  (for_each func (cdr items)))

(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))

#lang planet neil/sicp

; 不能直接运行
(define (ripple-carry-adder a-list b-list s-list c)
  (define (iter a b s ct)
    (if (and (null? a) (null? b) (null? s))
        'ok
        (let ((ak (car a))
              (bk (car b))
              (sk (car s))
              (a-remain (cdr a))
              (b-remain (cdr b))
              (s-remain (cdr s))
              (ck (make-wire)))
              (full-adder ak bk ct sk ck)
              （iter a-remain b-remain s-remain ck）)))
  (iter a-list b-list s-list c))

  

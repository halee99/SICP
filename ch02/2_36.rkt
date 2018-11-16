#lang planet neil/sicp

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (first-of-seq-of-seqs seqs)
  (accumulate (lambda (x y)
                (cons (car x) y))
              nil
              seqs))

(define (next-of-seq-of-seqs seqs)
  (accumulate (lambda (x y)
                (cons (cdr x) y))
              nil
              seqs))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (first-of-seq-of-seqs seqs))
            (accumulate-n op init (next-of-seq-of-seqs seqs)))))

; test
(define s (list (list 1 2 3)
                   (list 4 5 6)
                   (list 7 8 9)
                   (list 10 11 12)))

(accumulate-n + 0 s)

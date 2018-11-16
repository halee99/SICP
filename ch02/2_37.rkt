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

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (sub-m)
          (dot-product sub-m v))
       m))

(define (transpose mat)
  (accumulate-n cons nil mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (sub-m)
            (matrix-*-vector cols sub-m))
         m)))

; test
(define A (list (list 1 2 3)
                (list 4 5 6)
                (list 7 8 0)))

(define B (list (list 1 2 1)
                (list 1 1 2)
                (list 2 1 1)))

(display (matrix-*-matrix A B))

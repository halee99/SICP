#lang planet neil/sicp

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
;
(define (count-leaves-old x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves-old (car x))
                 (count-leaves-old (cdr x))))))

(define (count-leaves t)
  (accumulate (lambda (x y)
                (+ x y))
              0
              (map (lambda (sub-t)
                      (if (pair? sub-t)
                          (count-leaves sub-t)
                          1))
                    t)))

; test
(define x (list (list 1 (list 5 6)) (list 1 2)))

(count-leaves-old x)
(count-leaves x)

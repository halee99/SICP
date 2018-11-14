#lang planet neil/sicp

(define zero (lambda (f) (lambda (x) x)))

(define (add_1 n)
  (lambda (f)
    (lambda (x) (f ((n f) x)))))

;(add_1 zero)
;展开得 one
; (add_1 (lambda (f) (lambda (x) x)))
;
; (lambda (f)
;   (lambda (x) (f (((lambda (f) (lambda (x) x))
;                    f) x))))
;
; (lambda (f)
;   (lambda (x) (f ((lambda (x) x)
;                     x))))
;
; (lambda (f)
;   (lambda (x) (f x)))
;

(define one
  (lambda (f)
    (lambda (x) (f x))))

; (add_1 one)
; 展开得 two
; (add_1 (lambda (f) (lambda (x) (f x))))
;
; (lambda (f)
;   (lambda (x) (f (((lambda (f) (lambda (x) (f x)))
;                     f) x))))
;
; (lambda (f)
;   (lambda (x) (f ((lambda (x) (f x))
;                     x))))
;
; (lambda (f)
;   (lambda (x) (f (f x))))

(define two
  (lambda (f)
    (lambda (x) (f (f x)))))

;
(define +
  (lambda (m)
    (lambda (n)
      (lambda (f)
        (lambda (x)
          (m f (n f x)))))))

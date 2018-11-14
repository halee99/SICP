#lang planet neil/sicp

; 递归
(define (cont_frac n d k)
  (define (frac i)
    (if (= i k)
        (/ (n i)
           (d i))
        (/ (n i)
           (+ (d i) (frac (+ i 1))))))
  (frac 1))

; a)
(define (golden_section k)
  (cont_frac (lambda (i) 1.0)
             (lambda (i) 1.0)
             k))

(golden_section 10)
(golden_section 11)
(golden_section 12)
; 0.6179775280898876
; 0.6180555555555556
; 0.6180257510729613
; k = 11

; b)
; 迭代
(define (cont_frac_iter n d k)
  (define (iter i result)
    (if (= i 0)
        result
        (iter (- i 1)
              (/ (n i) (+ (d i) result)))))
  (iter k 0))

;
(cont_frac_iter (lambda (i) 1.0)
                (lambda (i) 1.0)
                100)

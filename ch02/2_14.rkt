#lang planet neil/sicp

(define (make_interval a b) (cons a b))

(define (lower_bound x)
  (if (< (car x) (cdr x))
      (car x)
      (cdr x)))

(define (upper_bound x)
  (if (> (car x) (cdr x))
      (car x)
      (cdr x)))
;
(define (add_interval x y)
  (make_interval (+ (lower_bound x) (lower_bound y))
                 (+ (upper_bound x) (upper_bound y))))

(define (mul_interval x y)
  (let ((p1 (* (lower_bound x) (lower_bound y)))
        (p2 (* (lower_bound x) (upper_bound y)))
        (p3 (* (upper_bound x) (lower_bound y)))
        (p4 (* (upper_bound x) (upper_bound y))))
    (make_interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div_interval x y)
  (cond ((= (lower_bound y) 0 )
          (error "0 不能为除数"))
        ((= (upper_bound y) 0 )
          (error "0 不能为除数"))
        (else
          (mul_interval
            x
            (make_interval (/ 1.0 (upper_bound y))
                           (/ 1.0 (lower_bound y)))))))

(define (make_center_precent c p)
  (make_interval (- c (* c p)) (+ c (* c p))))

(define (center i)
  (/ (+ (lower_bound i) (upper_bound i)) 2))

(define (percent x)
  (- 1
     (/ (lower_bound x) (center x))))

(define (par1 r1 r2)
  (div_interval (mul_interval r1 r2)
                (add_interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make_interval 1 1)))
    (div_interval one
                  (add_interval (div_interval one r1)
                                (div_interval one r2)))))

; 测试
; A / A
(div_interval (make_center_precent 3 0.0001)
              (make_center_precent 3 0.0001))
; A / B
(div_interval (make_center_precent 3 0.0001)
              (make_center_precent 4 0.0001))
; par1 par2 test
(let ((r1 (make_center_precent 3 0.0001))
      (r2 (make_center_precent 4 0.0001)))
    (display (par1 r1 r2))
    (newline)
    (display (par2 r1 r2)))

#lang planet neil/sicp

(define (make_point x y)
  (cons x y))

(define (x_point p)
  (car p))

(define (y_point p)
  (cdr p))

(define (make_segment sp ep)
  (cons sp ep))

(define (start_segment seg)
  (car seg))

(define (end_segment seg)
  (cdr seg))

(define (mid_segment seg)
  ; a b 中某成员的平均值
  (define (average term a b)
    (/ (+ (term a) (term b))
       2.0))
  ; sp ep 的中点
  (define (mid_p sp ep)
    (let ((mx (average x_point sp ep))
          (my (average y_point sp ep)))
      (make_point mx my)))
  (mid_p (start_segment seg) (end_segment seg)))

; 打印某点
(define (print_point p)
  (newline)
  (display "(")
  (display (x_point p))
  (display ",")
  (display (y_point p))
  (display ")"))

; test
(let ((p1 (make_point 1 1))
      (p2 (make_point 5 5)))
    (print_point (mid_segment (make_segment p1 p2))))

;

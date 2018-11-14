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

(define (rectangle length width)
  (cons length width))

(define (length_rect rect)
  (car rect))

(define (width_rect rect)
  (cdr rect))

(define (len_segment seg)
  (define (square x)
    (* x x))
  (define (diff term p1 p2)
    (abs (- (term p1) (term p2))))
  (let ((sp (start_segment seg))
        (ep (end_segment seg)))
    (sqrt (+ (square (diff x_point sp ep))
             (square (diff y_point sp ep))))))

(define (value_length rect)
    (len_segment (length_rect rect)))

(define (value_width rect)
    (len_segment (width_rect rect)))

(define (circumference_rect rect)
    (+ (* 2 (value_length rect))
       (* 2 (value_width rect))))

(define (area_rect rect)
  (* (value_length rect) (value_width rect)))


; test
(let ((p0 (make_point 0 0))
      (p1 (make_point 0 4))
      (p2 (make_point 2 0)))
      (let ((le (make_segment p0 p1))
            (wi (make_segment p0 p2)))
        (define (print rect)
          (display "周长：")
          (display (circumference_rect rect))
          (newline)
          (display "面积：")
          (display (area_rect rect)))
        (print (rectangle le wi))))

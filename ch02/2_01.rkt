#lang planet neil/sicp


(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define (make_rat n d)
  ; simplifying fraction
  (define (simplifying n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  ; 规范化
  (let ((x (simplifying n d)))
    (cond ((and (> 0 (car x)) (> 0 (cdr x)))
            ; 负 / 负
            (cons (- (car x)) (- (cdr x))))
          ((and (< 0 (car x)) (> 0 (cdr x)))
            ; 正 / 负
            (cons (- (car x)) (- (cdr x))))
          (else
            ; 正 / 正， 负 / 正
            x))))

;
(make_rat 2 -4)
(make_rat -2 -4)

#lang planet neil/sicp

(define (repeated f n)
  (define (repeat i x)
    (if (= i 1)
        (f x)
        (repeat (- i 1) (f x))))
  (lambda (x) (repeat n x)))

;
(define tolerance 0.000001)

(define (fixed_point f first_guess)
  (define (close_enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess count)
  ; 在规定10000次内不收敛就返回
    (let ((next (f guess)))
      (cond ((< 100000 count)
              next)
            ((close_enough? guess next)
              next)
            (else
              (try next (+ count 1))))))
  (try first_guess 1))

(define (average a b)
  (/ (+ a b)
     2))

(define (average_damp f)
  (lambda (x) (average x (f x))))


(define (n_root_with_damp x n k)
  (define (f y)
    (/ x
       (expt y (- n 1))))
  (fixed_point ((repeated average_damp k) f) 1.0))

; 测试
(define (test_n_root test_number n k)
  (n_root_with_damp (expt test_number n) n k))


(define (print n k)
  (newline)
  (display n)
  (display " 方根 需要 ")
  (display k)
  (display " 次平均阻尼"))

(define (find_damp_of_n_root n)
  (define test_number 3)
  (define (close_enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  ; 测试平均阻尼的次数
  (define (find_damp_number damp_count)
      (let ((r (test_n_root test_number n damp_count)))
        (cond ((close_enough? r test_number)
                (print n damp_count))
              ; 测试平均阻尼的最大次数是 10
              ((> damp_count 10)
                (display "阻尼次数不够"))
              (else
                (find_damp_number (+ damp_count 1))))))
  (find_damp_number 1))


(define (find_damps_of_a2b_root a b)
  (find_damp_of_n_root a)
  (if (> a (- b 1))
      (display " ")
      (find_damps_of_a2b_root (+ a 1) b)))


; (find_damps_of_a2b_root 2 70)
; 输出
; 2 方根 需要 1 次平均阻尼
; 3 方根 需要 1 次平均阻尼
; 4 方根 需要 2 次平均阻尼
; 5 方根 需要 2 次平均阻尼
; 6 方根 需要 2 次平均阻尼
; 7 方根 需要 2 次平均阻尼
; 8 方根 需要 3 次平均阻尼
; 9 方根 需要 3 次平均阻尼
; 10 方根 需要 3 次平均阻尼
; 11 方根 需要 3 次平均阻尼
; 12 方根 需要 3 次平均阻尼
; 13 方根 需要 3 次平均阻尼
; 14 方根 需要 3 次平均阻尼
; 15 方根 需要 3 次平均阻尼
; 16 方根 需要 4 次平均阻尼
; 17 方根 需要 4 次平均阻尼
; 18 方根 需要 4 次平均阻尼
; 19 方根 需要 4 次平均阻尼
; 20 方根 需要 4 次平均阻尼
; 21 方根 需要 4 次平均阻尼
; 22 方根 需要 4 次平均阻尼
; 23 方根 需要 4 次平均阻尼
; 24 方根 需要 4 次平均阻尼
; 25 方根 需要 4 次平均阻尼
; 26 方根 需要 4 次平均阻尼
; 27 方根 需要 4 次平均阻尼
; 28 方根 需要 4 次平均阻尼
; 29 方根 需要 4 次平均阻尼
; 30 方根 需要 4 次平均阻尼
; 31 方根 需要 4 次平均阻尼
; 32 方根 需要 5 次平均阻尼
; 33 方根 需要 5 次平均阻尼
; 34 方根 需要 5 次平均阻尼
; 35 方根 需要 5 次平均阻尼
; 36 方根 需要 5 次平均阻尼
; 37 方根 需要 5 次平均阻尼
; 38 方根 需要 5 次平均阻尼
; 39 方根 需要 5 次平均阻尼
; 40 方根 需要 5 次平均阻尼
; 41 方根 需要 5 次平均阻尼
; 42 方根 需要 5 次平均阻尼
; 43 方根 需要 5 次平均阻尼
; 44 方根 需要 5 次平均阻尼
; 45 方根 需要 5 次平均阻尼
; 46 方根 需要 4 次平均阻尼 ; 5 次也成立
; 47 方根 需要 5 次平均阻尼
; 48 方根 需要 5 次平均阻尼
; 49 方根 需要 5 次平均阻尼
; 50 方根 需要 5 次平均阻尼
; 51 方根 需要 5 次平均阻尼
; 52 方根 需要 5 次平均阻尼
; 53 方根 需要 5 次平均阻尼
; 54 方根 需要 4 次平均阻尼 ; 5 次也成立
; 55 方根 需要 5 次平均阻尼
; 56 方根 需要 5 次平均阻尼
; 57 方根 需要 5 次平均阻尼
; 58 方根 需要 5 次平均阻尼
; 59 方根 需要 5 次平均阻尼
; 60 方根 需要 5 次平均阻尼
; 61 方根 需要 5 次平均阻尼
; 62 方根 需要 5 次平均阻尼
; 63 方根 需要 5 次平均阻尼
; 64 方根 需要 6 次平均阻尼
; 65 方根 需要 6 次平均阻尼
; 66 方根 需要 6 次平均阻尼
; 67 方根 需要 6 次平均阻尼
; 68 方根 需要 6 次平均阻尼
; 69 方根 需要 6 次平均阻尼
; 70 方根 需要 6 次平均阻尼

; 观察得知 n 次方根需要 ⌊log2 n⌋ 次平均阻尼

(define (log2 n)
  (cond ((> (/ n 2) 1)
          (+ 1 (log2 (/ n 2))))
        ((< (/ n 2) 1)
          0)
        (else
          1)))


(define (n_root x n)
  (n_root_with_damp x n (log2 n)))

(n_root (expt 2 10) 10)

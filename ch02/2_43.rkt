#lang racket

; 2-42 version
; (define (queens board-size)
;   (define (queen-cols k)
;     (if (= k 0)
;         (list empty-board)
;         (filter
;           (lambda (positions) (safe? k positions))
;           (flatmap  (lambda (rest-of-queens)
;                       (map  (lambda (new-row)
;                               (adjoin-position new-row k rest-of-queens))
;                             (enumerate-interval 1 board-size)))
;                     (queen-cols (- k 1))))))
;   (queen-cols board-size))

; Louis version
; (define (queens board-size)
;   (define (queen-cols k)
;     (if (= k 0)
;         (list empty-board)
;         (filter
;           (lambda (positions) (safe? k positions))
; 	        ;; next expression changed
;           (flatmap (lambda (new-row)
;                 	    (map  (lambda (rest-of-queens)
;                 		          (adjoin-position new-row k rest-of-queens))
;                 		        (queen-cols (- k 1))))
; 	                 (enumerate-interval 1 board-size)))))
;   (queen-cols board-size))

;  2-42 版本中 (queens n) 的 (queen-cols 1) 时间复杂度为 O(1)
; 则 Ta(n) = Ta(n-1)*n = .. = Ta(1)*n^(n-1) = n^(n-1)
; Louis 版本中 (queens n) 的 (queen-cols 1) 时间复杂度为 O(n)
; 则 Tb(n) = Tb(n-1)*n = .. = Tb(1)*n^(n-1) = n^n
; 所以 Louis 的代码花费时间为 T*board-size

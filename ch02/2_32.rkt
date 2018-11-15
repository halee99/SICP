#lang planet neil/sicp

(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (sub_rest)
                            (cons (car s) sub_rest))
                          rest)))))

(display (subsets (list 1 2 3)))

; 设集合 A(a b c)
; 那么 所有子集的集合 = 包含 a 的子集集合 + 不包含 a 的子集集合

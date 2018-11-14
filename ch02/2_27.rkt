#lang planet neil/sicp

(define (reverse lt)
  (define (rec n)
    (if (< n 0)
      nil
      (cons (list-ref lt n)
            (rec (- n 1)))))
  (rec (- (length lt) 1)))


; emmm 这段写得太丑了
(define (deep_reverse lt)
  (define (rec l n)
    (cond ((< n 0)
            nil)
          ; 如果是数
          ((and (not (null? l)) (not (pair? l)))
            l)
          (else
            ; 为了弄个变量。。。
            (let ((current (list-ref l n)))
              (cond ((null? current)
                      nil)
                    ((pair? current)
                      ; 如果 current 是序对，对 current 作逆转
                      (cons (rec current (- (length current) 1))
                            (rec l (- n 1))))
                    (else
                      (cons current
                            (rec l (- n 1)))))))))
  (rec lt (- (length lt) 1)))

; 这是网友的版本，很漂亮，但是只能通过书上给的 x 测试，y 不行
(define (deep_reverse2 tree)
  (cond ((null? tree)         ; 空树
          '())
        ((not (pair? tree))   ; 叶子
          tree)
        (else
          (reverse (list (deep_reverse2 (car tree))            ; 递归地逆序左右子树
                         (deep_reverse2 (cdr tree)))))))

(define x (list (list 1 2) (list 3 4)))
(define y (list 1 (list 1 2) (list 3 4)))
(reverse x)
(deep_reverse x)
(deep_reverse y)

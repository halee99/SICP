#lang planet neil/sicp

(define (make_mobile left right)
  (list left right))

(define (make_branch length structure)
  (list length structure))

; a)
(define (left_branch mobile)
  (car mobile))

(define (right_branch mobile)
  (cadr mobile))

(define (branch_length branch)
  (car branch))

(define (branch_structure branch)
  (cadr branch))

; b)
(define (total_weight mobile)
  (define (weight_branch branch)
    (if (pair? (branch_structure branch))
        ; 如果是 活动体
        (total_weight (branch_structure branch))
        (branch_structure branch)))
  (+ (weight_branch (left_branch mobile))
     (weight_branch (right_branch mobile))))

; c)
(define (balance? mobile)
  (define (torque branch)
    (if (pair? (branch_structure branch))
        ; 如果分支挂着是 活动体
        (* (branch_length branch)
           (total_weight (branch_structure branch)))
        (* (branch_length branch)
           (branch_structure branch))
        ))
  (if (pair? mobile)
      ; 如果是 活动体
      (and (= (torque (left_branch mobile))
              (torque (right_branch mobile)))
            (balance? (branch_structure (left_branch mobile)))
            (balance? (branch_structure (right_branch mobile))))
      ; 如果是 末支的 structure 部分
      #t))

; d)
; 如果是这种形式的活动体与分支
(define (make_mobile_d left right)
  (cons left right))

(define (make_branch_d length structure)
  (cons length structure))

; 只需要修改 right_branch 和 branch_structure
(define (right_branch_d mobile)
  (cdr mobile)) ; cdr 就能拿到第二项

(define (branch_structure_d branch)
  (cdr branch)) ; cdr 就能拿到第二项

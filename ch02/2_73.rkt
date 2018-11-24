; #lang racket
; racket 中没有 set-cdr! 等操作
#lang planet neil/sicp

(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (cdr record)
                  false))
            false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key-1
                                  (cons key-2 value))
                            (cdr local-table)))))
      'ok)
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum -- TYPE-TAG" datum)))

(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum -- CONTENTS" datum)))

; --------以上是"制表"------------

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get 'deriv (operator exp)) (operands exp)
                                            var))))

(define (operator exp) (car exp))

(define (operands exp) (cdr exp))


;: ((get (operator exp) 'deriv) (operands exp) var)

; a)
; 加入数据导向分派的目的是使该操作(函数)更"通用", 在扩展数据类型的及操作时无需修改“通用”操作
; scheme 有两个基本类型 数字类型和符号类型
; 而 number? same-variable?(对 symbol? 的抽象)谓词已经满足"通用"特性, 无需画蛇添足

; b)

(define (install-sum-package)
  ;; internal procedures
  (define (addend s) (car s))
  (define (augend s) (cadr s))
  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
          ((=number? a2 0) a1)
          ((and (number? a1) (number? a2)) (+ a1 a2))
          (else (list '+ a1 a2))))

  ;; interface to the rest of the system
  (put 'addend '+ addend)
  (put 'augend '+ augend)
  (put 'make-sum '+ make-sum)

  (put 'deriv '+ (lambda (exp var)
                  (make-sum (deriv (addend exp) var)
                            (deriv (augend exp) var))))
  'done)

(define (addend s)
  ((get 'addend '+) s))

(define (augend s)
  ((get 'augend '+) s))

(define (make-sum a1 a2)
  ((get 'make-sum '+) a1 a2))


(define (install-product-package)
  ;; internal procedures
  (define (multiplier p) (car p))
  (define (multiplicand p) (cadr p))
  (define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2)) (* m1 m2))
          (else (list '* m1 m2))))

  ;; interface to the rest of the system
  (put 'multiplier '* multiplier)
  (put 'multiplicand '* multiplicand)
  (put 'make-product '* make-product)

  (put 'deriv '* (lambda (exp var)
                  (make-sum
                    (make-product (multiplier exp)
                                  (deriv (multiplicand exp) var))
                    (make-product (deriv (multiplier exp) var)
                                  (multiplicand exp)))))
  'done)

(define (multiplier s)
  ((get 'multiplier '*) s))

(define (multiplicand s)
  ((get 'multiplicand '*) s))

(define (make-product m1 m2)
  ((get 'make-product '*) m1 m2))


(install-sum-package)
(deriv '(+ x 1) 'x)
(install-product-package)
(deriv '(* x (+ y 1)) 'x)

; c)

(define (install-exponent-package)
  (define (base x) (car x))
  (define (exponent x) (cadr x))
  (define (make-exponentiation b e)
    (cond ((=number? e 0) 1)
          ((=number? e 1) b)
          ((and (number? b) (number? e))
            (expt b e))
          (else
            (list '** b e))))

  (put 'base '** base)
  (put 'exponent '** exponent)
  (put 'make-exponentiation '** make-exponentiation)
  (put 'deriv '** (lambda (exp var)
    (make-product
      (make-product (exponent exp)
                    (make-exponentiation
                      (base exp)
                      (make-sum (exponent exp) -1)))
      (deriv (base exp) var)))))

(define (base x)
  ((get 'base '**) x))

(define (exponent x)
  ((get 'exponent '**) x))

(define (make-exponentiation b e)
  ((get 'make-exponentiation '**) b e))

(install-exponent-package)
(deriv '(** x 5) 'x)

; d)
; deriv 操作不需要修改
; 只需要交换 put 的第一个和第二个参数
; 例如: (put 'make-product '* make-product)
; 改为: (put '* 'make-product make-product)

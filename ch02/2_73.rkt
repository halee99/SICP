#lang racket
; #lang planet neil/sicp
; ; (require "complex.rkt")
; (#%require (only racket load))

(load "complex.rkt")

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (install-sum-package)
  ;; internal procedures
  (define (addend s) (cadr s))
  (define (augend s) (caddr s))
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
  (define (multiplier p) (cadr p))
  (define (multiplicand p) (caddr p))
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

(define (make-exponentiation b e)
  (cond ((=number? e 0) 1)
        ((=number? e 1) b)
        ((and (number? b) (number? e))
          (expt b e))
        (else
          (list '** b e))))

(define (base x) (cadr x))

(define (exponent x) (caddr x))

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))


(define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get 'deriv (operator exp)) (operands exp)
                                            var))))

(define (operator exp) (car exp))

(define (operands exp) (cdr exp))

(install-sum-package)
(deriv '(+ x 1) 'x)
;: ((get (operator exp) 'deriv) (operands exp) var)

; a)
; 加入数据导向分派的目的是使该操作(函数)更"通用", 在扩展数据类型的及操作时无需修改“通用”操作
; scheme 有两个基本类型 数字类型和符号类型
; 而 number? same-variable?(对 symbol? 的抽象)谓词已经满足"通用"特性, 无需画蛇添足

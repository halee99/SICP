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

; ---------- 2.4.3 -------------
(define (square x)
  (* x x))

(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a)
    (cons (* r (cos a)) (* r (sin a))))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (install-polar-package)
  ;; internal procedures
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (* (magnitude z) (cos (angle z))))
  (define (imag-part z)
    (* (magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y)
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

;;footnote
;: (apply + (list 1 2 3 4))

; (define (apply-generic op . args)
;   (let ((type-tags (map type-tag args)))
;     (let ((proc (get op type-tags)))
;       (if proc
;           (apply proc (map contents args))
;           (error
;             "No method for these types -- APPLY-GENERIC"
;             (list op type-tags))))))

;; Generic selectors

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))


;; Constructors for complex numbers

(define (make-from-real-imag x y)
  ((get 'make-from-real-imag 'rectangular) x y))

(define (make-from-mag-ang r a)
  ((get 'make-from-mag-ang 'polar) r a))

; ------ 2.5.1 ----------

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))

(define (install-scheme-number-package)
  (define (tag x)
    (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (tag (/ x y))))
  (put 'make 'scheme-number
       (lambda (x) (tag x)))

  ; ------------添加 2.79------------
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (= x y)))

  ; ------------添加 2.80------------
  (put 'zero? '(scheme-number)
       (lambda (x) (= x 0)))
  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))
  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))

  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))

  ; ------------添加 2.79------------
  (put 'equ? '(rational rational)
       (lambda (x y) (and (= (numer x) (numer x))
                          (= (denom y) (denom y)))))

  ; ------------添加 2.80------------
  (put 'zero? '(rational)
       (lambda (x) (= (numer x) 0)))

  (put 'numer 'rational numer)
  (put 'denom 'rational denom)
  'done)


(define (numer x)
((get 'numer 'rational) x))

(define (denom x)
((get 'denom 'rational) x))

(define (make-rational n d)
  ((get 'make 'rational) n d))

(define (install-complex-package)
  ;; imported procedures from rectangular and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                       (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
                       (- (angle z1) (angle z2))))

  ;; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))

  ; ------------添加 2.77------------
  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude '(complex) magnitude)
  (put 'angle '(complex) angle)

  ; ------------添加 2.79------------
  (put 'equ? '(complex complex)
    (lambda (x y) (and (= (real-part x) (real-part y))
                       (= (imag-part x) (imag-part y)))))

  ; ------------添加 2.80------------
  (put 'zero? '(complex)
       (lambda (x) (and (= (real-part x) 0)
                        (= (imag-part x) 0))))
  'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))

(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

; ------------添加 2.79------------
(define (equ? x y)
  (if (eq? (type-tag x) (type-tag y))
      (apply-generic 'equ? x y)
      false))

; ------------添加 2.80------------
(define (zero? x)
  (apply-generic 'zero? x))


(define (install-update-scheme-number-package)
  ; -------------修改 2.83----------------
  (define (raise x)
    (make-rational x 1))

  (put 'raise '(scheme-number) raise)
  'done)

(define (install-update-rational-package)
  ; -------------修改 2.83----------------
  (define (raise x)
    (make-complex-from-real-imag (/ (numer x)
                                    (denom x))
                                 0))
  ; -------------修改 2.85----------------
  (define (project x)
    (make-scheme-number (round (/ (numer x)
                                  (denom x)))))
  (put 'raise '(rational) raise)
  (put 'project '(rational) project)
  'done)

(define (install-update-complex-package)
  ; -------------修改 2.85----------------
  (define (project x)
    (make-rational (real-part x) 1))
  (put 'project '(complex) project)
  'done)

(define (raise x)
  (apply-generic 'raise x))

(define (project x)
  (apply-generic 'project x))
; -------------修改 2.84----------------
(define (level x)
  (let ((proc (get 'raise (list (type-tag x)))))
    (if proc
        (+ 1 (level (raise x)))
        0)))

; -------------修改 2.85----------------
; 假设 x 可以 project
; 那么如果 对 x 操作 project 后再 raise 等于 x
; 那么 x 可以投影，再试探是否能继续投影
; 否则返回 x
(define (drop x)
  ; (log "drop:" x)
  (let ((proc (get 'project (list (type-tag x)))))
    (if proc
        (let ((d (project x)))
          ; (log "drop:d:" d)
          (if (equ? (raise d) x)
              (drop d)
              x))
        x)))

; -------------修改 2.85----------------
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (let ((result (apply proc (map contents args))))
            ; (log "apply-generic:result:" result)
            (cond ((null? result)
                    result)
                  ; 如 number #f #t 等
                  ((not (pair? result))
                    result)
                  ; 下降类型 project 不能 drop
                  ((eq? op 'project)
                    result)
                  ; 上升类型 raise 不能 drop
                  ((eq? op 'raise)
                    result)
                  (else
                    (drop result))))
          (if (= (length args) 2)
              (let ((a1 (car args))
                    (a2 (cadr args)))
                (let ((l1 (level a1))
                      (l2 (level a2)))
                        ; 参数类型相同
                  (cond ((= l1 l2)
                         (error "No method for these types"
                                 (list op type-tags)))
                       ; level 越低的 类型更高
                        ((< l1 l2)
                         (apply-generic op a1 (raise a2)))
                        (else
                         (apply-generic op (raise a1) a2)))))
              (error "No method for these types"
                     (list op type-tags)))))))

(define (install)
  (install-rectangular-package)
  (install-polar-package)
  (install-scheme-number-package)
  (install-rational-package)
  (install-complex-package)
  (install-update-scheme-number-package)
  (install-update-rational-package)
  (install-update-complex-package)
  'done-all)

(define (log . w)
  (define (print . w)
    (display (car w))
    (display " ")
    (apply log (cdr w)))
  (if (null? w)
      (newline)
      (apply print w)))

;
(log "-------------test 2.85------------")
(install)

(sub (make-complex-from-real-imag 4 1)
     (make-complex-from-real-imag 1 1))

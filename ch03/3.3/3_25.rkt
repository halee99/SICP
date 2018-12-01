#lang planet neil/sicp

(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (lookup keys table)
  (let ((current-key (car keys))
        (remain-keys (cdr keys)))
    (let ((record (assoc current-key (cdr table))))
      (cond ((and record (null? remain-keys))
              (cdr record))
            ((and record (not (null? remain-keys)))
              (lookup remain-keys record))
            (else
              false)))))

(define (insert! keys value table)
  (let ((current-key (car keys))
        (remain-keys (cdr keys)))
    (let ((record (assoc current-key (cdr table))))
            ; 第一个 key 查到，没有其他 key
      (cond ((and record (null? remain-keys))
              (set-cdr! record value))
            ; 第一个 key 查不到，没有其他 key
            ((and (not record) (null? remain-keys))
              (set-cdr! table
                        (cons (cons current-key value) (cdr table))))
            ; 第一个 key 查到，还有其他 key
            ((and record (not (null? remain-keys)))
              (insert! remain-keys value record))
            ; 第一个 key 查不到，还有其他 key
            ((and (not record) (not (null? remain-keys)))
              (set-cdr! table
                        (cons (cons current-key '()) (cdr table)))
              (insert! remain-keys value (cadr table)))))
    'ok!))



(define (make-table)
  (list '*table*))


; test
(define t (make-table))

(insert! '(key1 key2 key3) 3 t)
(lookup '(key1 key2 key3) t)
(insert! '(key1 key2 key4) 2 t)
(lookup '(key1 key2 key4) t)

; BUG
; (insert! '(key1 key2) 1 t)
; 因为对于之前 '(key1 key2 key3) 等的插入，导致 '(key1 key2 ..) 是个三维表格
; 将三维表格 '(key1 key2 ..) 强行转换成二维表格 '(key1 key2) 会出错

#lang planet neil/sicp

; 其实 equal? 也能比较数字之间是否相等
(define (make-table same-key?)
  (let ((local-table (list '*table*)))
    (define (assoc key records)
      (cond ((null? records) false)
            ((same-key? key (caar records)) (car records))
            (else (assoc key (cdr records)))))
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

; (define operation-table (make-table))
; (define get (operation-table 'lookup-proc))
; (define put (operation-table 'insert-proc!))

; test
(define t1 (make-table =))
((t1 'insert-proc!) 100 100 'hello-t1)
((t1 'lookup-proc) 100 100)

(define t2 (make-table equal?))
((t2 'insert-proc!) 'peter 'jane 'hello-t2)
((t2 'lookup-proc) 'peter 'jane)

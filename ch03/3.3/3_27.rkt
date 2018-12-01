#lang planet neil/sicp

; https://sicp.readthedocs.io/en/latest/chp3/27.html
; 有点复杂

(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
        (cdr record)
        false)))

(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (insert! key value table)
  (let ((record (assoc key (cdr table))))
    (if record
        (set-cdr! record value)
        (set-cdr! table
                  (cons (cons key value) (cdr table)))))
  'ok)

(define (make-table)
  (list '*table*))

;
(define (memoize f)
  (let ((table (make-table)))
    (lambda (x)
      (let ((previously-computed-result (lookup x table)))
        (or previously-computed-result
            (let ((result (f x)))
              (insert! x result table)
              result))))))

(define memo-fib
  (memoize (lambda (n)
             (cond ((= n 0) 0)
                   ((= n 1) 1)
                   (else (+ (memo-fib (- n 1))
                            (memo-fib (- n 2))))))))



; 为了简化分析，先将 memoize 转换成一系列表达式：
;
; (define memoize
;     (lambda (f)
;         ((lambda (table)
;             (lambda (x)
;                 ((lambda (previously-computed-result)
;                     (or previously-computed-result
;                         ((lambda (result)
;                             (insert! x result table)
;                             result)
;                          (f x))))
;                  (lookup x table))))
;          (make-table))))
; memo-fib 已经是 lambda 表达式了，所以不用转换：
;
; (define memo-fib
;     (memoize (lambda (n)
;                 (cond ((= n 0)
;                         0)
;                       ((= n 1)
;                         1)
;                       (else
;                         (+ (memo-fib (- n 1))
;                            (memo-fib (- n 2))))))))
; 当表达式 (memo-fib 3) 执行时，它首先展开表达式 (memoize (lambda (n) ...)) ，调用以下执行序列：
; (memo-fib 3)                                        ; 展开 memoize
;
; ((lambda (f)                                        ; 展开参数 f
;     ((lambda (table)
;         (lambda (x)
;             ((lambda (previously-computed-result)
;                 (or previously-computed-result
;                     ((lambda (result)
;                         (insert! x result table)
;                         result)
;                      (f x))))
;              (lookup x table))))
;      (make-table)))
;  (lambda (n)
;     (cond ((= n 0)
;             0)
;           ((= n 1)
;             1)
;           (else
;             (+ (memo-fib (- n 1))
;                (memo-fib (- n 2)))))))
;
; ((lambda (table)                                        ; 创建表，展开参数 table
;     (lambda (x)
;         ((lambda (previously-computed-result)
;             (or previously-computed-result
;                 ((lambda (result)
;                     (insert! x result table)
;                     result)
;                  ((lambda (n)
;                     (cond ((= n 0)
;                             0)
;                           ((= n 1)
;                             1)
;                           (else
;                             (+ (memo-fib (- n 1))
;                                (memo-fib (- n 2))))))
;                   x))))
;          (lookup x table))))
;  (make-table))
;
; (lambda (x)                                         ; (memoize (lambda (n) ...)) 展开完毕
;     ((lambda (previously-computed-result)
;         (or previously-computed-result
;             ((lambda (result)
;                 (insert! x result table)
;                 result)
;             ((lambda (n)
;                 (cond ((= n 0)
;                         0)
;                       ((= n 1)
;                         1)
;                       (else
;                         (+ (memo-fib (- n 1))
;                            (memo-fib (- n 2))))))
;              x))))
;      (lookup x table)))
; 以上表达式创建这样一个环境：
;           +-----------------------------------------------------------------------------------------------------+
;           |                                                                                                     |
; global -> | memo-fib                                                                                            |
; env       |  |                                                                                                  |
;           +--|--------------------------------------------------------------------------------------------------+
;              |                    ^
;              |                    |
;              |  (lambda (f) ...)  |
;              |                    |
;              |                 +-----+
;              |                 |     |
;              |                 |     |<---------+
;              |                 |     |          |
;              |                 |  f ------->[*][*]
;              |                 |     |    parameters: n
;              |                 +-----+    body: (cond ((= n 0)
;              |                   ^                     0)
;              |                   |                   ((= n 1)
;              |                   |                     1)
;              |  (lambda (table)  |                   (else
;              |      ...)         |                     (+ (memo-fib (- n 1))
;              |                   |                        (memo-fib (- n 2)))))
;              |                   |
;              |               +-------+
;              |               |       |
;              |               |       |<------------------------------------------+
;              |               |       |                                           |
;              |               | table -----------------------------------+    +------------------------------+
;              |               |       |                                  |    |                              |
;              |               +-------+                                  |    | local-table: (list '*table*) |
;              |                 |  ^                                     |    |                              |
;              |                 |  |                                     |    | assoc                        |
;              +--------------->[*][*]                                    |    | lookup                       |
;                                |                                        |    | insert!                      |
;                                |                                        +----->dispatch                     |
;                                |                                             |                              |
;                                |                                             +------------------------------+
;                                v
;                     parameters: x
;                     body: ((lambda (previously-computed-result)
;                               (or previously-computed-result
;                                   ((lambda (result)
;                                      (insert! x result table)
;                                      result)
;                                    (f x))))
;                            (lookup x table))
; 将参数 3 应用到表达式 (lambda (x) ...) ，将创建这样一个环境：
;           +-----------------------------------------------------------------------------------------------------+
;           |                                                                                                     |
; global -> | memo-fib                                                                                            |
; env       |  |                                                                                                  |
;           +--|--------------------------------------------------------------------------------------------------+
;              |                    ^
;              |                    |
;              |  (lambda (f) ...)  |
;              |                    |
;              |                 +-----+
;              |                 |     |
;              |                 |     |<---------+
;              |                 |     |          |
;              |                 |  f ------->[*][*]
;              |                 |     |    parameters: n
;              |                 +-----+    body: (cond ((= n 0)
;              |                   ^                     0)
;              |                   |                   ((= n 1)
;              |                   |                     1)
;              |  (lambda (table)  |                   (else
;              |      ...)         |                     (+ (memo-fib (- n 1))
;              |                   |                        (memo-fib (- n 2)))))
;              |                   |
;              |               +-------+
;              |               |       |
;              |               |       |<------------------------------------------+
;              |+--------------|       |                                           |
;              vv              | table -----------------------------------+    +------------------------------+
;              [*][*]--------->|       |                                  |    |                              |
;               |              +-------+                                  |    | local-table: (list '*table*) |
;               v                ^                                        |    |                              |
;       parameters: x            |                                        |    | assoc                        |
;       body: ...                |                                        |    | lookup                       |
;                                |                                        |    | insert!                      |
;                                |                                        +----->dispatch                     |
;            (lambda (x)         |                                             |                              |
;                ...)            |                                             +------------------------------+
;                                |
;                            +------+
;                            |      |
;                            | x: 3 |
;                            |      |
;                            +------+
;                                ^
;                                |
; (lambda                        |
;   (previously-computed-result) |
;   ...)                         |
;                                |
;                                |
;                            +----------------------------------------------+
;                            |                                              |
;                            | previously-computed-result: (lookup x table) |
;                            |                                              |
;                            +----------------------------------------------+
;                             (or previously-computed-result
;                                 ((lambda (result)
;                                     (insert! x result table)
;                                     result)
;                                   (f x)))
; 当 (memo-fib 3) 计算完毕之后，环境变成了这样：
;           +--------------------+
;           |                    |
; global -> |   memo-fib         |
; env       |                    |
;           +--------------------+
;                     ^
;                     |
;   (lambda (f) ...)  |
;                     |
;                 +-----+
;                 |     |
;                 |     |<---------+
;                 |     |          |
;                 |  f ------->[*][*]
;                 |     |    parameters: n
;                 +-----+    body: (cond ((= n 0)
;                    ^                     0)
;                    |                   ((= n 1)
;                    |                     1)
;   (lambda (table)  |                   (else
;       ...)         |                     (+ (memo-fib (- n 1))
;                    |                        (memo-fib (- n 2)))))
;                    |
;                 +-------+
;                 |       |
;                 |       |<------------------------------------------+
;                 |       |                                           |
;                 | table -----------------------------------+    +---------------------------------------------------------------+
;                 |       |                                  |    |                                                               |
;                 +-------+                                  |    | local-table: (list '*table* (cons 3 2) (cons 2 1) (cons 1 1)) |
;                   |  ^                                     |    |                                                               |
;                   |  |                                     |    | assoc                                                         |
;                  [*][*]                                    |    | lookup                                                        |
;                   |                                        |    | insert!                                                       |
;                   |                                        +----->dispatch                                                      |
;                   |                                             |                                                               |
;                   |                                             +---------------------------------------------------------------+
;                   v
;            parameters: x
;            body: ((lambda (previously-computed-result)
;                      (or previously-computed-result
;                          ((lambda (result)
;                              (insert! x result table)
;                              result)
;                           (f x))))
;                   (lookup x table))
; 注意指向 table 的子环境中的 local-table 的值，在计算开始之前，它除了表头之外没有其他元素，现在它保存了三组斐波那契数的计算结果。
; 这也是 (memo-fib 3) 可以在线性时间内完成计算的原因：
; memo-fib 每次计算出一个斐波那契数 (memo-fib i) ，就将 i 和 (memo-fib i) 组成序对，并将这个序对加入进 local-table 里面；
; 如果下次再遇到同样的 i ，那么 memo-fib 就直接返回 local-table 中对应的斐波那契数，从而消除了重复计算。
; 另一个 memo-fib 定义
; 题目的另一个问题是，如果简单地将 memo-fib 定义为 (memoize fib) ，那么记忆法还能工作吗？
; 可以在解释器中尝试运行这个新的定义：
;
;
; (define (fib n)
;     (cond ((= n 0)
;             0)
;           ((= n 1)
;             1)
;           (else
;             (+ (fib (- n 1))
;                (fib (- n 2))))))
;
; (define memo-fib (memoize fib))
;
; 1 ]=> (memo-fib 3)
;
; ;Value: 2
; 需要注意的是，虽然这个新的 memo-fib 也可以正常运行，但它的执行效率并没有太大的提高：
; 因为每次调用 (memo-fib i) 的时候，这个 memo-fib 只保存 i 和 (memo-fib i) 的值，但是其他的斐波那契计算结果，这个 memo-fib 并不保存。
; 比如说，当调用 (memo-fib 3) 时， (memo-fib 3) 的结果会被保存进表里面，但是 (memo-fib 2) 和 (memo-fib 1) 的计算结果却不会被保存。
; 因此，这个版本的 memo-fib 仍然会有重复计算，它的复杂度仍然是指数级的。

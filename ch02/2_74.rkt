; a)
(define (get-record sector staff)
  ((get 'get-record sector) staff))

; 各分支机构根据各自的数据结构实现 get-record 安装到表格

; b)

(define (get-salary sector staff)
  ((get 'get-salary sector) staff))

; 各分支机构根据各自的数据结构实现 get-salary 安装到表格

; c)
(define (find-employee-record sector-list staff)
  (if (null? sector-list)
      '()
      (cons (get-record (car sector-list) staff)
            (find-employee-record (cdr sector-list) staff))))

; d)
; 原程序无需修改，只需要新公司根据自己的数据结构实现功能安装到表格

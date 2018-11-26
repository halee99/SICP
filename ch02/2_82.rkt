

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

; 判断序列是否都相同
(define (eq-all? seq)
  (define (iter a se)
    (if (null? se)
        true
        (and (eq? a (car se))
             (iter a (cdr se)))))
  (if (null? seq)
    (error "null sequence")
    (iter (car seq) (cdr seq))))

; "操作"序列是否都存在
(define (ok? seq)
  (if (null? seq)
      true
      (and (car seq)
           (ok? (cdr seq)))))

(define (apply-generic op . args)
  (define (judge conversions paras)
    (if (null? conversions)
      (error "No method for these types")
      (let ((cs (car conversions)))
        (if (ok? cs)
            (apply apply-generic
                   (cons op (map (lambda (t a) (t a)) cs paras)))
            (judge op (cdr conversions paras))))))

  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (cond ((> (length args) 1))
                ; 修改：如果参数类型相同
                ((eq-all? type-tags)
                  (error "No method for these types"
                         (list op type-tags)))
                (else
                       ;; 强制到第一参数类型,第二参数类型...最后参数类型的二维 "操作"序列 conversions
                  (let ((conversions (flatmap (lambda (ti)
                                                (map (lambda (t)
                                                       (get-coercion t ti))
                                                     type-tags))
                                              type-tags))
                        (paras (map (lambda (a) (cdr a)) args)))
                    (judge conversions paras))))))))

; 注：该代码不能直接运行
; 这种策略不够通用
; 例如 (add 1 1/2+0i) 应该将其都转换成分式

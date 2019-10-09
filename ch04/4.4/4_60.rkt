; 因为这两个例子都满足查询规则，虽然实质上它们是同一条例子
; 可以通过添加限制条件来过滤

(define (person->string person)
 (if (null? person)
     ""
     (string-append (symbol->string (car person)) (person->string (cdr person)))))
(define (person>? p1 p2)
 (string>? (person->sring p1) (person->string p2)))

(rule (asy-lives-near ?person1 ?person2)
  (and (address ?person1 (?town . ?rest-1))
          (address ?person2 (?town . ?rest-2))
          (lisp-value person>? ?person1 ?person2)))

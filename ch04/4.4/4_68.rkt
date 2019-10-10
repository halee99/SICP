(rule (append-to-form () ?y ?y))

(rule (append-to-form (?u . ?v) ?y (?u . ?z))
      (append-to-form ?v ?y ?z))

(rule (reverse () ()))
(rule (reverse (?x . ?y) ?z)
 (and (append-to-form ?v (?x) ?z)
      (reverse ?y ?v)))

; (reverse (1 2 3) ?x) 得
; 无限循环

; (reverse ?x (1 2 3)) 得
; (reverse (3 2 1) (1 2 3))


(rule (reverse () ()))
(rule (reverse ?z (?x . ?y))
  (and (append-to-form ?v (?x) ?z)
       (reverse ?y ?v)))

; (reverse (1 2 3) ?x) 得
; (reverse (1 2 3) (3 2 1))

; (reverse ?x (1 2 3)) 得
; 无限循环     

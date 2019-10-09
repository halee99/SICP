(rule (outranked-by ?staff-person ?boss)
  (or (supervisor ?staff-person ?boss)
      (and (outranked-by ?middle-manager ?boss)
           (supervisor ?staff-person ?middle-manager))))

; (outranked-by (Bitdiddle Ben) ?who) 与 (outranked-by ?staff-person ?boss) 合一得:
;   (outranked-by (Bitdiddle Ben) ?who) 查询, 其中得:
;     (outranked-by (Bitdiddle Ben) ?who) 与 (outranked-by ?middle-manager ?boss) 合一又得:
;       (outranked-by (Bitdiddle Ben) ?who) 循环

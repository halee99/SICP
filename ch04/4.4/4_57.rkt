(rule (can-replace ?a ?b)
  (or (and (job ?a ?work)
           (job ?b ?work)
           (not (same ?a ?b)))
      (and (job ?a ?work-a)
           (job ?b ?work-b)
           (or (can-do-job ?work-a ?work-b)
               (can-do-job ?work-b ?work-a))
           (not (same ?a ?b)))))


; a)
(can-replace ?person (Fect Cy D))

; b)
(and (can-replace ?person ?me)
     (salary ?person ?amount-person)
     (salary ?me ?amount-me)
     (lisp-value > ?amount-person ?amount-me))

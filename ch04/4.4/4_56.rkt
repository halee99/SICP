; a)
(and (supervisor ?person (Bitdiddle Ben))
     (address ?person ?where))

; b)
(and (salary (Bitdiddle Ben) ?amount-Ben)
     (salary ?person ?amount)
     (lisp-value < ?amount ?amount-Ben))

; c)
(and (job ?person ?work)
     (supervisor ?person ?superior)
     (not (job ?superior (computer . ?type))))

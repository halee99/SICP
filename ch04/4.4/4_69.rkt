(rule (real-son ?person ?son)
  (or (son ?person ?son)
      (and (wife ?person ?wife)
           (son ?wife ?son))))

(rule (grandson ?grandpa ?gson)
  (and (real-son ?person ?son)
       (real-son ?son ?gson)))



(rule (end-with-grandson (grandson)))
(rule (end-with-grandson (?x . ?other))
     (end-with-grandson ?other))

(rule ((grandson) ?x ?y)
     (grandson ?x ?y))

(rule ((great . ?rel) ?x ?y)
     (and (end-with-grandson ?rel)
          (real-son ?x ?z)
          (?rel ?z ?y)))

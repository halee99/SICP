(rule (department-boss ?person ?department)
  (and (job ?person (?department . ?type))
       (job ?maybe-boss (?department . ?other))
       (not (supervisor ?person ?maybe-boss))))

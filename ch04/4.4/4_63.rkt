; (son Adam Cain)
; (son Cain Enoch)
; (son Enoch Irad)
; (son Irad Mehujael)
; (son Mehujael Methushael)
; (son Methushael Lamech)
; (wife Lamech Ada)
; (son Ada Jabal)
; (son Ada Jubal)

(rule (real-son ?person ?son)
  (or (son ?person ?son)
      (and (wife ?person ?wife)
           (son ?wife ?son))))

(rule (grandson ?grandpa ?gson)
  (and (real-son ?person ?son)
       (real-son ?son ?gson)))


; Cain 的孙子
(grandson Cain ?gson)
; Lamech 的儿子
(real-son Lamech ?son)
; Methushael 的孙子
(grandson Methushael ?gson)

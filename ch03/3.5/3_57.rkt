; 没有 memo-proc 过程优化的 fibs
; 每个 (stream-ref fibs i) ，都要对 (stream-ref fibs (- i 1)) 和 (stream-ref fibs (- i 2)) 进行一次加法，
; 而对 (stream-ref fibs (- i 1)) 的求值又引发 (stream-ref fibs (-i 2) 和 (stream-ref fibs (- i 3)) 进行相加，
; 以此类推，一直回溯到 0 和 1 为止.

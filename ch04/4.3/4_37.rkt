(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high))
        (hsq (* high high)))
    (let ((j (an-integer-between i high)))
      (let ((ksq (+ (* i i) (* j j))))
        (require (>= hsq ksq))
        (let ((k (sqrt ksq)))
          (require (integer? k))
          (list i j k))))))

; 效率更高
; 因为，如(8 15 17)。当 i 和 j 分别为 8 和 15时, k 不为 17。就得重新求值, 但是(i j) (8 15) 是合适结果，却需要寻找合适的 k
; 4.35 的时间复杂度是 O(n^3), 4.37 的时间复杂度是 O(n^2)

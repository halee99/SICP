(define (swap-item-to-head lt n)
  (define (find l i)
    (if (= i 0)
        l
        (find (cdr l) (- i 1))))
  (let ((head (car lt))
        (item (list-ref lt n)))
      (set-car! lt item)
      (set-car! (find lt n) head)
      lt))

(define (analyze-ramb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
        (if (null? choices)
            (fail)
            ((car (swap-item-to-head choices (random (length choices))))
                env
                succeed
                (lambda ()
                  (try-next (cdr choices))))))
      (try-next cprocs))))

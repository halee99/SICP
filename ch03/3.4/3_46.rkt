; https://sicp.readthedocs.io/en/latest/chp3/46.html

; 以下是两个进程 P1 、 P2 同时对互斥元进行非原子性的 test-and-set! 操作造成错误的步骤：
;   |   P1                             mutex                             P2
;   |   |                                                                 |
;   |   |                                                                 |
;   |   |                                                                 |
;   |   +----------------------------> false <----------------------------+
;   |    test-and-set!                                       test-and-set!
;   |          |                                                   |
;   |          |                                                   |
;   |          +--------------------->  true <---------------------+
;   |    (begin (set-car! cell true)           (begin (set-car! cell true)
;   |           false)                                false)
;   |
;   v
; time
; 因为没有保证 test-and-set! 的原子性，所以 P1 和 P2 可以同时对互斥元进行设置，在执行的最后， P1 和 P2 都获取了互斥元，这明显是错误的。

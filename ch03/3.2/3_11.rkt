#lang racket

; 我就不描点画了
; https://sicp.readthedocs.io/en/latest/chp3/11.html
(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT"
                       m))))
  dispatch)

; (define acc (make-account 50))

; ((acc 'deposit) 40)
; ((acc 'withdraw) 60)

;: (define acc2 (make-account 100))



为了方便分析，我们将上面的过程转换成以下的一系列 lambda 表达式：

(define make-account

    (lambda (balance)

        (define withdraw
            (lambda (amount)
                (if (>= balance amount)
                    (begin (set! balance (- balance amount))
                           balance)
                    "Insufficient funds")))

        (define deposit 
            (lambda (amount)
                (set! balance (+ balance amount))))

        (define dispatch
            (lambda (m)
                (cond ((eq? m 'withdraw)
                        withdraw)
                      ((eq? m 'deposit)
                        deposit)
                      (else
                        (error "Unknown request -- MAKE-ACCOUNT" m)))))

        dispatch))
		
过程生成的环境模型如下：
          +-------------------------------------+
global -> |                                     |
env       | make-account                        |
          +----|--------------------------------+
               |       ^
               |       |
               v       |
             [*][*]----+
              |
              |
              v
  parameters: balance
  body: (define withdraw ...)
        (define deposit ...)
        (define dispatch ...)
        dispatch

执行定义 (define acc (make-account 50)) ，会产生以下环境：
          +----------------------------------------------------+
global -> |                                                    |
env       | make-account                                       |
          +----|-----------------------------------------------+
               |       ^                     ^
               |       |                     |
               v       |           E1 -> +------------------+
             [*][*]----+                 | balance: 50      |<----------+
              |                          |                  |           |
              |                          | withdraw --------------->[*][*]----> parameters: amount
              v                          |                  |                   body: ...
  parameters: balance                    |                  |<----------+
  body: (define withdraw ...)            |                  |           |
        (define deposit ...)             | deposit ---------------->[*][*]----> parameters: amount
        (define dispatch ...)            |                  |                   body: ...
        (lambda (m) ...)                 |                  |<----------+
                                         |                  |           |
                                         | dispatch --------------->[*][*]----> parameters: m
                                         |                  |                   body: ...
                                         +------------------+
                                         dispatch
			
最后，将以上求值得到的值和符号 acc 关联（前面的求值会返回 dispatch ，于是 acc 就直接指向 E1 环境中的 dispatch 过程对象）：
          +----------------------------------------------------+
global -> |                                                    |
env       | make-account      acc                              |
          +----|---------------|-------------------------------+
               |       ^       |             ^
               |       |       |             |
               v       |       |   E1 -> +------------------+
             [*][*]----+       |         | balance: 50      |<----------+
              |                |         |                  |           |
              |                |         | withdraw --------------->[*][*]----> parameters: amount
              v                |         |                  |                   body: ...
  parameters: balance          |         |                  |<----------+
  body: (define withdraw ...)  |         |                  |           |
        (define deposit ...)   |         | deposit ---------------->[*][*]----> parameters: amount
        (define dispatch ...)  |         |                  |                   body: ...
        (lambda (m) ...)       |         |                  |<----------+
                               |         |                  |           |
                               +---------->dispatch --------------->[*][*]----> parameters: m
                                         |                  |                   body: ...
                                         +------------------+

求值表达式 ((acc 'deposit) 40) ，产生以下环境：
          +----------------------------------------------------+
global -> |                                                    |
env       | make-account      acc                              |
          +----|---------------|-------------------------------+
               |       ^       |             ^
               |       |       |             |
               v       |       |   E1 -> +------------------+
             [*][*]----+       |         | balance: 50      |<----------+
              |                |         |                  |           |
              |                |         | withdraw --------------->[*][*]----> parameters: amount
              v                |         |                  |                   body: ...
  parameters: balance          |         |                  |<----------+
  body: (define withdraw ...)  |         |                  |           |
        (define deposit ...)   |         | deposit ---------------->[*][*]----> parameters: amount
        (define dispatch ...)  |         |                  |                   body: ...
        (lambda (m) ...)       |         |                  |<----------+
                               |         |                  |           |
                               +---------->dispatch --------------->[*][*]----> parameters: m
                                         |                  |                   body: ...
                                         +------------------+
                                                    ^
                                                    |
                                                    |
                                   (acc 'deposit)   |
                                                    |
                                            +-------------+
                                            |             |
                                      E2 -> | m: 'deposit |
                                            |             |
                                            +-------------+
                                            (cond ((eq? m 'withdraw)
                                                    withdraw)
                                                  ((eq? m 'deposit)
                                                    deposit)
                                                  (else
                                                    (error "..." m)))

(acc 'deposit) 将返回过程 deposit ，这个 deposit 又作为新的过程操作符，被参数 40 应用，并且 E2 在求值之后消失：
          +----------------------------------------------------+
global -> |                                                    |
env       | make-account      acc                              |
          +----|---------------|-------------------------------+
               |       ^       |             ^
               |       |       |             |
               v       |       |   E1 -> +------------------+
             [*][*]----+       |         | balance: 50      |<----------+
              |                |         |                  |           |
              |                |         | withdraw --------------->[*][*]----> parameters: amount
              v                |         |                  |                   body: ...
  parameters: balance          |         |                  |<----------+
  body: (define withdraw ...)  |         |                  |           |
        (define deposit ...)   |         | deposit ---------------->[*][*]----> parameters: amount
        (define dispatch ...)  |         |                  |                   body: ...
        (lambda (m) ...)       |         |                  |<----------+
                               |         |                  |           |
                               +---------->dispatch --------------->[*][*]----> parameters: m
                                         |                  |                   body: ...
                                         +------------------+
                                                    ^
                                                    |
                                                    |
                                       (deposit 40) |
                                                    |
                                            +------------+
                                            |            |
                                      E3 -> | amount: 40 |
                                            |            |
                                            +------------+
                                            (set! balance (+ balance amount))

表达式在 E3 环境中求值，沿着外围环境指针查找并修改 balance 的值，求值完毕之后， E3 消失：
          +----------------------------------------------------+
global -> |                                                    |
env       | make-account      acc                              |
          +----|---------------|-------------------------------+
               |       ^       |             ^
               |       |       |             |
               v       |       |   E1 -> +------------------+
             [*][*]----+       |         | balance: 90      |<----------+
              |                |         |                  |           |
              |                |         | withdraw --------------->[*][*]----> parameters: amount
              v                |         |                  |                   body: ...
  parameters: balance          |         |                  |<----------+
  body: (define withdraw ...)  |         |                  |           |
        (define deposit ...)   |         | deposit ---------------->[*][*]----> parameters: amount
        (define dispatch ...)  |         |                  |                   body: ...
        (lambda (m) ...)       |         |                  |<----------+
                               |         |                  |           |
                               +---------->dispatch --------------->[*][*]----> parameters: m
                                         |                  |                   body: ...
                                         +------------------+
										 
以上就是求值之后得到的环境，注意 balance 的值已经被修改为 90 了。
然后，进行第二次求值 ((acc 'withdraw) 60) ，得出以下环境：
          +----------------------------------------------------+
global -> |                                                    |
env       | make-account      acc                              |
          +----|---------------|-------------------------------+
               |       ^       |             ^
               |       |       |             |
               v       |       |   E1 -> +------------------+
             [*][*]----+       |         | balance: 90      |<----------+
              |                |         |                  |           |
              |                |         | withdraw --------------->[*][*]----> parameters: amount
              v                |         |                  |                   body: ...
  parameters: balance          |         |                  |<----------+
  body: (define withdraw ...)  |         |                  |           |
        (define deposit ...)   |         | deposit ---------------->[*][*]----> parameters: amount
        (define dispatch ...)  |         |                  |                   body: ...
        (lambda (m) ...)       |         |                  |<----------+
                               |         |                  |           |
                               +---------->dispatch --------------->[*][*]----> parameters: m
                                         |                  |                   body: ...
                                         +------------------+
                                                   ^
                                                   |
                                                   |
                                             +--------------+
                                             |              |
                                       E4 -> | m: 'withdraw |
                                             |              |
                                             +--------------+
                                             (cond ((eq? m 'withdraw)
                                                     withdraw)
                                                   ((eq? m 'deposit)
                                                     deposit)
                                                   (else
                                                     (error "...")))
													 
接着求值表达式 (withdraw 60) ：
          +----------------------------------------------------+
global -> |                                                    |
env       | make-account      acc                              |
          +----|---------------|-------------------------------+
               |       ^       |             ^
               |       |       |             |
               v       |       |   E1 -> +------------------+
             [*][*]----+       |         | balance: 90      |<----------+
              |                |         |                  |           |
              |                |         | withdraw --------------->[*][*]----> parameters: amount
              v                |         |                  |                   body: ...
  parameters: balance          |         |                  |<----------+
  body: (define withdraw ...)  |         |                  |           |
        (define deposit ...)   |         | deposit ---------------->[*][*]----> parameters: amount
        (define dispatch ...)  |         |                  |                   body: ...
        (lambda (m) ...)       |         |                  |<----------+
                               |         |                  |           |
                               +---------->dispatch --------------->[*][*]----> parameters: m
                                         |                  |                   body: ...
                                         +------------------+
                                                   ^
                                                   |
                                                   |
                                             +------------+
                                             |            |
                                       E5 -> | amount: 60 |
                                             |            |
                                             +------------+
                                            (if (>= balance amount)
                                                (begin (set! balance (- balance amount))
                                                       balance)
                                                "...")
												
以下是求值完毕之后的环境：
          +----------------------------------------------------+
global -> |                                                    |
env       | make-account      acc                              |
          +----|---------------|-------------------------------+
               |       ^       |             ^
               |       |       |             |
               v       |       |   E1 -> +------------------+
             [*][*]----+       |         | balance: 30      |<----------+
              |                |         |                  |           |
              |                |         | withdraw --------------->[*][*]----> parameters: amount
              v                |         |                  |                   body: ...
  parameters: balance          |         |                  |<----------+
  body: (define withdraw ...)  |         |                  |           |
        (define deposit ...)   |         | deposit ---------------->[*][*]----> parameters: amount
        (define dispatch ...)  |         |                  |                   body: ...
        (lambda (m) ...)       |         |                  |<----------+
                               |         |                  |           |
                               +---------->dispatch --------------->[*][*]----> parameters: m
                                         |                  |                   body: ...
                                         +------------------+
										 
注意 balance 已经被修改为 30 了。
最后，如果我们进行定义 (define acc2 (make-account 100)) ，那么会产生另一个 make-account 过程对象，
这个过程并不和 acc 共享任何的过程或者状态变量，具体的环境定义如下：
          +---------------------------------------------------------------+
global -> |                                                               |
env       | make-account        acc2    acc                               |
          +----|-----------------|--------|-------------------------------+
               |       ^         |        |             ^
               |       |         |        |             |
               v       |         |        |   E1 -> +------------------+
             [*][*]----+         |        |         | balance: 30      |<----------+
              |                  |        |         |                  |           |
              |                  |        |         | withdraw --------------->[*][*]----> parameters: amount
              v                  |        |         |                  |                   body: ...
  parameters: balance            |        |         |                  |<----------+
  body: (define withdraw ...)    |        |         |                  |           |
        (define deposit ...)     |        |         | deposit ---------------->[*][*]----> parameters: amount
        (define dispatch ...)    |        |         |                  |                   body: ...
        (lambda (m) ...)         |        |         |                  |<----------+
                                 |        |         |                  |           |
                                 |        +---------->dispatch --------------->[*][*]----> parameters: m
                                 |                  |                  |                   body: ...
                                 |                  +------------------+
                                 |
                                 |
                                 |
                                 |  E6 -> +------------------+
                                 |        | balance: 100     |<----------+
                                 |        |                  |           |
                                 |        | withdraw --------------->[*][*]----> parameters: amount
                                 |        |                  |                   body: ...
                                 |        |                  |<----------+
                                 |        |                  |           |
                                 |        | deposit ---------------->[*][*]----> parameters: amount
                                 |        |                  |                   body: ...
                                 |        |                  |<----------+
                                 |        |                  |           |
                                 +--------->dispatch --------------->[*][*]----> parameters: m
                                          |                  |                   body: ...
                                          +------------------+
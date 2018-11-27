#lang racket

; 我就不描点画了
; https://sicp.readthedocs.io/en/latest/chp3/10.html

(define (make-withdraw balance)
  (lambda (amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds")))

换成以下 lambda 定义:
(define make-withdraw
    (lambda (initial-amount)
        ((lambda (balance)
            (lambda (amount)
                (if (>= balance amount)
                    (begin (set! balance (- balance amount))
                           balance)
                    "Insufficient funds")))
         initial-amount)))


lambda 版本的 make-withdraw 创建以下过程对象：
              +------------------------------------+
global env -> |                                    |
              |   make-withdraw --+                |
              +-------------------|----------------+
                                  |       ^
                                  |       |
                                  v       |
                                [*][*]----+
                                 |
                                 |
                                 v
                        parameters: initial-amount
                        body: ((lambda (balance)
                                   (lambda (amount)
                                       (if (>= balance amount)
                                           (begin (set! balance (- balance amount))
                                                  balance)
                                           "Insufficient funds")))
                               initial-amount)

执行表达式 (define w1 (make-withdraw 100)) ，我们得到以下环境：
              +------------------------------------+
global env -> |                                    |
              |                                    |
              +------------------------------------+
                     ^
(make-withdraw 100)  |
                     |
                 +--------------+
                 |              |
          E1 ->  | initial: 100 |
                 |              |
                 +--------------+

                ((lambda (balance)
                     (lambda (amount)
                         (if (>= balance amount)
                             (begin (set! balance (- balance amount))
                                    balance)
                             "Insufficient funds")))
                 initial)

make-withdraw 的函数体内又是一个函数调用，所以以上的求值又引发以下的求值发生。
首先是创建又一个过程对象：
              +------------------------------------+
global env -> |                                    |
              |                                    |
              +------------------------------------+
                     ^
(make-withdraw 100)  |
                     |
                 +--------------+
                 |              |
          E1 ->  | initial: 100 |
                 |              |
                 +--------------+
                   |        ^
                   |        |
                   |        |
               [*][*]-------+
                |
                |
                v
        parameters: balance
        body: (lambda (amount)
                  (if (>= balance amount)
                      (begin (set! balance (- balance amount))
                             balance)
                      "Insufficient funds"))
而这个新的过程对象会即刻被调用，继而产生又一个新环境：
              +------------------------------------+
global env -> |                                    |
              |                                    |
              +------------------------------------+
                     ^
(make-withdraw 100)  |
                     |
                 +--------------+
                 |              |
          E1 ->  | initial: 100 |
                 |              |
                 +--------------+
                              ^
((lambda (balance) ...) 100)  |
                              |
                        +--------------+
                        |              |
                 E2 ->  | balance: 100 |
                        |              |
                        +--------------+

                       (lambda (amount)
                           (if (>= balance amount)
                               (begin (set! balance (- balance amount))
                                      balance)
                               "Insufficient funds"))
(lambda (balance) ...) 的体内是另一个 lambda 表达式 (lambda (amount) ...) ，因此我们要为它创建又一个过程对象：
              +------------------------------------+
global env -> |                                    |
              |                                    |
              +------------------------------------+
                     ^
(make-withdraw 100)  |
                     |
                 +--------------+
                 |              |
          E1 ->  | initial: 100 |
                 |              |
                 +--------------+
                              ^
((lambda (balance) ...) 100)  |
                              |
                        +--------------+
                        |              |
                 E2 ->  | balance: 100 |
                        |              |
                        +--------------+
                           |        ^
                           |        |
                           v        |
                         [*][*]-----+
                          |
                          |
                          v
                   parameters: amount
                   body: (if (>= balance amount)
                             (begin (set! balance (- balance amount))
                                    balance)
                             "Insufficient funds")
对 (make-withdraw 100) 的求值过程到此就暂告一段落了，这时，可以将符号 w1 和所得的过程对象建立约束(bundle)了：
              +-------------------------------------------+
global env -> |                                           |
              |   w1                                      |
              +---|---------------------------------------+
                  |                               ^
                  |          (make-withdraw 100)  |
                  |                               |
                  |                    +--------------+
                  |                    |              |
                  |             E1 ->  | initial: 100 |
                  |                    |              |
                  |                    +--------------+
                  |                               ^
                  | ((lambda (balance) ...) 100)  |
                  |                               |
                  |                    +--------------+
                  |                    |              |
                  |             E2 ->  | balance: 100 |
                  |                    |              |
                  |                    +--------------+
                  |                      |        ^
                  |                      |        |
                  |                      v        |
                  +------------------> [*][*]-----+
                                        |
                                        |
                                        v
                                 parameters: amount
                                 body: (if (>= balance amount)
                                           (begin (set! balance (- balance amount))
                                           balance)
                                       "Insufficient funds")

使用之前求值得到的 w1 ，执行表达式 (w1 50) ，会创建以下环境：
              +-------------------------------------------+
global env -> |                                           |
              |   w1                                      |
              +---|---------------------------------------+
                  |                               ^
                  |          (make-withdraw 100)  |
                  |                               |
                  |                    +--------------+
                  |                    |              |
                  |             E1 ->  | initial: 100 |
                  |                    |              |
                  |                    +--------------+
                  |                               ^
                  | ((lambda (balance) ...) 100)  |
                  |                               |
                  |                    +--------------+
                  |                    |              |
                  |             E2 ->  | balance: 100 |
                  |                    |              |
                  |                    +--------------+
                  |                      |        ^  ^
                  |                      |        |  |                                    +------------+
                  |                      v        |  |                                    |            |
                  +------------------> [*][*]-----+  +------------------------------------| amount: 50 | <- E3
                                        |                                                 |            |
                                        |                                                 +------------+
                                        v
                                 parameters: amount                                    (if (>= balance amount)
                                 body: (if (>= balance amount)                             (begin (set! balance (- balance amount))
                                           (begin (set! balance (- balance amount))               balance)
                                           balance)                                        "Insufficient funds")
                                       "Insufficient funds")
环境 E3 在执行过程体中的表达式之后消失， E2 的 balance 被设置为 50 ，以下是求值完毕之后的环境图：
              +-------------------------------------------+
global env -> |                                           |
              |   w1                                      |
              +---|---------------------------------------+
                  |                               ^
                  |          (make-withdraw 100)  |
                  |                               |
                  |                    +--------------+
                  |                    |              |
                  |             E1 ->  | initial: 100 |
                  |                    |              |
                  |                    +--------------+
                  |                               ^
                  | ((lambda (balance) ...) 100)  |
                  |                               |
                  |                    +--------------+
                  |                    |              |
                  |             E2 ->  | balance: 50  |
                  |                    |              |
                  |                    +--------------+
                  |                      |        ^
                  |                      |        |
                  |                      v        |
                  +------------------> [*][*]-----+
                                        |
                                        |
                                        v
                                 parameters: amount
                                 body: (if (>= balance amount)
                                           (begin (set! balance (- balance amount))
                                           balance)
                                       "Insufficient funds")
最后，定义另一个 make-withdraw 实例 w2 ，它的功能性和 w1 类似，但是却保存着自己的一簇状态变量和过程对象（最明显的就是它们各自的 balance 变量）：
              +-----------------------------------------------------------------------------------------+
global env -> |                                                                                         |
              |   w1                                        w2                                          |
              +---|-----------------------------------------|-------------------------------------------+
                  |                               ^         |                               ^
                  |          (make-withdraw 100)  |         |                               |
                  |                               |         |                               |
                  |                    +--------------+     |                      +--------------+
                  |                    |              |     |                      |              |
                  |             E1 ->  | initial: 100 |     |               E1 ->  | initial: 100 |
                  |                    |              |     |                      |              |
                  |                    +--------------+     |                      +--------------+
                  |                               ^         |                               ^
                  | ((lambda (balance) ...) 100)  |         | ((lambda (balance) ...) 100)  |
                  |                               |         |                               |
                  |                    +--------------+     |                      +--------------+
                  |                    |              |     |                      |              |
                  |             E2 ->  | balance: 50  |     |               E2 ->  | balance: 100 |
                  |                    |              |     |                      |              |
                  |                    +--------------+     |                      +--------------+
                  |                      |        ^         |                          |       ^
                  |                      |        |         |                          |       |
                  |                      v        |         |                          v       |
                  +------------------> [*][*]-----+         +----------------------->[*][*]----+
                                        |                                             |
                                        |                                             |
                                        v                                             v
                         parameters: amount                             parameters: amount
                         body: (if (>= balance amount)                  body: (if (>= balance amount)
                                   (begin (set! balance                           (begin (set! balance
                                                (- balance amount))                      (- balance amount))
                                          balance)                                balance)
                                   "Insufficient funds")                          "Insufficient funds")

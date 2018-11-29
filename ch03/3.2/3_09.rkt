#lang racket

; 我就不描点画了
; https://sicp.readthedocs.io/en/latest/chp3/9.html

(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))

以下是 factorial 创建的过程对象
                +---------------------------------+
global env -->  |                                 |
                |  factorial --+                  |
                +--------------|------------------+
                               |       ^
                               |       |
                               |       |
                             [*][*]----+
                              |
                              |
                              v
                         parameters: n
                         body: (if (= n 1)
                                      1
                                      (* n (factorial (- n 1))))

以下是对 (factorial 6) 进行求值时所创建的环境结构（为了节约空间，将 factorial 表示为 f ）：
                +---------------------------------+
global env -->  |                                 |
                |                                 |
                +---------------------------------+
                   ^
            (f 6)  |
                   |
                +------+
                |      |
          E1 -> | n: 6 |
                |      |
                +------+

              (* 6 (f 5))

                +---------------------------------+
global env -->  |                                 |
                |                                 |
                +---------------------------------+
                   ^               ^
            (f 6)  |        (f 5)  |
                   |               |
                +------+        +------+
                |      |        |      |
          E1 -> | n: 6 |  E2->  | n: 5 |
                |      |        |      |
                +------+        +------+

             (* 6 (f 5))      (* 5 (f 4))

                +--------------------------------------------+
global env -->  |                                            |
                |                                            |
                +--------------------------------------------+
                   ^               ^              ^
            (f 6)  |        (f 5)  |       (f 4)  |
                   |               |              |
                +------+        +------+        +------+
                |      |        |      |        |      |
          E1 -> | n: 6 |  E2->  | n: 5 |  E3 -> | n: 4 |
                |      |        |      |        |      |
                +------+        +------+        +------+

             (* 6 (f 5))      (* 5 (f 4))     (* 4 (f 3))

                +----------------------------------------------------------+
global env -->  |                                                          |
                |                                                          |
                +----------------------------------------------------------+
                   ^               ^              ^                ^
            (f 6)  |        (f 5)  |       (f 4)  |         (f 3)  |
                   |               |              |                |
                +------+        +------+        +------+         +------+
                |      |        |      |        |      |         |      |
          E1 -> | n: 6 |  E2->  | n: 5 |  E3 -> | n: 4 |  E4 ->  | n: 3 |
                |      |        |      |        |      |         |      |
                +------+        +------+        +------+         +------+

             (* 6 (f 5))      (* 5 (f 4))     (* 4 (f 3))      (* 3 (f 2))

                +--------------------------------------------------------------------------+
global env -->  |                                                                          |
                |                                                                          |
                +--------------------------------------------------------------------------+
                   ^               ^              ^                ^               ^
            (f 6)  |        (f 5)  |       (f 4)  |         (f 3)  |        (f 2)  |
                   |               |              |                |               |
                +------+        +------+        +------+         +------+        +------+
                |      |        |      |        |      |         |      |        |      |
          E1 -> | n: 6 |  E2->  | n: 5 |  E3 -> | n: 4 |  E4 ->  | n: 3 |  E5 -> | n: 2 |
                |      |        |      |        |      |         |      |        |      |
                +------+        +------+        +------+         +------+        +------+

             (* 6 (f 5))      (* 5 (f 4))     (* 4 (f 3))      (* 3 (f 2))     (* 2 (f 1))


                +------------------------------------------------------------------------------------------+
global env -->  |                                                                                          |
                |                                                                                          |
                +------------------------------------------------------------------------------------------+
                   ^               ^              ^                ^               ^               ^
            (f 6)  |        (f 5)  |       (f 4)  |         (f 3)  |        (f 2)  |        (f 1)  |
                   |               |              |                |               |               |
                +------+        +------+        +------+         +------+        +------+        +------+
                |      |        |      |        |      |         |      |        |      |        |      |
          E1 -> | n: 6 |  E2->  | n: 5 |  E3 -> | n: 4 |  E4 ->  | n: 3 |  E5 -> | n: 2 |  E6 -> | n: 1 |
                |      |        |      |        |      |         |      |        |      |        |      |
                +------+        +------+        +------+         +------+        +------+        +------+

             (* 6 (f 5))      (* 5 (f 4))     (* 4 (f 3))      (* 3 (f 2))     (* 2 (f 1))        1


(define (factorial-2 n)
  (fact-iter 1 1 n))

(define (fact-iter product counter max-count)
  (if (> counter max-count)
      product
      (fact-iter (* counter product)
                 (+ counter 1)
                 max-count)))

以下是迭代版 factorial 创建的过程对象
                +----------------------------------------------------------+
global env -->  |                                                          |
                |  factorial --+                 fact-iter --+             |
                +--------------|-----------------------------|-------------+
                               |       ^                     |        ^
                               |       |                     |        |
                               |       |                     |        |
                             [*][*]----+                   [*][*]-----+
                              |                             |
                              |                             |
                              v                             v
                       parameters: n                  parameters: product counter max-count
                       body: (fact-iter 1 1 n)        body: (if (> counter max-count)
                                                                product
                                                                (fact-iter (* counter product)
                                                                           (+ counter 1)
                                                                           max-count))

以下是对 (factorial 6) 求值时所创建的环境结构
(为了节约空间, factorial 表示为 f , fact-iter 表示为 i ,
product 表示为 p , counter 表示为 c , max-count 表示为 m)：
         +----------+
global   |          |
env -->  |          |
         |          |
         +----------+
            ^
      (f 6) |
            |
        +-------+
        |       |
  E1 -> | n: 6  |
        |       |
        +-------+
        (i 1 1 6)

         +---------------------------+
global   |                           |
env -->  |                           |
         |                           |
         +---------------------------+
            ^               ^
      (f 6) |     (i 1 1 6) |
            |               |
        +-------+        +-------+
        |       |        | p: 1  |
  E1 -> | n: 6  |  E2 -> | c: 1  |
        |       |        | m: 6  |
        +-------+        +-------+
        (i 1 1 6)        (i 1 2 6)


...... 中间部分省略


         +-----------------------------------------------------------------------------------------------------------------------------+
global   |                                                                                                                             |
env -->  |                                                                                                                             |
         |                                                                                                                             |
         +-----------------------------------------------------------------------------------------------------------------------------+
            ^               ^                 ^                ^               ^                 ^                  ^               ^
      (f 6) |     (i 1 1 6) |       (i 1 2 6) |      (i 2 3 6) |     (i 6 4 6) |      (i 24 5 6) |      (i 120 6 6) |   (i 720 7 6) |
            |               |                 |                |               |                 |                  |               |
        +-------+        +-------+        +-------+        +-------+        +-------+        +-------+        +-------+        +-------+
        |       |        | p: 1  |        | p: 1  |        | p: 2  |        | p: 6  |        | p: 24 |        | p:120 |        | p:720 |
  E1 -> | n: 6  |  E2 -> | c: 1  |  E3 -> | c: 2  |  E4 -> | c: 3  |  E5 -> | c: 4  |  E6 -> | c: 5  |  E7 -> | c: 6  |  E8 -> | c: 7  |
        |       |        | m: 6  |        | m: 6  |        | m: 6  |        | m: 6  |        | m: 6  |        | m: 6  |        | m: 6  |
        +-------+        +-------+        +-------+        +-------+        +-------+        +-------+        +-------+        +-------+
        (i 1 1 6)        (i 1 2 6)        (i 2 3 6)        (i 6 4 6)       (i 24 5 6)       (i 120 6 6)      (i 720 7 6)       720
#lang racket
(require "constraint_system.rkt")
; https://sicp.readthedocs.io/en/latest/chp3/36.html

(define a (make-connector))
(define b (make-connector))
; 环境图如下
;            +--------------------------------------------------------------------------------------------------------------------------+
;            |                                                                                                                          |
; global --> |  a                                                             b                                                         |
; env        |  |                                                             |                                                         |
;            +--|-------------------------------------------------------------|---------------------------------------------------------+
;               |                   ^                                         |           ^
;               |                   |                                         |           |
;               |         +------------------+                                |     +------------------+
;               |         |                  |                                |     |                  |
;               |         | value: #f        |                                |     | value: #f        |
;               |         | informant: #f    |                                |     | informant: #f    |
;               |         | constraints: '() |                                |     | constraints: '() |
;               |         |                  |                                |     |                  |
;               |         |                  |<--------+                      |     |                  |<--------+
;               |         |                  |         |                      |     |                  |         |
;               |         | set-my-value: -------> [*][*]                     |     | set-my-value: -------> [*][*]
;               |         |                  | parameters: newvalue setter    |     |                  | parameters: newvalue setter
;               |         |                  | body: ...                      |     |                  | body: ...
;               |         |                  |                                |     |                  |
;               |         |                  |<--------+                      |     |                  |<--------+
;               |         |                  |         |                      |     |                  |         |
;               |         | forget-my-value: ----> [*][*]                     |     | forget-my-value: ----> [*][*]
;               |         |                  | parameters: retractor          |     |                  | parameters: retractor
;               |         |                  | body: ...                      |     |                  | body: ...
;               |         |                  |                                |     |                  |
;               |         |                  |<--------+                      |     |                  |<--------+
;               |         |                  |         |                      |     |                  |         |
;               |         | connect: ------------> [*][*]                     |     | connect: ------------> [*][*]
;               |         |                  | parameters: new-constraint     |     |                  | parameters: new-constraint
;               |         |                  | body: ...                      |     |                  | body: ...
;               |         |                  |                                |     |                  |
;               |         |                  |<--------+                      |     |                  |<--------+
;               |         |                  |         |                      |     |                  |         |
;               +---------->me: -----------------> [*][*]                     +------>me: -----------------> [*][*]
;                         |                  | parameters: request                  |                  | parameters: request
;                         |                  | body: ...                            |                  | body: ...
;                         |                  |                                      |                  |
;                         +------------------+                                      +------------------+

(set-value! a 10 'user)
; 运行到 (for-each-except setter inform-about-value constraints) 环境图如下：
;            +---------------------------------------------------------------------------------------------------------------------------+
;            |                                                                                                                           |
;            |                                                       inform-about-value                                                  |
;            |                                                              |                                                            |
; global --> |  a                                                           |     b                                                      |
; env        |  |                                          set-value!       |     |                                                      |
;            +--|---------------------------------------------|-------------|-----|------------------------------------------------------+
;               |                   ^                         |  ^          |  ^  |         ^
;               |                   |                        [*][*]         |  |  |         |
;               |         +------------------+            parameters:       |  |  |   +------------------+
;               |         |                  |                connector     |  |  |   |                  |
;               |         | value: 10        |                new-value     |  |  |   | value: #f        |
;               |         | informant: 'user |                informant     |  |  |   | informant: #f    |
;               |         | constraints: '() |            body: ...         |  |  |   | constraints: '() |
;               |         |                  |                              |  |  |   |                  |
;               |         |                  |<--------+                    |  |  |   |                  |<--------+
;               |         |                  |         |                    |  |  |   |                  |         |
;               |         | set-my-value: -------> [*][*]                   |  |  |   | set-my-value: -------> [*][*]
;               |         |                  | parameters: newvalue setter  |  |  |   |                  | parameters: newvalue setter
;               |         |                  | body: ...                    |  |  |   |                  | body: ...
;               |         |                  |                              |  |  |   |                  |
;               |         |                  |<--------+                    |  |  |   |                  |<--------+
;               |         |                  |         |                    |  |  |   |                  |         |
;               |         | forget-my-value: ----> [*][*]                   |  |  |   | forget-my-value: ----> [*][*]
;               |         |                  | parameters: retractor        |  |  |   |                  | parameters: retractor
;               |         |                  | body: ...                    |  |  |   |                  | body: ...
;               |         |                  |                              |  |  |   |                  |
;               |         |                  |<--------+                    |  |  |   |                  |<--------+
;               |         |                  |         |                    |  |  |   |                  |         |
;               |         | connect: ------------> [*][*]                   |  |  |   | connect: ------------> [*][*]
;               |         |                  | parameters: new-constraint   |  |  |   |                  | parameters: new-constraint
;               |         |                  | body: ...                    |  |  |   |                  | body: ...
;               |         |                  |                              |  |  |   |                  |
;               |         |                  |<--------+                    |  |  |   |                  |<--------+
;               |         |                  |         |                    |  |  |   |                  |         |
;               +---------->me: -----------------> [*][*]                   |  |  +------>me: -----------------> [*][*]
;                         |                  | parameters: request          |  |      |                  | parameters: request
;                         |                  | body: ...                    |  |      |                  | body: ...
;                         |                  |                              |  |      |                  |
;                         +------------------+                              |  |      +------------------+
;                                  ^                                        |  |
;                                  |                                        |  |
;       (set-my-value 10 'user)    |                                        |  |
;                                  |                                        |  |
;                                  |                                        |  |
;                         +------------------+                              |  |
;                         |                  |                              |  |
;                         | newval: 10       |                              |  |
;                         | setter: 'user    |                              |  |
;                         |                  |                              |  |
;                         +------------------+                              |  |
;                                  ^                                        |  |
;                                  |                                        |  |
;     (for-each-except             |                                        |  |
;         'user                    |                                        |  |
;         inform-about-new-value   |                                        |  |
;         '())                     |                                        |  |
;                                  |                                        |  |
;                                  |                                        |  |
;                         +--------------------+                            |  |
;                         |                    |                            |  |
;                         | exception: 'user   |   inform-about-value       v  |
;                         | procedure:-----------------------------------> [*][*]
;                         | constraints: '()   |                           parameters: constraint
;                         |                    |                           body: (constraint 'I-have-a-value)
;                         |                    |<---------+
;                         |                    |          |
;                         | loop: ------------------> [*][*]
;                         |                    | parameters: items
;                         |                    | body: ...
;                         |                    |
;                         +--------------------+
;                                  ^
;                                  |
;                 (loop '())       |
;                                  |
;                                  |
;                         +--------------------+
;                         |                    |
;                         | items: '()         |
;                         |                    |
;                         +--------------------+
;                         (cond
;                             ((null? items)
;                                 'done)
;                             ((eq? (car items) exception)
;                                 (loop (cdr items)))
;                             (else
;                                 (procedure (car items))
;                                 (loop (cdr items))))

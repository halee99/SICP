#lang racket

(require "huffman.rkt")

(define tree
  (generate-huffman-tree '((A 2) (NA 16)
                           (BOOM 1) (SHA 3)
                           (GET 2) (YIP 9)
                           (JOB 2) (WAH 1))))

; 方便起见 都使用大写
(encode '(GET A JOB) tree)
; '(1 1 1 1 1 1 1 0 0 1 1 1 1 0)
; 14
(encode '(SHA NA NA NA NA NA NA NA NA) tree)
; '(1 1 1 0 0 0 0 0 0 0 0 0)
; 12
(encode '(WAH YIP YIP YIP YIP YIP YIP YIP YIP YIP) tree)
; '(1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0)
; 23
(encode '(SHA BOOM) tree)
; '(1 1 1 0 1 1 0 1 1)
; 9

; 编码后信息所需的二进制位数量为 14 * 2 + 12 * 2 + 23 + 9 = 84
; 其中 前两个出现了两次，所以数量要乘以 2
; 如果采用定长编码，那么 8 个字符每个最少每个要占用 3 个二进制位，
; 而未编码的原文总长度为 3 * 2 + 9 * 2 + 10 + 2 = 36
; 那么使用定长编码所需的二进制位为 36 * 3 = 108
; 使用 huffman 编码比使用定长编码节省了 24 个二进制位

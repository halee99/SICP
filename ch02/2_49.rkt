#lang racket

; 画板配置
(require graphics/graphics)
(open-graphics)
(define vp (open-viewport "A Picture Language" 500 500))

(define draw (draw-viewport vp))
(define (clear) ((clear-viewport vp)))
(define pre-line (draw-line vp))
(define (line start-coord-map end-coord-map)
  (pre-line
    (make-posn (xcor-vect start-coord-map)
               (ycor-vect start-coord-map))
    (make-posn (xcor-vect end-coord-map)
               (ycor-vect end-coord-map))))


; vect
(define (make-vect x y)
  (cons x y))

(define (xcor-vect v)
  (car v))

(define (ycor-vect v)
  (cdr v))

(define (ob-coord ob cor-vect v1 v2)
  (ob (cor-vect v1) (cor-vect v2)))

(define (add-vect v1 v2)
  (make-vect (ob-coord + xcor-vect v1 v2)
             (ob-coord + ycor-vect v1 v2)))

(define (sub-vect v1 v2)
  (make-vect (ob-coord - xcor-vect v1 v2)
             (ob-coord - ycor-vect v1 v2)))

(define (scale-vect s v)
  (make-vect (* s (xcor-vect v))
             (* s (ycor-vect v))))

; frame
(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define (origin-frame frame)
  (car frame))

(define (edge1-frame frame)
  (cadr frame))

(define (edge2-frame frame)
  (cddr frame))

; segment
(define (make-segment v1 v2)
  (cons v1 v2))

(define (start-segment segment)
  (car segment))

(define (end-segment segment)
  (cdr segment))

; frame-coord-map
(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
      (origin-frame frame)
      (add-vect (scale-vect (xcor-vect v)
                            (edge1-frame frame))
                (scale-vect (ycor-vect v)
                            (edge2-frame frame))))))

; segments->painter
(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
      (lambda (segment)
        (line ; 将 draw-line line
          ((frame-coord-map frame) (start-segment segment))
          ((frame-coord-map frame) (end-segment segment))))
      segment-list)))

; 原画板是左上角为原点
; 现调整为左下角为原点 
(define frame (make-frame (make-vect 0 500)
                          (make-vect 500 0)
                          (make-vect 0 -500)))

; a)

(define top (make-segment (make-vect 0.0 1.0)
                          (make-vect 1.0 1.0)))

(define left (make-segment (make-vect 0.0 0.0)
                           (make-vect 0.0 1.0)))

(define bottom (make-segment (make-vect 0.0 0.0)
                             (make-vect 1.0 0.0)))

(define right (make-segment (make-vect 1.0 0.0)
                            (make-vect 1.0 1.0)))

(define border (segments->painter (list top left bottom right)))

; (border frame)

; b)
(define diagon-1 (make-segment (make-vect 0.0 0.0)
                               (make-vect 1.0 1.0)))
;
(define diagon-2 (make-segment (make-vect 0.0 1.0)
                               (make-vect 1.0 0.0)))

(define diagon (segments->painter (list diagon-1 diagon-2)))

; (diagon frame)

; c)
(define top-mid-point (make-vect 0.5 1.0))

(define bottom-mid-point (make-vect 0.5 0.0))

(define left-mid-point (make-vect 0.0 0.5))

(define right-mid-point (make-vect 1.0 0.5))

(define top-to-left (make-segment top-mid-point
                                  left-mid-point))

(define top-to-right (make-segment top-mid-point
                                   right-mid-point))

(define bottom-to-left (make-segment bottom-mid-point
                                     left-mid-point))

(define bottom-to-right (make-segment bottom-mid-point
                                      right-mid-point))

(define diamond  (segments->painter (list top-to-left
                                   top-to-right
                                   bottom-to-left
                                   bottom-to-right)))

; (diamond  frame)

; d)
(define wave (segments->painter (list
                          (make-segment (make-vect 0.4 1.0)      ; 头部左上
                                        (make-vect 0.35 0.85))
                          (make-segment (make-vect 0.35 0.85)    ; 头部左下
                                        (make-vect 0.4 0.64))
                          (make-segment (make-vect 0.4 0.65)     ; 左肩
                                        (make-vect 0.25 0.65))
                          (make-segment (make-vect 0.25 0.65)    ; 左手臂上部
                                        (make-vect 0.15 0.6))
                          (make-segment (make-vect 0.15 0.6)     ; 左手上部
                                        (make-vect 0.0 0.85))

                          (make-segment (make-vect 0.0 0.65)     ; 左手下部
                                        (make-vect 0.15 0.35))
                          (make-segment (make-vect 0.15 0.35)    ; 左手臂下部
                                        (make-vect 0.25 0.6))

                          (make-segment (make-vect 0.25 0.6)     ; 左边身体
                                        (make-vect 0.35 0.5))
                          (make-segment (make-vect 0.35 0.5)     ; 左腿外侧
                                        (make-vect 0.25 0.0))
                          (make-segment (make-vect 0.6 1.0)      ; 头部右上
                                        (make-vect 0.65 0.85))
                          (make-segment (make-vect 0.65 0.85)    ; 头部右下
                                        (make-vect 0.6 0.65))
                          (make-segment (make-vect 0.6 0.65)     ; 右肩
                                        (make-vect 0.75 0.65))
                          (make-segment (make-vect 0.75 0.65)    ; 右手上部
                                        (make-vect 1.0 0.3))

                          (make-segment (make-vect 1.0 0.15)     ; 右手下部
                                        (make-vect 0.6 0.5))
                          (make-segment (make-vect 0.6 0.5)      ; 右腿外侧
                                        (make-vect 0.75 0.0))

                          (make-segment (make-vect 0.4 0.0)      ; 左腿内侧
                                        (make-vect 0.5 0.3))
                          (make-segment (make-vect 0.6 0.0)      ; 右腿内侧
                                        (make-vect 0.5 0.3)))))

(wave frame)

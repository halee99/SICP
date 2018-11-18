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

(define wave-list
  (list (make-segment (make-vect 0.4 1.0)      ; 头部左上
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
                      (make-vect 0.5 0.3))))

; a)
(define wave-a
  (append wave-list
          (list (make-segment (make-vect 0.0 0.5)
                              (make-vect 1.0 0.5)))))

(define wave-a-painter (segments->painter wave-a))

; (wave-a-painter frame)

; b)
(define (right-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split painter (- n 1))))
        (beside painter (below smaller smaller)))))

(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split painter (- n 1))))
        (below painter (beside smaller smaller)))))

(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter
          (make-frame new-origin
                      (sub-vect (m corner1) new-origin)
                      (sub-vect (m corner2) new-origin)))))))

(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0.0)))
    (let ((paint-left
            (transform-painter painter1
                               (make-vect 0.0 0.0)
                               split-point
                               (make-vect 0.0 1.0)))
          (paint-right
            (transform-painter painter2
                               split-point
                               (make-vect 1.0 0.0)
                               (make-vect 0.5 1.0))))
      (lambda (frame)
        (paint-left frame)
        (paint-right frame)))))

;
(define (rotate270 painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))

(define (rotate90 painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))

(define (below painter1 painter2)
  (rotate90 (beside (rotate270 painter1)
                    (rotate270 painter2))))

(define (corner-split painter n)
    (if (= n 0)
        painter
        (let ((up (up-split painter (- n 1)))
              (right (right-split painter (- n 1)))
              (corner (corner-split painter (- n 1))))
            (beside (below painter up)
                    (below right corner)))))


(define wave-painter (segments->painter wave-list))

; ((corner-split wave-painter 4) frame)

; c)

(define (rotate180 painter)
  (transform-painter painter
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 1.0)
                     (make-vect 1.0 0.0)))

(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))

(define (flip-vert painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)    ; new origin
                     (make-vect 1.0 1.0)    ; new end of edge1
                     (make-vect 0.0 0.0)))  ; new end of edge2

(define (square-of-four tl tr bl br)
  (lambda (painter)
    (let ((top (beside (tl painter) (tr painter)))
          (bottom (beside (bl painter) (br painter))))
      (below bottom top))))

(define (square-limit painter n)
  (let ((combine4 (square-of-four identity flip-horiz
                                  flip-vert rotate180)))
    (combine4 (corner-split painter n))))

((square-limit wave-painter 4) frame)

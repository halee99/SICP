(define (unless-condition exp) (cadr exp))
(define (unless-usual exp) (caddr exp))
(define (unless-exceptional exp) (cadddr exp))

(define (unless->if exp)
  (let ((condition (unless-condition exp))
        (usual (unless-usual exp))
        (exceptional (unless-exceptional exp)))
    (make-if condition exceptional usual)))

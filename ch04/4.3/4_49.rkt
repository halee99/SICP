; http://community.schemewiki.org/?sicp-ex-4.49

(define (list-amb li)
 (if (null? li)
     (amb)
     (amb (car li) (list-amb (cdr li)))))

(define (parse-word word-list)
 (require (not (null? *unparsed*)))
 (require (memq (car *unparsed*) (cdr word-list)))
 (let ((found-word (car *unparsed*)))
   (set! *unparsed* (cdr *unparsed*))
   (list-amb (cdr word-list))))

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



; the student for the student studies for the student
; the student for the student studie for the professor
; the student for the student studie for the cat
; the student for the student studie for the class
; the student for the student studie for a student
; the student for the student studie for a professor
; the student for the student studie for a cat
; the student for the student studie for a class
; the student for the student studie to the student
; the student for the student studie to the professor

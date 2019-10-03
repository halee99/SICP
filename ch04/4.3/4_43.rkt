; http://community.schemewiki.org/?sicp-ex-4.43

(define (game-of-yacht)
 (define (all-fathers) (amb 'mr-moore 'colonel-downing 'mr-hall 'sir-barnacle-hood 'dr-parker))

 (define (all-fathers-except except-father)
   (let ((fathers (all-fathers)))
     (require (not (eq? fathers except-father)))
     fathers))

 (define (name-of-his-yacht father-name)
   (cond ((eq? father-name 'mr-moore) 'lorna)
         ((eq? father-name 'colonel-downing) 'melissa)
         ((eq? father-name 'mr-hall) 'rosalind)
         ((eq? father-name 'sir-barnacle-hood) 'gabrielle)
         ((eq? father-name 'dr-parker) 'marry))) ;; a little jumpy here

 (define lorna-father (all-fathers-except 'mr-moore))
 (define melissa-father 'sir-barnacle-hood)
 (define rosalind-father (all-fathers-except 'mr-hall))
 (define gabrielle-father (all-fathers-except 'sir-barnacle-hood))
 (define marry-father 'mr-moore)

 (define (her-father she)
   (cond ((eq? she 'lorna) lorna-father)
         ((eq? she 'melissa) melissa-father)
         ((eq? she 'rosalind) rosalind-father)
         ((eq? she 'gabrielle) gabrielle-father)
         ((eq? she 'marry) marry-father)))

 (require (distinct? (list lorna-father melissa-father rosalind-father gabrielle-father marry-father)))
 (require (eq? (her-father (name-of-his-yacht gabrielle-father)) 'dr-parker))
 (list lorna-father melissa-father rosalind-father gabrielle-father marry-father))

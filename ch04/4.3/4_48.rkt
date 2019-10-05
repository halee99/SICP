(define adjectives ('adjective good bad big small))

(define (parse-simple-noun-phrase)
  (amb (list 'simple-noun-phrase
          (parse-word articles)
          (parse-word nouns))
        (list 'simple-noun-phrase
              (parse-word adjectives)
              (parse-word articles)
              (parse-word nouns))))

(define adverbs ('adverb quickly often now always usually))

(define (parse-simple-verb)
  (amb (parse-word verbs)
       (list 'simple-verb
              (parse-word adverbs)
              (parse-word verbs))))

(define (parse-verb-phrase)
 (define (maybe-extend verb-phrase)
   (amb verb-phrase
        (maybe-extend (list 'verb-phrase
                            verb-phrase
                            (parse-prepositional-phrase))))) 
 (maybe-extend (parse-simple-verb)))

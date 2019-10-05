; the professor lectures to the student in the class with the cat

'(sentence
   (noun-phrase (articles the) (nouns professor))
   (verb-phrase (verb-phrase
                 (verb-phrase (verb lectures)
                              (pre-phrase (prep to) (noun-phrase (articles the) (nouns student))))
                 (pre-phrase (prep in) (noun-phrase (articles the) (nouns class))))
                (pre-phrase (prep with) (noun-phrase (articles the) (nouns cat)))))


'(sentence (noun-phrase (articles the) (nouns professor))
         (verb-phrase (verb-phrase (verb lectures)
                                   (pre-phrase (prep to)
                                               (noun-phrase (articles the)
                                                            (nouns student))))
                      (pre-phrase (prep in)
                                  (noun-phrase (noun-phrase (articles the) (nouns class))
                                               (pre-phrase (prep with)
                                                           (noun-phrase (articles the) (nouns cat)))))))


'(sentence (noun-phrase (articles the) (nouns professor))
         (verb-phrase (verb-phrase (verb lectures)
                                   (pre-phrase (prep to)
                                               (noun-phrase (noun-phrase (articles the) (nouns student))
                                                            (pre-phrase (prep in)
                                                                        (noun-phrase (articles the) (nouns class))))))
                      (pre-phrase (prep with) (noun-phrase (articles the) (nouns cat)))))


'(sentence (noun-phrase (articles the) (nouns professor))
         (verb-phrase (verb lectures)
                      (pre-phrase (prep to)
                                  (noun-phrase (noun-phrase (noun-phrase (articles the)
                                                                         (nouns student))
                                                            (pre-phrase (prep in)
                                                                        (noun-phrase (articles the)
                                                                                     (nouns class))))
                                               (pre-phrase (prep with) (noun-phrase (articles the) (nouns cat)))))))


'(sentence (noun-phrase (articles the) (nouns professor))
         (verb-phrase (verb lectures)
                      (pre-phrase (prep to)
                                  (noun-phrase (noun-phrase (articles the)
                                                            (nouns student))
                                               (pre-phrase (prep in)
                                                           (noun-phrase (noun-phrase (articles the)
                                                                                     (nouns class))
                                                                        (pre-phrase (prep with)
                                                                                    (noun-phrase (articles the)
                                                                                                 (nouns cat)))))))))

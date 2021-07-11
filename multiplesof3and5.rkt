#lang racket

(define (multiplesof3and5 n)
   (for/sum ([x (in-range n)]
             #:when (or (zero? (modulo x 3))
                        (zero? (modulo x 5)))
            ) x))

(multiplesof3and5 1000)

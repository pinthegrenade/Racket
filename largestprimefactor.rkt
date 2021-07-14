#lang racket

(define (largestprimefactor n)
    (define (helper i k)
      (cond [(>= i k) k]
            [(zero? (remainder k i)) (helper i (/ k i))]
            [else (helper (add1 i) k)]))
    (helper 2 n))

(largestprimefactor 600851475143)
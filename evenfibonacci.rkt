#lang racket

;; https://github.com/pjhades/sicp-solutions/blob/master/chap3/exer3.54-.scm

(define (s-map proc . streams)
  (if (stream-empty? (car streams))
      '()
      (stream-cons
       (apply proc (map stream-first streams))
       (apply s-map
              (cons proc (map stream-rest streams))))))

(define (add-streams s1 s2)
  (s-map + s1 s2))

(define fibs
   (stream-cons 1
      (stream-cons 1
         (add-streams fibs (stream-rest fibs)))))

(define (evenfibonacci n)
    (for/sum ([x (stream->list (stream-take fibs n))]
	          #:when (even? x)
			 ) x))

(evenfibonacci 33)
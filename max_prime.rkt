#lang racket    

;Primzahlsatz
(define p_guess
  (lambda(n)
    (let ((logn (log n)))
      (/ logn
         (+ (+ (+ (+ (+ (+ (+ (+ 1
                                 (/ 1 logn))
                              (/ 2 (expt logn 2)))
                           (/ 6 (expt logn 3)))
                        (/ 24 (expt logn 4)))
                     (/ 120 (expt logn 5)))
                  (/ 720 (expt logn 6)))
               (/ 5040 (expt logn 7)))
            (/ 40320 (expt logn 8)))))))

;Errate zum ersten Mal die größte Primzahl 
(define first_guess
  (lambda(n)
    (let ((p_guess1 (p_guess n)))
      (let (( p (inexact->exact (round p_guess1))))
        (- n p)))))

;Montgomery-Multiplikation
(define montgomery
  (lambda(a n mod_n)
   (let ((a1 (modulo a mod_n)))
     (let loop ((n0 n)(at_last 1)(wait_next a1))
       (if (= 0 n0)
           (modulo at_last mod_n)
           (let ((n_left (quotient n0 2)))
             (let ((n01 (modulo n0 2)))
               (cond
                 ((= 0 n01)
                  (loop n_left 
                        at_last 
                        (modulo (expt wait_next 2) mod_n)))
                 (else
                  (loop n_left 
                        (modulo (* at_last wait_next) mod_n)
                        (modulo (expt wait_next 2) mod_n)))))))))))
;Miller Rabin Test
(define mr_test
  (lambda(a mod_n)
    (let ((n (- mod_n 1)))
      (let ((n3 (- mod_n 1)))
      (cond
        ((not (= 1 (montgomery a n mod_n)))
         #f)
        (else
         (call-with-current-continuation
          (lambda(hop)
            (letrec
                ((pass?(lambda(n3)
                         (cond
                           ((even? n3)
                            (let((n3 (/ n3 2)))
                              (let((mod_t (montgomery a n3 mod_n)))
                                (cond
                                  ((= n mod_t)
                                   (hop #t))
                                  ((not(= 1 mod_t))
                                   (hop #f))
                                  (else (pass? n3))))))
                           (else
                            (let((mod_t2 (montgomery a n3 mod_n)))
                              (cond
                                ((or(= n mod_t2)
                                    (= 1 mod_t2))
                                 (hop #t))
                                (else #f))))))))
              (pass? n3 ))))))))))

;Gibt die Basis des Primalitätstests an 
(define xmr_test
  (lambda(n)
    (cond
      ((< n 341)
       (= 1  (montgomery 2 (- n 1) n)))
      (else
       (and (mr_test 2 n)
            (mr_test 3 n)
            (mr_test 5 n)
            (mr_test 7 n)
            (mr_test 11 n)
            (mr_test 13 n)
            (mr_test 17 n)
            (mr_test 19 n)
            (mr_test 23 n)
            (mr_test 29 n)
            (mr_test 31 n)
            (mr_test 37 n)
            (mr_test 41 n))))))
            
;Hoch
(define plus_test
  (lambda(n fg)
      (let loop ((n1 fg) (pt1 fg))
        (if (= n1 (- n 1))
            pt1
            (let((tp2(+ n1 1)))
              (cond
                ((xmr_test tp2)
                 (loop tp2 tp2))
                (else 
                 (loop tp2 pt1))))))))

;Runter
(define minus_test
  (lambda(f)
    (let((f2(- f 1)))
      (if(xmr_test f2)
              f2
              (minus_test f2)))))

;Hauptprogramm 
(define max_prime
  (lambda(n)
    (cond
      ((xmr_test n) n)
      (else
       (let ((fg (first_guess n)))
         (cond
           ((= fg n)
            (minus_test fg))
           (else
            (let ((pt1 (plus_test n fg)))
              (cond 
                ((not(eq? fg pt1)) pt1)
                (else
                 (cond
                   ((xmr_test fg) fg)
                   (else
                    (minus_test fg)))))))))))))

(max_prime 3317044064679887385961980)
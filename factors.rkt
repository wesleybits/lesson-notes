#lang racket
(require racket/generator
         rackunit)

;;; Here's an example of simple maths using Racket's generators. Here
;;; lies a primes generator, a funtion to detect prime numbers and a
;;; function to factor numbers.

;;; I wrote this while watching:
;;; https://www.youtube.com/watch?v=bTCl993Ikxc

;;; Naked High Guy: Is 911 prime?
;;; Chill Cop: No, it's not.

;;; Cop is wrong. 911 _is_ prime.

(define (gen-primes)
  (define (move-wires wires pos step)
    (if (hash-has-key? wires pos)
        (move-wires (hash-remove wires pos)
                    (+ pos step)
                    step)
        (hash-set wires pos step)))

  (generator ()
    (let loop ([current-prime 2]
               [wires (make-immutable-hash)])
      (cond [(= 2 current-prime)
             (yield current-prime)
             (loop 3 wires)]

            [(hash-has-key? wires current-prime)
             (loop (+ 2 current-prime)
                   (move-wires wires
                               current-prime
                               (hash-ref wires current-prime)))]

            [else
             (yield current-prime)
             (loop (+ 2 current-prime)
                   (hash-set wires
                             (* 3 current-prime)
                             (* 2 current-prime)))]))))

(define (factor n)
  (let ([give-prime (gen-primes)]
        [limit (sqrt n)])
    (let loop ([current-prime (give-prime)]
                   [n-left n])
      (cond [(= 1 n-left) '()]
            [(zero? (remainder n-left current-prime))
             (cons current-prime
                   (loop current-prime
                         (/ n-left current-prime)))]
            [else (loop (give-prime) n-left)]))))

(define (prime? n)
  (and (= 1 (length (factor n)))
       (not (= n 1))))


#lang racket
(require racket/generator)

;;; Warning: what follows is largely undocumented code rife with
;;; idioms. Take it slowly and use the documentation to see what I'm
;;; doing here.

(struct point (name x y))

(define (distance point1 point2)
  (sqrt (+ (sqr (- (point-x point1)
                   (point-x point2)))
           (sqr (- (point-y point1)
                   (point-y point2))))))

;;; O(n!)
(define (slow-tour origin destinations)
  (define (tour-length tour)
    (apply + (map distance
                  (drop-right tour 1)
                  (rest tour))))

  (define (loop-tour tour)
    (append (list origin) tour (list origin)))

  (define (shortest-tour tour1 tour2)
    (if (< (tour-length tour1)
           (tour-length tour2))
        tour1
        tour2))

  (for/fold ([minimum-tour (loop-tour destinations)])
            ([current-tour (in-permutations destinations)])
    (shortest-tour minimum-tour
                   (loop-tour current-tour))))

;;; O((2^n) * n * log2(n)) & the fastest known solution
(define (fast-tour origin destinations)
  (define points (vector (cons origin destinations)))
  (define distances
    (for/vector ([i (in-range 0 (vector-length points))])
      (for/vector ([j (in-range 0 (vector-length points))])
        (distance (vector-ref points i)
                  (vector-ref points j)))))

  (define finished-tour (sub1 (expt 2 (vector-length points))))
  (define costs
    (make-vector (length points)
                 (make-vector finished-tour +inf.0)))

  (define (in-base-2s)
    (in-generator
     (let bits ([n 1])
       (yield n)
       (bits (* n 2)))))

  (define (pick n)
    (floor (/ (log n)
              (log 2))))

  (define (picks s)
    (for/list ([k (in-base-2s)]
               #:break (> k s)
               #:when (< 0 (bitwise-and s k)))
      (pick k)))

  (define (dist i j)
    (vector-ref (vector-ref distances j) i))

  (define (cost s k)
    (vector-ref (vector-ref costs (pick k)) (sub1 s)))

  (define (set-cost! s k cost)
    (vector-set! (vector-ref costs (pick k)) (sub1 s) cost))

  (define (find-minimum-path s k)
    (for/fold ([r 1] [d +inf.0])
              ([cur-r (in-base-2s)]
               #:break (> cur-r s)
               #:when (and (not (= cur-r k))
                           (< 1 cur-r)
                           (< 0 (bitwise-and s cur-r))))
      (let ([d1 (cost (bitwise-xor s cur-r) cur-r)])
        (if (< d1 d)
            (values cur-r d1)
            (values r d)))))

  (define (set-minimum-cost! s k)
    (let ([path (picks s)])
      (if (= 1 (length path))
          (set-cost! s k (dist (pick k) (first path)))
          (let-values ([(r d) (find-minimum-path s k)])
            (set-cost! s k (+ d (dist r k)))))))

  (define (path->itinerary path)
    (map (curry vector-ref points) path))

  (define (optimum-tour-through path to-visit)
    (let-values ([(r d) (for/fold ([r 1] [d +inf.0])
                                  ([cur-r (in-base-2s)]
                                   #:break (> cur-r to-visit)
                                   #:when (and (not (member (pick cur-r) path))
                                               (< 1 cur-r)
                                               (< 0 (bitwise-and to-visit cur-r))))
                          (let ([d1 (+ (cost (bitwise-xor to-visit cur-r) cur-r)
                                       (dist (first path) (pick cur-r)))])
                            (if (< d1 d)
                                (values cur-r d1)
                                (values r d))))])
      r))

  (for ([s (in-range #b11 (add1 finished-tour) 2)])
    (for ([k (in-base-2s)]
          #:break (> k s)
          #:when (and (< 0 (bitwise-and s k))
                      (< 1 k)))
      (set-minimum-cost! (bitwise-xor s k) k)))

  (let backtrack ([path '(0)]
                  [to-visit (sub1 finished-tour)])
    (if (= 0 to-visit)
        (path->itinerary (cons 0 path))
        (let ([next-step (optimum-tour-through path to-visit)])
          (backtrack (cons (pick next-step) path)
                     (bitwise-xor to-visit next-step))))))

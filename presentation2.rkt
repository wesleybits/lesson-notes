#lang slideshow

(require pict/color
         slideshow/text
         slideshow/code
         "util/presentations.rkt")

(current-main-font 'system)

(slide #:title (title "Getting Started... Part 2"
                      "Recap of last time")
       (item "We're covering three topics"
             (small-subitem "Computer Science")
             (small-subitem "Systems Scripting")
             (small-subitem "Internet Applications"))
       (item "We're using Racket"
             (small-subitem "Easy to learn")
             (small-subitem "Kitchen sink")
             (small-subitem "You don't know it (yet)"))
       'next
       (small
        (para "We got Racket at"
              (colorize (t "http://racket-lang.org/") "Blue")
              "and found that installing and using it wasn't all that bad."
              "We also covered Racket syntax and found it very simple.")))

(slide #:title (title "Getting Started... Part 2"
                      "More recap")
       (code (+ 1 2 3))
       'next
       (code 6))

(slide #:title (title "Getting Started... Part 2"
                      "Nested Maths")
       (code (+ 2 (* 4 4)))
       'next
       (code (+ 2 16))
       'next
       (code 18))

(slide #:title (title "Getting Started... Part 2"
                      "Nested Maths")
       (code (/ (- 5 13) (* 4 4)))
       'next
       (code (/ -8 16))
       'next
       (code -1/2))

(slide #:title (title "Getting Started... Part 2"
                      "Truths")
       (code (< (- 3 2) (* 1 1)))
       'next
       (code (< 1 1))
       'next
       (code #f))

(slide #:title (title "Getting Started... Part 2"
                      "Flow Control")
       (code (if (< 1 2) 'working 'not-working))
       'next
       (code (if #t 'working 'not-working))
       'next
       (code 'working))

(slide #:title (title "Getting Started... Part 2"
                      "Flow Control")
       (code (if (< 1 2)
                 (* (+ 2 3) (/ 16 4))
                 (/ 32 2 2)))
       'next
       (code (if #t
                 (* (+ 2 3) (/ 16 4))
                 (/ 32 2 2)))
       'next
       (code (* (+ 2 3) (/ 16 4)))
       'next
       (code (* 5 4))
       'next
       (code 20))

(slide #:title (title "Getting Started... Part 2"
                      "Flow Control")
       (code (if (> 1 2)
                 (* (+ 2 3) (/ 16 4))
                 (/ 32 2 2)))
       'next
       (code (if #f
                 (* (+ 2 3) (/ 16 4))
                 (/ 32 2 2)))
       'next
       (code (/ 32 2 2))
       'next
       (code 8))

(slide #:title (title "Getting Started... Part 2"
                      "Square Roots")
       (with-size 16
         (para
          (code
           (define (close-enough? x guess err)
             (< (abs (- guess (/ x guess)))
                err)))))

       (with-size 16
         (para
          (code
           (define (next-guess x guess)
             (/ (+ guess (/ x guess))
                2)))))

       (with-size 16
         (para
          (code
           (define (newton-sqrt x guess err)
             (if (close-enough? x guess err)
                 guess
                 (newton-sqrt x
                              (next-guess x guess)
                              err)))))))

(slide #:title (title "Getting Started... Part 2"
                      "Square Roots")
       (with-size 24
         (para (code (newton-sqrt 16 1 0.001))))
       'next
       (with-size 24
         (para
          (code
           (define (newton-sqrt x guess err)
             (if (close-enough? x guess err)
                 guess
                 (newton-sqrt x
                              (next-guess x guess)
                              err))))))
       'next
       (with-size 24
         (para
          (code
           (if (close-enough? 16 1 0.001)
               1
               (newton-sqrt 16
                            (next-guess 16 1)
                            0.001))))))

(slide #:title (title "Getting Started... Part 2"
                      "Square Roots")
       (with-size 24
         (para
          (code
           (if (close-enough? 16 1 0.001)
               1
               (newton-sqrt 16
                            (next-guess 16 1)
                            0.001)))))
       'next
       (with-size 24
         (para
          (code
           (define (close-enough? x guess err)
             (< (abs (- guess (/ x guess)))
                err)))))
       'next
       (with-size 24
         (para
          (code
           (if (< (abs (- 1 (/ 16 1)))
                  0.001)
               1
               (newton-sqrt 16
                            (next-guess 16 1)
                            0.001))))))

(slide #:title (title "Getting Started... Part 2"
                      "Square Roots")
       (with-size 16
         (para
          (code
           (if (< (abs (- 1 (/ 16 1)))
                  0.001)
               1
               (newton-sqrt 16
                            (next-guess 16 1)
                            0.001)))))
       'next
       (with-size 16
         (para
          (code
           (if (< 15 0.001)
               1
               (newton-sqrt 16
                            (next-guess 16 1)
                            0.001)))))
       'next
       (with-size 16
         (para
          (code
           (if #f
               1
               (newton-sqrt 16
                            (next-guess 16 1)
                            0.001)))))
       'next
       (with-size 16
         (para
          (code
           (newton-sqrt 16
                        (next-guess 16 1)
                        0.001)))))

(slide #:title (title "Getting Started... Part 2"
                      "Square Roots")
       (with-size 24
         (para
          (code
           (newton-sqrt 16
                        (next-guess 16 1)
                        0.001))))
       'next
       (with-size 24
         (para
          (code
           (define (next-guess x guess)
             (/ (+ guess (/ x guess))
                2)))))
       'next
       (with-size 24
         (para
          (code
           (newton-sqrt 16
                        (/ (+ 1 (/ 16 1))
                           2)
                        0.001)))))

(slide #:title (title "Getting Started... Part 2"
                      "Square Roots")
       (with-size 16
         (para
          (code
           (newton-sqrt 16
                        (/ (+ 1 (/ 16 1))
                           2)
                        0.001))))
       'next
       (with-size 16
         (para
          (code
           (newton-sqrt 16
                        (/ (+ 1 16)
                           2)
                        0.001))))
       'next
       (with-size 16
         (para
          (code
           (newton-sqrt 16
                        (/ 17 2)
                        0.001))))
       'next
       (with-size 16
         (para
          (code
           (newton-sqrt 16 8.5 0.001)))))

(slide #:title (title "Getting Started... Part 2"
                      "And we just carry on like this...")
       (with-size 24
         (para
          (code
           (newton-sqrt 16 8.5 0.001))))
       'next
       (with-size 24
         (para
          (code
           (newton-sqrt 16 5.1911764705882355 0.001))))
       'next
       (with-size 24
         (para
          (code
           (newton-sqrt 16 4.136664722546242 0.001))))
       'next
       (with-size 24
         (para
          (code
           (newton-sqrt 16 4.002257524798522 0.001))))
       'next
       (with-size 24
         (para
          (code
           (newton-sqrt 16 4.000000636692939 0.001)))))

(slide #:title (title "Getting Started... Part 2"
                      "UNTIL!")
       (with-size 16
         (para
          (code
           (newton-sqrt 16 4.000000636692939 0.001))))
       'next
       (with-size 16
         (para
          (code
           (if (close-enough? 16 4.000000636692939 0.001)
               4.000000636692939
               (newton-sqrt 16
                            (next-guess 16 4.000000636692939 0.001)
                            0.001)))))
       'next
       (with-size 16
         (para
          (code
           (if #t
               4.000000636692939
               (newton-sqrt 16
                            (next-guess 16 4.000000636692939 0.001)
                            0.001)))))
       'next
       (with-size 16
         (para (code 4.000000636692939))))

(slide #:title (title "Getting Started... Part 2"
                      "So, what happened?")
       (item "Racket's evaluation model"
             (small-subitem "Most forms evaluate from the inside-out,"
                            "until all parenthesis are gone")
             (small-subitem (small (code if))
                            "and"
                            (small (code define))
                            "are exceptions")
             (small-subitem "Exceptions to Racket's evaluation model"
                            "are called \"special-forms\"")
             (small-subitem "Some special forms, like"
                            (small (code cond))
                            ", can be reduced to other forms"))
       'next
       'alts
       (list (list
              (item (code define)
                    (small-subitem "Binds a symbol to a value or procedure")
                    (small-subitem "Later we'll see that procedures are values too")))
             (list
              (item (code if)
                    (small-subitem "Always evaluates its first argument")
                    (small-subitem "Reduces to its second argument if the first evaluates"
                                   (small (code #t)))
                    (small-subitem "Reduces to its third argument if the first evaluates"
                                   (small (code #f)))))
             (list
              (item (code cond)
                    (small-subitem "Checks each condition, or guard,"
                                   "before letting it's paired conditions run")
                    (small-subitem "Can (and is) reduced to nested"
                                   (small (code if))
                                   "s")))
             (list
              (with-size 24
                (para
                 (code (cond [(test-1? x) (result-1 x)]
                             [(test-2? x) (result-2 x)]
                             [else (result-3 x)]))))
              (with-size 24
                (para
                 (code (if (test-1 x) (result-1 x)
                           (if (test-2 x) (result-2 x)
                               (result-3 x)))))))))

#lang racket

;;; In Racket, procedures are values too...

;;; Welcome to combinators explained!

;;; A normal procedure would be something like this:

(define (cube number)
  (* number number number))

;;; And it would stand in for expressions like:

(* 333 333 333)
(* 14 14 14)
(* 5678664 5678664 5678664)
;;; To save us from doing all that repetative typing.

;;; Definitions like "cube" are supposed to simplify our work. After
;;; we've established that it does what we want, we can carry on not
;;; caring about how it does its job.

;;; Now consider these procedures:

;; "sum-integers" adds all the integers between "lower" and "upper"
;; inclusively.
(define (integers-sum lower upper)
  (if (> lower upper)
      0
      (+ lower
         (sum-integers (+ lower 1)
                       upper))))

;; "sum-cubes" adds all the cubes of the intergers between "lower" and
;; "upper" inclusively.
(define (cubes-sum lower upper)
  (if (> lower upper)
      0
      (+ (cube lower)
         (cubes-sum (+ lower 1)
                    upper))))

;; Now the third one is kind of weird. It's based on an infinite
;; number series that slowly adds up to π/8. It looks like this:

;;    1         1         1
;; ------- + ------- + -------- + ...
;;  1 * 3     5 * 7     9 * 11

;; Between each term:

;;      1
;; -------------
;;  n * (n + 2)

;; n goes up by 4. This is enough to write pi-sum:
(define (pi-sum lower upper)
  (if (> lower upper)
      0
      (+ (/ 1 (* lower
                 (+ lower 2)))
         (pi-sum (+ lower 4)
                 upper))))

;;; This is great and all, but let's review integer-sum, cube-sum and
;;; pi-sum. They look similar, don't they?  If we were to make a
;;; template for them, it'll look like:

;;; (define (<procedure-name> lower upper)
;;;   (if (> lower upper)
;;;       0
;;;       (+ (<term> lower)
;;;          (<procedure-name> (<next> lower)
;;;                            upper))))

;;; Wouldn't it be nice to make a template to make these three
;;; sumation procedures simpler somehow?  Like how mathematicians made
;;; up the concept of sums:

;; Σ 1/(2^n)

;;; We can do that same thing with Racket using the template above:

(define (sum fn next)
  (define (sum-template lower upper)
    (if (> lower upper)
        0
        (+ (fn lower)
           (sum-template (next lower)
                         upper))))
  sum-template)

;;; And now we can do this using "add1", which is a function that adds
;;; 1 to a number. To make them distinct from the original exmaples,
;;; we'll swap around "sum" with what it's a sum of.

;;; For example, integers-sum turns into:
(define sum-integers
  (sum identity add1))

;;; And cubes-sum turns into:
(define sum-cubes
  (sum cube add1))

;;; Now we need "lambda", or a means to create a function in an ad-hoc
;;; way. "lambda" is handy with that, you can also use the symbol "λ"
;;; to do the same. Lambda creates a function that has no name.

;;; To use lambda:
;;; (lambda (<parameters> ...) <expressions> ...)
;;; (λ (<parameters> ...) <expressions> ...)

;;; On Mac, λ is "Command-\"
;;; On PC or Linux, λ is "Ctrl-\"
;;; If you're using Emacs or Vim, you're on your own.

;;; Oh, and pi-sum turns into:
(define sum-pi
  (sum (lambda (n)
         (/ 1 (* n (+ n 2))))
       (lambda (n)
         (+ n 4))))

;;; And these behave in the expected way:

(display
 "integers-sum is the same as sum-integers? ")
(display
 (= (integers-sum 1 100)
    (sum-integers 1 100)))
(newline)

(display
 "cubes-sum is the same as sum-cubes? ")
(display
 (= (cubes-sum 1 100)
    (sum-cubes 1 100)))
(newline)

(display
 "pi-sum is the same as sum-pi? ")
(display
 (= (pi-sum 1 100)
    (sum-pi 1 100)))
(newline)

;;; When you run this file, Racket will report that our _-sum
;;; functions work the same way as our sum-_ functions.

;;; Revisiting "define-explained.rkt", you might have seen this:

(define (integeral lower upper fn dx)
  (define (integral-iter current-x current-sum)
    (if (> current-x upper)
        current-sum
        (integral-iter
         (+ current-x dx)
         (+ current-sum
            (* (fn current-x)
               dx)))))
  (integral-iter lower 0))

;;; And using what we've learned about sums, we can do something like
;;; this:

(define (integrate fn dx)               ; <- "fn" is a function,
                                        ; "dx" is how fine we want the integral to be
  (sum (λ (n)                           ; <- return an open function that'll do a
         (+ n dx))                      ; Riemann sum when applied to an upper and lower
       (λ (x)                           ; bound.
         (* (fn x)
            dx))))

;;; Which will produce something like an indefinite integral of
;;; whatever function we give it!

;;; Why does this work? In Racket (and in Javascript and Scala and
;;; Haskell and almost every other modern programming language),
;;; procedures are values. They can be passed into other procedures as
;;; arguments, and be returned from procedures as values.  This is
;;; actually a very powerful thing, and is one of the features that
;;; make a programming langauge functional, instead of imperative
;;; (like Java, C, and Python).

;;; Procedures that take other procedures as arguments, or return
;;; procedures as values, or even both, are called "higher-order
;;; procedures".  There's a class of higher-order procedures called
;;; combinators.  A couple basic ones that Racket gives us are "curry"
;;; and "compose".

;;; "curry" works like this:
(curry + 4)    ; -> returns a function that adds 4 to a number
(curry * 16)   ; -> returns a function that multiplies a number by 16
(curry - 15)   ; -> returns a function that subtracts a number from 15

;;; curry takes a procedure and some arguments and returns a procedure
;;; that accepts the rest of the original procedure's arguments, and
;;; runs that procedure.  An example of how curry is defined (although
;;; Racket does a better job than this, so I'll use Racket's curry and
;;; you should too):

(define (my-curry proc . args)
  (lambda more-args
    (apply proc (append args more-args))))

;;; "(my-curry proc . args)" tells Racket that my-curry can accept as
;;; many arguments as it's given. The first argument gets put in the
;;; parameter "proc", and all the rest go into the parameter "args" as
;;; a list.

;;; "lambda more-args" tells Racket to create a procedure that accepts
;;; as many arguments as it's given, and to put all those values into
;;; "more-args" as a list. Notice how there are no parens around
;;; "more-args".

;;; "(append args more-args)" splices the lists "args" and "more-args"
;;; together.  "append" splices lists together, and "args" and
;;; "more-args", as previously mentioned, are lists.

;;; "(apply proc (append args more-args))" applies the procedure
;;; "proc" to the list made by splicing "args" and "more-args"
;;; together. "apply" will apply a procedure to a list of arguments by
;;; splicing the procedure to the front of the arguments list and
;;; evaluating that.

;;; If you're confused, try "(apply + '(1 2 3 4 5))" in DrRacket's
;;; interactions panel, and then try "(+ 1 2 3 4 5)"; they will come
;;; up with the same answer. This is a segway into data-processing.

;;; Using "curry", we can enhance our definition of sum-pi like this:
(define sum-pi-2
  (sum (lambda (n)
         (/ 1 (* n (+ n 2))))
       (curry + 4)))

;;; "compose" lets us compose plug two functions together like a
;;; processing pipeline that rolls from right to left. The input of
;;; one function is plugged into the output of another.  Here are some
;;; examples:

(compose - (curry + 4)) ; -> creates a function that returns the
                        ; negative of the sum between 4 and a number

(compose (curry < 0) -) ; -> creates a function that checks to see if
                        ; the negative of a number is less than zero

;;; And converting Farenheit to Celcius:
(compose (curry * 5/9)
         (curry + -32))

;;; An example of how "compose" could be defined is:

(define (my-compose . fns)
  (λ (thing)
    (foldr (λ (fn datum) (fn datum))
           thing
           fns)))

;;; Like before, "(my-compose . fns)" tells Racket that "my-compose"
;;; will accept as many arguments as it's given, and bin them all
;;; into "fns" as a list.

;;; Here, "lambda (thing)" tells Racket to make a function that
;;; accepts only one parameter. Notice how "thing" has parens around
;;; it.

;;; "(λ (fn datum) (fn datum))" tells Racket to make a function that
;;; accepts only two parameters. Notice how "fn" and "datum" are in
;;; parens. The point of this function is to apply the "fn" argument
;;; to the "datum" argument.

;;; "(foldr <folding-function> thing fns)" will be explained better
;;; next week. Suffice it to say, this expression will crunch the
;;; list of functions, "fns", into a datum, "thing", by applying the
;;; last function in "fns" to "thing" to create a new datum. then it
;;; repeats, using the new datum as "thing", and chopping off the last
;;; function in "fns". It keeps going until it runs out of stuff in
;;; "fns" to crunch.

;;; Using compose to "enhance" sum-pi (kinda makes it uglier, but oh
;;; well, this is just an example):

(define sum-pi-3
  (sum (lambda (n)
         ((compose (curry / 1)
                   (curry * n)
                   (curry + 2))
          n))
       (curry + 4)))

;;; This is a pretty trivial example, so let's show you something more
;;; interesting that uses "compose", "curry" and other higher-order
;;; procedures.

;;; Let's take a table (a list of lists of STUFF) and make a CSV.

(define table->csv
  (compose
   (λ (rows)                          ; v- see dox about "string-join"
     (string-join rows (string #\newline)))
   (curry map                         ; <- see dox about "map"
          (λ (row)
            (string-join
             (map csv-escape row)
             ",")))))

;;; Great, let's define "csv-escape" to handle strings specially.  We
;;; want strings kind of like the way Racket does strings, so that we
;;; don't limit what goes into a string, and so that commas in these
;;; things don't cause columns to end early and things go out of wack.

;;; Great thing is that all spreadsheet programs understand Racket
;;; strings just fine!

(define (csv-escape thing)
  (if (string? thing)
      ;; see dox about "fprintf", ~s stringifies things with
      ;; Racket-friendly "write"
      (~s thing)
      ;; see dox about "fprintf", ~a stringifies things with
      ;; people-friendly "display"
      (~a thing)))

;;; Now that we have our CSV ready to put into a file, let's do just that:

(define (export-csv filename table)
  ;; see dox about "with-output-to-file" and "display"
  (with-output-to-file filename #:mode 'text #:exists 'replace
    (λ ()
      (display (table->csv table)))))

;;; #:mode and #:exists are syntax we didn't cover, called keywords.
;;; They're used to us help use complicated procedures (like ones that
;;; accept between 1 and 20 parameters, and you only need to set 3).
;;; We'll not get into these too much, but I'll show you how to use
;;; them as we meet them.

;;; Next week is data processing with lists.

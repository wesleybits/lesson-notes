#lang racket

;;; It appears that we need to spend some time on definitions. No big
;;; deal, let's do that:

;;; Welcome to: Definitions Explained!

;;; When dealing with any programming system, we need the ability to
;;; define things. It helps immensely with breaking a problem down to
;;; make the seemingly difficult turn into something we can actually
;;; do. That's what most of programming is: breaking down a problem
;;; into smaller and easier problems to solve. You just gotta keep
;;; breaking it down until you actually say "This is gonna be easy".

;;; Definitions should be the first thing you master in any language.

;;; Racket has many different kinds of definitions, ranging from
;;; simple values, to all-important procedures, to data structures and
;;; syntax rules and transformations. We'll deal with each as we come
;;; to it, so no need to worry too much.  Right now, we need to worry
;;; about defining values and procedures.

;;;;;;;;;;;;;;
;;; VALUES ;;;
;;;;;;;;;;;;;;

;;; Let's look at defining values first. It's easier.
;;; (define <the-new-symbol> <the-symbols-value>)
(define my-name "Wesley Bitomski")

;;; The above binds my name "Wesley Bitomski" to the symbol "my-name",
;;; so instead of needing to type out "Wesley Bitomski" every time I
;;; want refer to my name, I can just use "my-name", because to
;;; Racket, they're the same thing now that I've defined it.

(displayln my-name)

(display my-name)
(display " isn't all that bad a guy!")
(newline)

;;; One can say, "Well, why not type out your name every time you want
;;; to mention it?" What if it should change? If my name changes to
;;; something like "Wesley Wagner", then I'll have to change every
;;; occurrence of my name to match in order to let the program continue
;;; functioning correctly. With it defined in one place, then all that
;;; is just one easy change.

;;; As a rule of thumb: if you have a constant that you use more than
;;; once for the same reason, define it as a value in case it needs
;;; to change. It also makes your code easier to understand later, for
;;; when you get back to it after you forget what's going on.

;;; It's pretty easy. Let's practice defining things.

;;;;;;;;;;;;;;;;
;;; Problems ;;;
;;;;;;;;;;;;;;;;

;;; Problem 1: Euler's number "e" isn't defined in Racket. Let's fix
;;; that. Go on to Google and look up the first 10 digits, then use
;;; that to define "e" for Racket.

;;; Problem 2: Define a string of your name for Racket. Choose a
;;; symbol of your own to name it, but name it in such a way that it's
;;; clear to a stranger what it represents.

;;; Problem 3: I'm gonna define somethings for you. Don't worry about
;;; it... yet.

;; Integrates things, takes a lower bound, and upper bound, a
;; function and a delta. It's gives a good Riemann sum that
;; approximates the integral, but takes a crazy-long time to do it.
(define (integrate lower upper fn dx)
  (define (iter current-x sum-so-far)
    (if (> current-x upper)
        sum-so-far
        (iter (+ current-x dx)
              (+ sum-so-far
                 (* (fn current-x)
                    dx)))))
  (iter lower 0))

;; Euler-Mascheroni function, useful for finding the value of
;; little-gamma.
(define (euler-mascheroni x)
  (- (/ 1 (floor x))
     (/ 1 x)))

;;; The Euler-Mascheroni constant, little-gamma, is a rather maligned
;;; little number who really tried to be liked, but pi was the ever
;;; popular mean girl and e had all those cool stories and could play
;;; guitar. All little-gamma could do was play mouth harp, breed
;;; rabbits, and blow bubbles in milk.

;;; ANYWAY. To get a reasonable approximation of this friendless
;;; number, we can evaluate the form:

;;; (integrate 1 999000000 euler-mascheroni 0.0000001)

;;; This takes an awful long time to do. Little-gamma apparently
;;; doesn't own a phone and so only responds to written correspondence
;;; on attractive stationary. Little-gamma asserts that she's quirky,
;;; but Avogadro's Number says that she's a pain in the ass.
;;; Avogadro's Number is right, so let's define a place to stick her
;;; so we don't need to write such prose every time we want to summon
;;; up little-gamma.

;;;;;;;;;;;;;;;;;;
;;; PROCEDURES ;;;
;;;;;;;;;;;;;;;;;;

;;; So, now that we defined some values, let's see how we define
;;; procedures:

;;; More abstractly:
;;; (define <the-procedures-signature> <the-procedures-body>)
;;; the-procedures-signature := (<the-procedures-name> <a-parameter> ...)
;;; the-procedures-body := <an-expression> ...

;;; More concretely:
;;; (define (<the-procedures-name> <a-parameter> ...) <expressions> ...)

;;; An example:
(define (square number)
  (* number number))

;;; The procedure's signature is "(square number)", and it's body
;;; consists only of "(* number number)". The procedure's name is
;;; "square", and "number" is it's only parameter. Notice how "number"
;;; isn't defined outside of "square", yet since it's "square"'s
;;; parameter, we can make use of it inside "square"'s body.

;;; Put this way, "square" is a perfect replacement for

;;; "(* number number)"

;;; for any "number" given to it, but all we need to remember about it
;;; is that it squares numbers for us.  When we define a procedure, as
;;; long as it keeps working correctly, we've just gotta remember what
;;; it means to us, not how it works.

;;; When using "square", we've got to keep in mind that it only has
;;; one parameter, so Racket will complain bitterly if we give it any
;;; more or less.

;;; Go ahead and use it with zero or many arguments. Be sure you know
;;; what the complaint looks like.

;;; There are some erring examples for you. Delete the ";;" when you
;;; want to see the error, and put them back when done with it.
;; (square)                 ; to few arguments
;; (square 1 2)             ; to many arguments
;; (square 1 2 3)           ; adding more arguments does not fix "too many arguments"
;; (square "seven")         ; In Rakcet, "seven" is not a number, but a string.
;; (square #\7)             ; In Racket, #\7 is not a number, but a character.
;; (square VII)             ; "VII" is a symbol that has no definition.

;;; The correct examples:
(square 4)                   ; <- Racket likes this, it gives back 16.
(square 7)                   ; <- Racket likes this too, gives back 49.

;;; Procedures will take as many arguments as they have
;;; parameters. For example:

;;; This will take two to fill its two parameters.
(define (sum x y)
  (+ x y))

;;; This will take three for its three parameters.
(define (in-order? littlest middle biggest)
  (< littlest middle biggest))

;;; Now let's practice defining functions.

;;;;;;;;;;;;;;;
;;; Problems ;;
;;;;;;;;;;;;;;;

;;; Problem 4: Cubing a number raises it to the third power. Make a
;;; "cube" function that does this.

;;; Problem 5: If a square is a 2-dimensional shape and a procedure
;;; that raises a number to the second power, and if a cube is a
;;; 3-dimensional shape and a function that raises a number to the
;;; third power, then since a tesseract is a 4-dimensional shape, it
;;; must be a function that raises a number to the fourth power.

;;; Right?

;;; -- Don't care. Make this happen! Define "tesseract"!

;;; Problem 6: Averaging two numbers is an easy thing to do; some of
;;; us can do it in our heads. It's still something that we need to
;;; educate Racket on, though.

;;; Define an averaging function that averages two numbers.

;;; Problem 7: Absolute values are a weirdly useful thing. Find a way
;;; to define the absolute value function, and do that. Don't call it
;;; "abs" since we're doing programming, not crunches.

;;; Problem 8: Absolute differences are a useful thing. If you're not
;;; sure what they are, check it out on Google.

;;; No, really. Look it up on Google.

;;; Now define a function that does that.

;;;;;;;;;;;;;;;;;
;;; AFTERWARD ;;;
;;;;;;;;;;;;;;;;;

;;; You probably noticed that you've done more problems relating to
;;; defining procedures than values. Defining values is nice and all,
;;; and useful if you want to have some constants that are easily
;;; tweakable in your code. However, defining procedures is the where
;;; you'll run into the most grief.  This grief is useful, errors in
;;; your code are normal and nobody's a perfect programmer.  It's
;;; often a frustrating task, but it's just so nice when you have
;;; something working.

;;; You probably noticed that I'm deferring you to Google rather
;;; frequently. It's not just that I'm too lazy to actually explain
;;; some of these things to you, but being eager to research things on
;;; your own will help you out immensely.  It's a skill that comes
;;; with practice.  If you're not entirely sure what you're doing,
;;; look it up.  And then play with it a some in DrRacket.

;;; You're not gonna get this unless you experiment.  Find out what
;;; works or doesn't work. If you get frustrated, let me know.

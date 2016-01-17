#lang racket

;; Kung Foo: Like a good Kung Fu class, the first part will seem pointless,
;;   but it's the most important.

;; What you want to cover (in order of popularity):
;; 1. Web Coding
;; 2. System Scripting/Automation
;; 3. Computer Science

;; What we will do (in order of our lessons):
;; 1. Computer Science (because it's important)
;;   Covering computer science first, because it's fundamental
;;   to everything else we'll be doing. We'll use a scientific language
;;   that's both simple and powerful.
;; 2. System Scripting/Automation (because it's easy)
;;   Not spending an awful lot of time on this, but we'll be glossing
;;   over Python, Perl and Ruby + a little AppleScript... and then show
;;   you how to do this with our learning language.
;; 3. Web Coding (because it's HARD)
;;   We will NEED to learn Javascript, HTML and CSS for this.
;;   Then we can forget about all that because our learning language will cover
;;   all three.

;;; We'll spend much of our time writing web code. We'll see how web
;;; pages work, out to web apps all the way out to much of the
;;; infrastructure needed. We'll also cover common ways of organizing
;;; web apps, along with their benefits and drawbacks.

;;; But let's do some science first.

;; Computer Science:
;; 1. learn a language
;; The language we'll learn will be a scientific language that's good at
;; scripting and web coding.  It should be recent, but have a rich history.
;; We'll use Racket because it's easy, powerful and a Lisp.
;;   Syntax
;;   Combination
;;     Model of computation
;;   Abstraction
;;     Procedures (generalized processing and complex behaviors)
;;     Data (data structures and processing)
;;     Code (syntax transformers, language modes, user-defined language
;;           features)

;; 2. learn how it all works (by implementing it!)
;;   How to interpret programs
;;   How to invent our own languages
;;   reach Racket Mastery

;; First bit, the texts:
;; How to Design Programs, Second Edition
;; Get it here: http://www.ccs.neu.edu/home/matthias/HtDP2e/index.html

;; It's free.  It's a very simple book that's targeted at total rote
;; beginners.  You will find it helpful if you want to do some self-study,
;; it's specifically designed for that.

;; The Structure and Interpretation of Programming Languages
;; AKA The SICP
;; AKA The Wizard Book
;; AKA The Purple Book
;; Find it here: https://mitpress.mit.edu/sicp/

;; It's a famous computer science text used in all sorts of schools to teach
;; functional programming.  Being very popular, it's considered a cornerstone
;; book on computer science as a whole.  Though it teaches Scheme, Racket is a
;; direct descendant of Scheme, so much of the SICP's code will work in Racket
;; too.  When there are differences, I'll show you the translation in our
;; sessions.  We'll use it to structure out lessons.  Though this book is held
;; in very high regard, it also targets complete beginners.

;; Next, get Racket
;; The website: https://www.racket-lang.org/

;; Click the download link, grab the version you want (typically the one Racket
;; recommends), and install it.
;; It's free.  It's got all you need.

;; We'll need to set up the language before you can use it.  That's
;; right, you have to TELL Dr. Racket that you want to use
;; Racket. This implies something interesting about Racket...

;; A7BA9EC

;; SYNTAX!
;; Racket has numbers!  ALL OF THEM!
;; positive integers
42                                      ; the meaning of life
7                                       ; the most popular favorite number
880000000000000000000000000             ; the diameter of the observable universe (in meters)
;; Racket's integers are as big as you need them to be.

;; zero
0                                       ; not positive, not negative, but I got to put it somewhere
                                        ; not that remarkable, either; everyone has it.
;; negative integers (all integers)
-20                                     ; temperature where spit freezes before it hits the ground
-38                                     ; temperature where murcury freezes
-297                                    ; freezing temperature of oxygen
-455                                    ; ambient temperature of space
-460                                    ; the absolute bottom end of temperature

;; rational numbers (fractions)
2/3                                     ; 0.666...
617/500                                 ; 1.234
500/499                                 ; 1.002004008016032064128...

;; real numbers!
3.14159265    ; pi!
2.71828182    ; Euler's number (e)!
1.61803398    ; golden ratio (phi)!

;; complex numbers!
0+1i  ; i by itself
3+0i  ; an integer, as a complex number. Racket will automatically simplify this.
1+13i ; a boring complex number

;; We've got letters
#\tab
#\H
#\e
#\l
#\l
#\o
#\space
#\W
#\o
#\r
#\l
#\d
#\newline
;;; I know, they look funny.

;; strings
"\tHello World\n"

"Strings can take up
as many lines
as
you
want,
and you don't have to do
anything special"

;; symbols! (these are defined symbols in the system)
+ - * /                                 ; plus, minus, multiply, divide in order
< > =                                   ; less than, greater than, equal in order (numbers only)
display                                 ; print something to the screen
list                                    ; makes lists
first                                   ; returns first thing in a list
rest                                    ; returns everything but the first thing in a list

;;; We have truth values
#f #false                               ; #f and #false refer to the same thing
#t #true                                ; #t and #true refer to the same thing

;; We also have lists.
'(1 2 3 4)
'(#\h #\i)
'("Hello" "World")
'(display list)

;; Lists can have more than one type of thing in them.
'(list #\1 2 "three")

;;; Lists can be nested, too.
'(1 (2 (3 4)
       (5 6))
    (7 (8 9)
       (10 11)))

;; Notice the quote (apostrophe)? When you quote something to Racket,
;; you're marking it as not being code, but data. This is an important
;; thing to keep in mind, here's why with an example.

;;; Let's try some simple math. Pop this into Dr. Racket's REPL:
'(+ 1 2 3 4)
;;; Now do that again, but without the quote. What's the difference?
;;; When the quote's not there, Racket adds the numbers. This is
;;; Racket's syntax.

;;; (<operation> <operand1> <operand2> ... <operandN>)

;;; There are very few exceptions to this rule. When there are
;;; exceptions, that operation is called a special form, and I'll let
;;; you know when we come to them. Otherwise, it's called a procedure.

;;; Operations can also be nested.
(* (+ 3 2)
   (- 50
      (* 3 3 5)))

;;; Which kind of exposes Racket's evaluation model. Let's start simple

(+ 2 3)                                 ; -> 5

(+ (+ 1 1) (+ 1 2))                     ; ->
(+ 2       3)                           ; -> 5

(* (+ 2 3) (- 50 (* 3 3 5)))            ; ->
(* (+ 2 3) (- 50 45))                   ; ->
(* 5       5)                           ; -> 25

;;; Figuring Racket expressions is as easy as moving along the list
;;; and replacing each inner expression with the result they make,
;;; repeating from the inside-out until you can't go any farther. This
;;; model works for all procedures, only special forms are the
;;; exception.

;; Some exercises to chew on while I get my act togetner:
(+ (* 3 3) (* 4 4))
;;; This gives 25.  Show how Racket comes to this result.

(* 3 3 pi)
;;; This returns 28.274333882308138 in Racket.  The symbol 'pi' isn't
;;; a number, but represents one.  When Racket sees a symbol, it
;;; automatically replaces it with that symbol's value.  Using the
;;; given result, work out what Racket's value for the symbol 'pi' is.
;;; Check your work in Racket by seeing what 'pi' evaluates to.  Are
;;; they the same?

(list 1 2 (+ 3 4))
;;; The `list` procedure takes it's operands and puts them all in a
;;; list in the order that they're given.  What will '(list 1 2 (+ 3
;;; 4))' evaluate to?  Is it any different than just typing in `'(1 2
;;; (+ 3 4))`?

;; Abstraction

;; The basic way of abstracting things is to define stuff.  Our first special
;; form is `define`; it `define`s things.
(define x 15)                           ; this associates "x" with the value 15
x                                       ; gives 15

;; Our next special form is `lambda`, or `λ` for short. It creates
;; procedures. Using it in combination with `define`, we can define
;; procedures that we can use later.
(define square-lambda
  (lambda                               ; "lambda" makes procedures
      (number)                          ; "(number)" is the lambda list, or the procedure's arguments
    (* number number)))                 ; What the procedure does

;;; A more stylish way to define procedures is to use `define`s
;;; special case:
(define (square number)
  (* number number))

;;; They're equivalent. In fact, one is transformed into the other by
;;; Racket. For now on, we'll define our procedures using the nicer,
;;; stylish syntax.

;;; Let's see how function application expands:
((lambda (a) (* a a))                   ; since lambda makes functions, this is valid
 4)
;;; ((λ (a) (* a a)) 4) ->
;;; [a = 4: (* a a)] ->
;;;         (* 4 4) ->
;;; 16

;;; Procedures with more than one parameter:
((lambda (a b) (* a b (+ a b)))
 5 10)
;;; ((λ (a b)       (* a b  (+ a b))) 5 10) ->
;;; [a = 5, b = 10: (* a b  (+ a b))] ->
;;;                 (* 5 10 (+ 5 10)) ->
;;;                 (* 5 10 15) ->
;;; 750

;; Let's see what happens when we apply a defined named function, like
;; `square`:

(square 4)
;;; (square                         4) ->
;;; ((λ (number) (* number number)) 4) ->
;;; [number = 4: (* number number)] ->
;;;              (* 4 4) ->
;;; 16

;;; Racket replaces symbols with their values when evaluating code,
;;; and a function is just another kind of value that Racket works
;;; with.  It really is not so conceptually different than something
;;; like this:

(square x)                              ; remember: we defined "x" to be 15 earlier.
;;; (square                          x) ->
;;; ((λ (number)  (* number number)) 15) ->
;;; [number = 15: (* number number)] ->
;;;               (* 15 15) ->
;;; 225

;; Let's solve the following:

; pythagorean-theorem : number number -> number
(define (pythagorean-theorem a b)
  (sqrt (+ (square a)
           (square b))))

(pythagorean-theorem 3 4)
;;; Explain what happens here, and show how it evaluates. Treat `sqrt`
;;; as a primitive function that returns the square root of a number
;;; (you don't have to expand it, just try to figure it's result or
;;; just leave it as (sqrt <n>) if you can't).  We can define our own
;;; square-root function later.  However, be sure to expand the
;;; `square` function, since we know what it does and how it's
;;; defined.

(integer? 12)
;;; `integer?` is a function in Racket that tells if a thing is a
;;; whole number. Use that and the `pythagorean-theorem` function
;;; above to write your own test function for two numbers, that when
;;; put through the Pythagorean Theorem, result in a whole number.

;;; 3 & 4 are such a pair, but is 5 & 6?  Would 9 & 16 do it? Would 5
;;; & 12?  Since this is a procedure that returns a truth value, be
;;; sure to end its name with a `?`.

'(average-two-numbers 3 5)              ; quoted so this file will still execute
;;; Define a function that averages two numbers.  You don't have to
;;; use the name given in this example, you can use one that makes you
;;; happy. Exotic names will be made fun of.

(abs (- 3 15))
;;; `abs` is a function in Racket that returns the absolute value of
;;;  the number given to it.  Use it to help determine if the absolute
;;;  difference between two numbers is less than a third number. Be
;;;  sure to observe normal lisp naming when writing this function
;;;  (you're asking a question, so end its name with a `?`).

;;; FLOW CONTROL: and you thought I was done...

;;; Let's look at the `if` special form:
;;; (if <predicate> <consequence> <alternative>)

;;; And how it evaluates:
(if (< 0 1) (* 3 3) (* 5 5))
;;; (if (< 0 1) (* 3 3) (* 5 5)) ->
;;; (if #true   (* 3 3) (* 5 5)) ->
;;;             (* 3 3) ->
;;; 9

(if (> 0 1) (* 3 3) (* 5 5))
;;; (if (> 0 1) (* 3 3) (* 5 5)) ->
;;; (if #false  (* 3 3) (* 5 5)) ->
;;;                     (* 5 5) ->
;;; 25

;;; `if` evaluates it's predicate first, and then returns what
;;; expression it should based on that result. The returned expression
;;; then proceedes normally.

;;; There's also `cond`:
;;; (cond [<predicate1> <result1>]
;;;       [<predicate2> <result2>]
;;;       ...
;;;       [<predicateN> <resultN>]
;;;       [else <alternative>]) <- this bit's optional

;;; The `cond` special form is just like `if`, but it handles more
;;; predicates. `cond` works like a pile of nested `if` expressions,
;;; so it's useful to evaluate `cond` like that.

(cond [(= 1 2) (+ 5 5)]
      [(= 2 3) (+ 6 6)]
      [else 13])
;;; (cond [(= 1 2) (+ 5 5)]    [(= 2 3) (+ 6 6)] [else 13]) ->
;;; (if    (= 1 2) (+ 5 5) (if  (= 2 3) (+ 6 6)        13)) ->
;;; (if    #false  (+ 5 5) (if  (= 2 3) (+ 6 6)        13)) ->
;;;                        (if  (= 2 3) (+ 6 6)        13) ->
;;;                        (if  #false  (+ 6 6)        13) ->
;;; 13

;;; It's useful to think of `cond` as a kind of shorthand for the
;;; usual if-else-if code structure that other languages use.

;;; Guess what?  Now you know enough to solve almost any mathematic
;;; problem. Don't believe me?

;;; STUPID RACKET TRICKS: solving square roots using nothing but what
;;; I showed you:

;;; Theory: you can solve square roots with the following procedure:
;;; x :: the number I want the square root of
;;; y :: the square root of x
;;; objective :: find a value for y such that y == x/y (within reason)

;;; start with y = some guess number (like 1)
;;; is |x/y - y| < some allowable error?
;;; if it is, y is good enough to be our square root; so return y
;;; if not, set y to (x/y + y)/2 and do over

;;; Though this doesn't cover for complex results, it'll still work
;;; provided we handle that case. I won't for this example.

(define (close-enough? x guess err)
  (< (abs (- guess (/ x guess)))
     err))

(define (next-guess x guess)
  (/ (+ guess (/ x guess))
     2))

(define (my-sqrt x guess err)
  (if (close-enough? x guess err)
      guess
      (my-sqrt x (next-guess x guess) err)))

(my-sqrt 4 1.0 0.00001) ; returns 2.00000... with some junk after that

;;; This is how it evaluates. I skip the parameter application step to
;;; help make things brief. If you don't know how application works,
;;; then see me later.

;; (my-sqrt 4 1.0 0.00001) ->

;; ((λ (x guess err)
;;    (if (close-enough? x guess err)
;;        guess
;;        (my-sqrt x (next-guess x guess) err)))
;;  4 1.0 0.00001) ->

;; (if (close-enough? 4 1.0 0.0001)
;;     1.0
;;     (my-sqrt 4 (next-guess 4 1.0) 0.00001)) ->

;; (if ((λ (x guess err)
;;        (< (abs (- guess (/ x guess)))
;;           err))
;;      4 1.0 0.00001)
;;     1.0
;;     (my-sqrt 4 (next-guess 4 1.0) 0.00001)) ->

;; (if (< (abs (- 1 (/ 4 1.0)))
;;        0.00001)
;;     1.0
;;     (my-sqrt 4 (next-guess 4 1.0) 0.00001)) ->

;; (if #false
;;     1.0
;;     (my-sqrt 4 (next-guess 4 1.0) 0.00001)) ->

;; (my-sqrt 4 (next-guess 4 1.0) 0.00001) ->

;; (my-sqrt 4
;;          ((λ (x guess)
;;             (/ (+ guess (/ x guess))
;;                2))
;;           4 1.0)
;;          0.00001) ->

;; (my-sqrt 4
;;          (/ (+ 1 (/ 4 1.0))
;;             2)
;;          0.00001) ->

;; (my-sqrt 4 2.5 0.00001) -> ... and so on, until a result is found.

;;; We can do better: Enter BLACK BOXING

;;; So, my-sqrt uses two other functions to do it's work,
;;; close-enough? and next-guess. These functions really don't make a
;;; ton of sense outside the context of finding square roots. Is there
;;; a way to hide them, so that we con't confuse anybody who uses our
;;; code?

;;; Indeed there is:

(define (my-blackboxed-sqrt x guess err)
  (define (next-guess)
    (/ (+ guess
          (/ x guess))
       2))

  (define (close-enough?)
    (< (abs (- guess
               (/ x guess)))
       err))

  (if (close-enough)
      guess
      (my-blackboxed-sqrt x (next-guess) err)))

;;; However, this does open up a new way we can do things. As you see
;;; with Racket's sqrt function, we don't need to provide it a first
;;; guess and an error margin in order to use it. This makes Racket's
;;; sqrt function easier to use than our own. We can fix that:

(define (my-abstracted-blackboxed-sqrt x)
  (define (next-guess cur-guess)
    (/ (+ cur-guess
          (/ x cur-guess))
       2))

  (define (close-enough? cur-guess err)
    (< (abs (- cur-guess
               (/ x cur-guess)))
       err))

  (define (my-sqrt-iter cur-guess err)
    (if (close-enough? cur-guess err)
        cur-guess
        (my-sqrt-iter (next-guess cur-guess) err)))

  (my-sqrt-iter 1.0 0.00001))

;;; In both of these examples, we get to see that the inner functions
;;; get to use the parameters of the outer functions.

;;; Some useful operations:

;;; (or <predicate1> <predicate2> ... <predicateN>)
;;; (and <predicate1> <predicate2> ... <predicateN>)

;;; `or` and `and` are both special forms. If anything in `and`s
;;; arguments is #f, then it returns #f, otherwise it gives back
;;; #t. `or` works like the opposite, where if anything in `or`s
;;; arguements is #t, then it returns #t, and #f otherwise.

;;; (not <predicate>)
;;; `not` is simple.  If it's argument is #f, then it returns #t,
;;; otherwise it returns #f.

;;; There are other special things about `and` and `or` that I'm not
;;; going to get into right now. Just be aware that they are used in a
;;; couple of Racket's stranger idioms, some that you will be seeing
;;; in the future.

;;; Programming Language idioms, but the way, are just like natural
;;; languge idioms (raining cats and dogs; penny for your thoughts;
;;; add insult to injury, and so on). They don't mean much outside the
;;; language that owns them, and Racket, being a youngest daughter in
;;; the oldest family of programming languages, inherited TONS of them
;;; (let ever lambda; and-guards; or-defaults; syntax transformers;
;;; anaphors; continuations; combinatorials, and the list JUST GOES
;;; ON).

;;; Next time we'll expore one such idiom that's fundamental to nearly
;;; all programming languages: combinatorials and higher-order
;;; procedures.


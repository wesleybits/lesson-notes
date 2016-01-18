#lang racket

;;; Last time we got a taste of Racket, and we saw something
;;; interesting: a function calling upon itself to repeat a
;;; process. This here lives an explanation of how that works.

;;; Linear recursion & the tail-call monster: secrets of time and
;;; space INSIDE YOUR COMPUTER!

;;; Racket performs repetition in one way: the function that's doing
;;; the iterating simply calls itself when it wants to loop back and
;;; repeat. This gives us quite a lot of flexibility and helps us
;;; simplify our code.

;;; consider the factorial:

(define (linear-factorial x)
  (if (zero? x)                         ; zero? checks if something is 0
      1
      (* x (linear-factorial (sub1 x))))) ; sub1 is shorthand for (- x 1)

;;; It'll run like this:
;;; (linear-factorial 4) ->                         [this starts the outward expansion]
;;; (* 4 (linear-factorial 3)) ->
;;; (* 4 (* 3 (linear-factorial 2))) ->
;;; (* 4 (* 3 (* 2 (linear-factorial 1)))) ->
;;; (* 4 (* 3 (* 2 (* 1 (linear-factorial 0))))) -> [outward expansion is done, now it all collapses back]
;;; (* 4 (* 3 (* 2 (* 1 1)))) ->
;;; (* 4 (* 3 (* 2 1))) ->
;;; (* 4 (* 3 2))
;;; (* 4 6) ->
;;; 24

;;; This works fine as it is. This kind of iteration is called "linear
;;; recursion". Now note that we put bigger numbers into it, it'll
;;; take up more space and might cause memory errors. You see, the
;;; stuff in that outward expansion needs to live someplace, and that
;;; backwards collapse does take time (but not much). Most of the time
;;; you can avoid doing this by having some parameter in your iterator
;;; function keep track of your results so far.

(define (tail-call-factorial x)
  (define (fact-iter cur-x result-sofar) ; blackboxing, because fact-iter makes no sense outside factorial fn
    (if (zero? cur-x)
        result-sofar
        (fact-iter (sub1 cur-x)
                   (* result-sofar cur-x))))

  (fact-iter x 1))

;;; And it's computation:
;;; (tail-call-factorial 4) ->
;;; (fact-iter 4 1) ->
;;; (fact-iter 3 4) ->
;;; (fact-iter 2 12) ->
;;; (fact-iter 1 24) ->
;;; (fact-iter 0 24) ->
;;; 24

;;; Note that there is no outward expansion. Since there's no
;;; expansion, time isn't taken to collapse it back to the
;;; result. This is called "tail-call recursion", so named because the
;;; next step in the iteration is simply passed out as the result, or
;;; in the tail-position of the function.

;;; Tail-call recursion is preferred over linear recursion because of
;;; the space and time savings you get with it.

;;; The more damning of all kinds of iteration is tree
;;; recursion. Here's an example of a tree-recursive function,
;;; computing values in the Fibbonacci Sequence:

;;; 1 1 2 3 5 8 ...
;;; F(x) := if x = 0 then 0
;;;         if x = 1 then 1
;;;         else F(x - 1) + F(x - 2)

(define (tree-fib n)
  (cond [(= n 0) 0]
        [(= n 1) 1]
        [else (+ (tree-fib (- n 1))
                 (tree-fib (- n 2)))]))

;;; when finding out the 5th Fibbonacci, our computation will look like this:
;; (tree-fib 5) ->

;; (+ (tree-fib 4)
;;    (tree-fib 3)) ->
;; [ see how one application of tree-fib branches out to 2 more? this happens every time tree-fib is applied ]

;; (+ (+ (tree-fib 3)
;;       (tree-fib 2))
;;    (+ (tree-fib 2)
;;       (tree-fib 1))) ->

;; (+ (+ (+ (tree-fib 2)
;;          (tree-fib 1))
;;       (+ (tree-fib 1)
;;          (tree-fib 0)))
;;    (+ (+ (tree-fib 1)
;;          (tree-fib 0))
;;       (+ (tree-fib 0)
;;          (tree-fib -1)))) ->
;; [ we're almost done branching out, one more expansion to go! ]

;; (+ (+ (+ (+ (tree-fib 1)
;;             (tree-fib 0))
;;          1)
;;       (+ 1
;;          0))
;;    (+ (+ 1
;;          0)
;;       1)) ->

;; (+ (+ (+ (+ 1
;;             0)
;;          1)
;;       (+ 1
;;          0))
;;    (+ (+ 1
;;          0)
;;       1))
;; [ we're done branching, now it's time to collapse because we've got to all our leaves. ]

;; (+ (+ (+ 1
;;          1)
;;       (+ 1
;;          0))
;;    (+ (+ 1
;;          0)
;;       1)) ->

;; (+ (+ 2
;;       (+ 1
;;          0))
;;    (+ (+ 1
;;          0)
;;       1)) ->

;; (+ (+ 2
;;       1)
;;    (+ (+ 1
;;          0)
;;       1)) ->

;; (+ 3
;;    (+ (+ 1
;;          0)
;;       1)) ->

;; (+ 3
;;    (+ 1
;;       1)) ->

;; (+ 3
;;    2) ->

;; 5 ->


;;; As you see, every time tree-fib was applied, it nearly always
;;; calls itself two more times! This gets gross fast. The tree
;;; doubles every time tree-fib's argument goes up by 1! Also notice
;;; that it's computing the same problem more than once. Excatly how
;;; many times do we need to figure out the 2nd fibbonacci?

;;; tree-fib is a pretty grody way to figure out fibbonaccis. Is there
;;; a way to fix this? (there is!)

;; The solution:

(define (tail-call-fib n)
  (define (fib-iter cur next counter)
    (if (= counter n) cur
        (fib-counter next
                     (+ cur next)
                     (add1 counter))))
  (fib-iter 0 1 0))

;;; How it works:
;;; (tail-call-fib 5) ->
;;; (fib-iter 0 1 0) ->
;;; (fib-iter 1 1 1) ->
;;; (fib-iter 1 2 2) ->
;;; (fib-iter 2 3 3) ->
;;; (fib-iter 3 5 4) ->
;;; (fib-iter 5 8 5) ->
;;; 5

;;; To change tree recursion into a tail-call, you basically need to
;;; flip the process over on it's head and work backwards, passing
;;; into each iteration the results from before. The methods used to
;;; do this are their own style of coding, called Dynamic
;;; Programming. Dynamic Programming can be hard to do in other, more
;;; popular imperative languages. Functional languages like Racket, in
;;; contrast, give us short-cuts like memoization. We'll cover
;;; memoization later when we get to data abstractions.

;;; Now it time for: STUPID RACKET TRICKS!

;;; Where I show you how to count change using nothing more than what
;;; I showed you!

;;; We're not just going to count coins, but the number of different
;;; ways to make up a a given amount of cents. Sounds hard, right?

;;; Well. Let's break it down.

;;; How many ways to make 0 cents? One way, no coins.

;;; How about a negative number of cents? That's impossible, zero
;;; ways to do that.

;;; What if we don't have any coins? Zero, can't make a stone bleed.

;;; One cent? One way: one penny.

;;; Two cents? One way: two pennies.

;;; Five cents? Two ways: either five pennies, or a nickle.

;;; Ten cents? Four ways: either ten pennies, a nickle and five
;;; pennies, two nickles, or a dime.

;;; See how this is going along? First we take the largest
;;; denomination we have, subtract it from our amount and ask for the
;;; number of ways to change what's left. We then can add that number
;;; to the number of ways to change our amount if we didn't that
;;; coin. We also identified some edge cases where we already know the
;;; number of ways to make change: 0 cents, negative cents and no
;;; coins.

;;; Formalized, it'll look like this:

;;; if amount = 0 then 1
;;; if amount < 0 then 0
;;; if kinds-of-coins = 0 then 0
;;; else (count-change (amount - highest-available-coin)) + (count-change amount without-the-highest-coin)

;;; In Racket:

(define (count-change amount)
  (define (cc-iter amount kinds-of-coins)
    (cond [(= amount 0)
           1]
          [(or (< amount 0)
               (= kinds-of-coins 0))
           0]
          [else
           (+ (cc-iter amount (sub1 kinds-of-coins))
              (cc-iter (- amount (first-denomination kinds-of-coins))
                       kinds-of-coins))]))

  (define (first-denomination kinds-of-coins)
    (cond [(>= n-kinds-of-coins 5) 50]
          [(= n-kinds-of-coins 4) 25]
          [(= n-kinds-of-coins 3) 10]
          [(= n-kinds-of-coins 2) 5]
          [(<= n-kinds-of-coins 1) 1]))

  (cc-iter amount 5))

;;; Though this does indeed count the number of ways you can make
;;; change with a number of cents, it's a tree recursive process. Go
;;; ahead and use it to change a dollar:

; (count-change 100) ; commented to avoid long compile-times with this file. uncomment at your own peril.

;;; Took a while, didn't it?

;;; Is there a better way of doing this? There is, but we'll need to
;;; make something of a lookup table, or some kind of way to handle a
;;; growing number of values at once. We'll revisit this later, when
;;; we have the weapons to attack it. Let's shelve it for now as an
;;; unfinished problem.

;;; Or you can do it in your own time and we can compare answers
;;; later. Delve into the Racket Guide on your own to find out any
;;; neat toys that'll help you make this faster. This is a hard
;;; problem, so I don't blame you if you don't do it.

;;; This discussion, so far, has badmouthed two ways of iteration and
;;; lauded another to be the end-all be-all of repeating yourself. I
;;; wanted to discuss efficiency, and how to figure how efficient your
;;; computer programs are. We're worried about how they grow with
;;; successively larger inputs. How much space will they occupy? How
;;; much time will they demand of you?

;;; There is a special notation to discuss such matters. It's call The
;;; Big O (not the cartoon). Big O is an estimate that says, "given an
;;; input size of N, roughly how many steps will it take for your
;;; program to finish?" It's a bit of a trick, a bit of an art, to
;;; make a good Big O estimate.

;;; Now, these days, we're not too conserned about the amount of space
;;; a program uses since our computers come with tons of it, or so
;;; they say. Nowadays computers are running more programs than ever,
;;; so all the juicy memory needs to be shared between all the
;;; services, daemons, programs, iTunes, Chromes, Firefoxes and Dr
;;; Rackets that the user may be running alongside your code. You
;;; don't want to spawn a pig, do you? Nobody but Big Bacon likes
;;; pigs, and Big Bacon smells weird.

;;; Also, time efficiency is still incredibly important. No matter how
;;; powerful computers have become, an ineffient program will still be
;;; a massive timesink. No matter what language or technology you use,
;;; a bad algorithm choice will slow your code down, and nothing short
;;; of a complete re-write of the functions you duffed on will improve
;;; things.

;;; To help you get a handle of Big O, here are some examples:

;;; tail recursive powers:

(define (power base exponent)
  (define (power-iter b e sofar)
    (if (= e 0) sofar
        (power-iter b
                    (sub1 e)
                    (* b sofar))))
  (power-iter base exponent 1))

;;; This is O(n) time and O(1) space. It never occupies more space
;;; than tracking the base, the exponent and the power computed so
;;; far. Since different inputs doesn't effect the amount of space
;;; used, then spaced used is pretty much constant. The time taken
;;; changes with the exponent's value, so say the exponent is some
;;; 'n', then the program will go through 'n' loops to compute the
;;; power. We say O(n) time to express this.

;;; tree recursive Exercise 1.11 (the Sussmann function):

(define (sussmann n)
  (if (< n 3) n
      (+ (sussmann (- n 1))
         (* 2 (sussmann (- n 2)))
         (* 3 (sussmann (- n 3))))))

;;; Looking at exercise 1.11 in the SICP, you'll be asked to write
;;; this function, then optomize it. This function, as it stands, as
;;; O(3^n) time, and takes up O(3^n) space. If you take a hard look at
;;; it, you'll see that this is not a tail-call, so memory is used for
;;; every recursion. Every application of the sussmann function
;;; creates three more calls! For every 1 n, we get 3 more sussmanns
;;; out if it, which compound with the new values that it makes. If a
;;; function is tree-recursive, then counting the number of branches
;;; it makes per iteration helps you find the base for your Big O
;;; estimate.

;;; linear recursive triangular numbers:

(define (triangular-number-sum n)
  (if (= n 0) 0
      (+ n (triangular-number-sum (- n 1)))))

;;; Now try this one yourself. Do the expansion by hand for something
;;; like n = 5, something easy. You'll notice that it'll take O(n)
;;; space. You might be tempted to say that it takes O(2n) time. Since
;;; Big O is supposed to be an estimate, you can just get rid of that
;;; coefficient and say it's O(n) time, which is perfectly valid and
;;; the preferred way of doing it.

;;; Optimizing a function is a really tricky thing to do, so it's best
;;; to hold it off until you need to do it. Like Knuth said, "The real
;;; problem is that programmers have spent far too much time worrying
;;; about efficiency in the wrong places and at the wrong times;
;;; premature optimization is the root of all evil (or at least most
;;; of it) in programming."

;;; If you're wondering who Knuth is, he's the guy who set up computer
;;; science as a serious field of study. He's basically saying that
;;; obsessing over optimization is a pretty miserable thing to
;;; do. It's much more important that your code works right. Once it's
;;; working right, then you can worry about making it work fast, but
;;; don't invest too much time on it; you'll often find yourself
;;; needing to write more code sooner than you think.

;;; Now, don't dispair too much if you can't figure out a way to make
;;; something like a tree-recursive function faster; sometimes it's
;;; not all that bad, and tree recursion can be a useful thing. Look
;;; back up at the two Fibbonacci examples. Which one is easier to
;;; understand? Which one runs faster? Later, we'll look into cheap
;;; ways of writing great code that doesn't skimp on the beauty of
;;; tree-fib.

;;; Next time we'll discuss combinatorials and higher-order
;;; procedures.

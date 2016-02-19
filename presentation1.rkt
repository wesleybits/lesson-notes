#lang slideshow
(require pict/color
         slideshow/text)

(current-main-font 'system)

(define (rect w h)
  (filled-rectangle w h #:draw-border? #f))

(define (title title-text subtitle)
  (let ([subtitle-pict (small (t subtitle))])
    (vc-append
     (t title-text)
     (vc-append
      (blank client-w 5)
      (colorize (rect client-w 5)
                (dark "CornflowerBlue"))
      (cc-superimpose
       (colorize (rect client-w (+ 20 (pict-height subtitle-pict)))
                 "CornflowerBlue")
       subtitle-pict)))))

(define (small-subitem . stuff)
  (small (apply subitem stuff)))

(slide #:title (title "Getting Started..."
                      "This is what we're gonna cover")
       (big
        (big
         (vc-append
          (tt "</>")   ; web development
          (tt "#!")    ; system scripting
          (tt "λ"))))) ; computer science

(slide #:title (title "Getting Started..."
                      "This is what we're gonna cover")
      (let* ([science (big (big (tt "λ")))]
             [web (big (big (tt "</>")))]
             [system (big (big (tt "#!")))]
             [web-text (t "Web Development")]
             [system-text (t "System Scripting")]
             [science-text (t "Computer Science")])
        (ht-append
         (vc-append web system science)
         (blank 20 10)
         (vl-append
          (blank 10 (- (pict-height web)
                       (pict-height web-text)
                       15))
          web-text
          (blank 10 (- (pict-height system)
                       (pict-height system-text)
                       10))
          system-text
          (blank 10 (- (pict-height science)
                       (pict-height science-text)))
          science-text))))

(slide #:title (title "Getting Started..."
                      "This is how we're gonna cover it")
       (item "Go over some of the science first"
             (small-subitem "Fundamental")
             (small-subitem "Helps you understand what you're doing")
             (small-subitem "Helps formalize strange ideas"))
       (item "Do some scripting when we're comfortable"
             (small-subitem "Easy")
             (small-subitem "Exceedingly useful"))
       (item "Enter the web when we're ready"
             (small-subitem "More challenging")
             (small-subitem "Constantly in flux")
             (small-subitem "Internet of things")))

(slide #:title (title "Getting Started... With Racket"
                      "wat")
       (item "Why Racket?"
             (small-subitem "A universal equalizer")
             (small-subitem "Easy to learn and teach")
             (small-subitem "Lacks the technical limitations"
                            "of other systems")
             (small-subitem "Full-spectrum and capable of anything")
             (small-subitem "Brand new, first released in 2010")
             (small-subitem "Enables non-technical people to do"
                            "impressive things"))
       (item "How to get into this Racket?"
             (small-subitem "Go to"
                            (colorize (small (t "http://racket-lang.org"))
                                      "blue")
                            "and download it from there")
             (small-subitem "Go do that now")))

(slide #:title (title "So, while you're downloading it..."
                      "Let's talk about what you're getting yourself into")
       (item "What is Racket?"
             (small-subitem "Lisp")
             (small-subitem "Scheme")
             (small-subitem "Teaching language")
             (small-subitem "Production system")
             (small-subitem "General purpose programming")
             (small-subitem "Computer linguistics research platform")
             (small-subitem "Publishing system")
             (small-subitem "Kitchen sink"))
       (item "What is PLT?"
             (small-subitem "PLT Scheme is Racket's predecessor")
             (small-subitem "The PLT Group maintains Racket and its"
                            "package manager"))
       (small
        (para
         (colorize
          (t "https://en.wikipedia.org/wiki/Racket_(programming_language)")
         "blue")
        "has more information")))

(slide #:title (title "Before we get going"
                      "This presentation was made with Racket")
       (bitmap "images/racket-logo.jpeg"))
       
#lang racket
(require pict/color
         slideshow/text
         slideshow)

(define (rect w h)
  (filled-rectangle w h #:draw-border? #f))

(define (title title-text subtitle)
  (let ([subtitle-pict (if (pict? subtitle) subtitle (small (t subtitle)))])
    (vc-append
     (if (pict? title-text) title-text (t title-text))
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

(define (on-white pic)
  (let ([w (+ 20 (pict-width pic))]
        [h (+ 20 (pict-height pic))])
    (cc-superimpose
     (colorize (rect w h) "White")
     pic)))

(provide (all-defined-out))

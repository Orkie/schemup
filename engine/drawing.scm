(define-module (engine drawing)
  #:export (draw new-surface 
            TRANSPARENT-COLOUR 
            BLACK WHITE RED GREEN BLUE))
(use-modules 	(stdlib print)
              (stdlib logging)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							((sdl ttf) #:prefix SDL:)
							((sdl mixer) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9 gnu))

(define TRANSPARENT-COLOUR 0)
(define centre)

(define (new-surface width height)
  (let ((surface (SDL:display-format (SDL:make-surface width height))))
    (SDL:surface-color-key! surface TRANSPARENT-COLOUR)
    (SDL:fill-rect surface #f TRANSPARENT-COLOUR)
    surface))

(define (draw src dest x y)
  (SDL:blit-surface src #f dest 
    (SDL:make-rect 
      (round (if (eq? x 'centre)
        (- (/ (SDL:surface:w dest) 2) (/ (SDL:surface:w src) 2))
        x))
      (round (if (eq? y 'centre)
        (- (/ (SDL:surface:h dest) 2) (/ (SDL:surface:h src) 2))
        y))
      (SDL:surface:w src) 
       (SDL:surface:h src))))

;; colour palette
(define BLACK (SDL:make-color 0 0 0))
(define WHITE (SDL:make-color 255 255 255))
(define RED (SDL:make-color 255 0 0))
(define GREEN (SDL:make-color 0 255 0))
(define BLUE (SDL:make-color 0 0 255))

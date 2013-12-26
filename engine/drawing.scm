(define-module (engine drawing)
  #:export (draw new-surface decorate rgb rgba 
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

(define (rgba r g b a)
  (logior (ash r 24) (logior (ash g 16) (logior (ash b 8) a))))
 
(define (rgb r g b)
  (rgba r g b #xFF))

(define (new-surface width height alpha?)
  (let ((surface ((if alpha? SDL:display-format-alpha SDL:display-format) (SDL:make-surface width height '(src-alpha)))))
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

(define* (decorate source-surface #:optional width height)
  (let* ((padding 6)
         (decorated-width (if (not width) (+ (SDL:surface:w source-surface) 12 padding) width))
         (decorated-height (if (not height) (+ (SDL:surface:h source-surface) 12 padding) width))
         (decorated-surface (new-surface decorated-width decorated-height #t)))
    (SDL:draw-rectangle decorated-surface 0 0 (SDL:surface:w decorated-surface) (SDL:surface:h decorated-surface) (rgba 0 0 0 240) #t)
    
    (let* ((right (- (SDL:surface:w decorated-surface) 1))
           (bottom (- (SDL:surface:h decorated-surface) 1))
           (top 0)
           (left 0)
           (inner-left 5)
           (inner-top 5)
           (inner-bottom (- bottom 5))
           (inner-right (- right 5))
           (solid-white (rgb #xFF #xFF #xFF)))
      ; draw corner squares
      (SDL:draw-rectangle decorated-surface left top inner-left inner-top solid-white #f)
      (SDL:draw-rectangle decorated-surface left inner-bottom inner-left bottom solid-white #f)
      (SDL:draw-rectangle decorated-surface inner-right top right inner-top solid-white #f)
      (SDL:draw-rectangle decorated-surface inner-right inner-bottom right bottom solid-white #f)
      ; draw thin outer lines
      (SDL:draw-line decorated-surface inner-left top inner-right top solid-white)
      (SDL:draw-line decorated-surface left inner-top left inner-bottom solid-white)
      (SDL:draw-line decorated-surface right inner-top right inner-bottom solid-white)
      (SDL:draw-line decorated-surface inner-left bottom inner-right bottom solid-white)
      ; draw thick inner lines
      (SDL:draw-rectangle decorated-surface inner-left (- inner-top 2) inner-right inner-top solid-white #t)
      (SDL:draw-rectangle decorated-surface inner-left inner-bottom inner-right (+ inner-bottom 2) solid-white #t)
      (SDL:draw-rectangle decorated-surface (- inner-left 2) inner-top inner-left inner-bottom solid-white #t)
      (SDL:draw-rectangle decorated-surface inner-right inner-top (+ inner-right 2) inner-bottom solid-white #t)
    )
    (draw source-surface decorated-surface 'centre 'centre)    
    decorated-surface))

;; colour palette
(define BLACK (SDL:make-color 0 0 0))
(define WHITE (SDL:make-color 255 255 255))
(define RED (SDL:make-color 255 0 0))
(define GREEN (SDL:make-color 0 255 0))
(define BLUE (SDL:make-color 0 0 255))

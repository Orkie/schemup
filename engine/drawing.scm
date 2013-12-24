(define-module (engine drawing)
  #:export (draw-at
            BLACK WHITE))
(use-modules 	(stdlib print)
              (stdlib logging)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							((sdl ttf) #:prefix SDL:)
							((sdl mixer) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9 gnu))

(define (draw-at src dest x y)
  (SDL:blit-surface src #f dest (SDL:make-rect x y (SDL:surface:w src) (SDL:surface:h src))))

;; colour palette
(define BLACK (SDL:make-color 0 0 0))
(define WHITE (SDL:make-color 255 255 255))

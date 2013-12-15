(define-module (game title)
  #:export (make-title-scene))
(use-modules 	(stdlib print)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9 gnu)
							(engine scene)
							(engine settings))
  
(define (title-handle-key-down key)
	(display "keydown: ") 
	(display key) 
	(display "\n")
	(case key
		;((escape) (handle-quit))
		(else #f))
	)
	
(define (title-handle-key-up key)
	(display "keyup: ") 
	(display key) 
	(display "\n")
	(case key
		;((escape) (handle-quit))
		(else #f))
	)
	
; drawing
(define (title-render settings)
	(let* ((screen (SDL:display-format (SDL:make-surface (settings-screen-width settings) (settings-screen-height settings))))
				(format (SDL:surface-get-format screen)))
		(SDL:blit-surface (SDL:load-image "resources/adansoft.png") (SDL:make-rect 0 0 320 240) screen)
	
		; copy this surface to the screen
		(SDL:blit-surface screen)
		(SDL:flip)
		)
	)
	
(define (make-title-scene) (make-scene title-render title-handle-key-up title-handle-key-down))
	

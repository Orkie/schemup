(define-module (game title)
  #:export (make-title-scene))
(use-modules 	(stdlib logging)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9 gnu)
							(engine scene)
							(engine settings))
  
(define (title-handle-key-down key)
	(case key
		;((escape) (handle-quit))
		(else do-nothing))
	)
	
(define (title-handle-key-up key)
	(case key
		;((escape) (handle-quit))
		(else do-nothing))
	)
	
; drawing
(define (title-render screen resources)
		(SDL:blit-surface (find-image resources "adansoft") (SDL:make-rect 0 0 320 240) screen)
	)
	
(define (make-title-scene) 
  (log! 'DEBUG "Making title scene")
  (make-scene 
    (make-resources 
      '(IMAGE "adansoft" "resources/adansoft.png")
      '(MUSIC "background-music" "resources/testogg.ogg")
      )
    title-render 
    title-handle-key-up 
    title-handle-key-down))
	

(define-module (game title)
  #:export (make-title-scene))
(use-modules 	(stdlib logging)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							((sdl ttf) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9 gnu)
							(engine scene)
							(engine settings)
              (engine drawing))
  
(define (title-handle-key-down key state)
	(case key
		;((escape) (handle-quit))
		(else do-nothing))
	)
	
(define (title-handle-key-up key state)
	(case key
		;((escape) (handle-quit))
		(else do-nothing))
	)
	
; drawing
(define (title-render screen resources state)
    (draw-at (find-image resources "adansoft") screen 0 0)
    (SDL:blit-surface (SDL:render-text (find-font resources "peleja16") "Hello World!" (SDL:make-color 255 0 0)) #f screen)
  )

(define (make-initial-title-state)
  #f
  )
	
(define (make-title-scene) 
  (log! 'DEBUG "Making title scene")
  (cons 
    (make-initial-title-state)
    (make-scene 
      (make-resources 
        '(IMAGE "adansoft" "resources/adansoft.png")
        '(MUSIC "background-music" "resources/testogg.ogg")
        '(FONT "peleja16" "resources/peleja-regular-1.0.otf" 16)
        )
      title-render 
      title-handle-key-up 
      title-handle-key-down)))
	

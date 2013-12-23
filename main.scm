(use-modules  (stdlib print)
              (stdlib utils)
              (stdlib logging)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							((sdl ttf) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9 gnu)
							(engine scene)
							(engine settings)
							(game game))
							
; handle quit event
(define (handle-quit)
  (SDL:ttf-quit)
	(SDL:quit)
	(quit)
	)
	
; event handler
(define (handle-event scene)
	(let ((e (SDL:make-event)))
		(if (SDL:poll-event e)
			; event happened
			(case (SDL:event:type e)
				((quit) (handle-quit))
				((key-down) (begin (log! 'DEBUG "Pressed[" (SDL:event:key:keysym:sym e) "]") ((scene-handle-key-down scene) (SDL:event:key:keysym:sym e))))
				((key-up) (begin (log! 'DEBUG "Released[" (SDL:event:key:keysym:sym e) "]") ((scene-handle-key-up scene) (SDL:event:key:keysym:sym e))))
				(else do-nothing)
				)
			; no event
			do-nothing)
			))
			
; main game loop
(define (main-loop settings scene fps-manager)
  (SDL:fps-manager-delay! fps-manager) ; perform variable delay based on given FPS
	(handle-event scene)

  (let ((screen (SDL:display-format (SDL:make-surface (settings-screen-width settings) (settings-screen-height settings)))))
	  ((scene-render scene) screen (scene-resources scene))
		; copy this surface to the screen
		(SDL:blit-surface screen)
		(SDL:flip))

  ; loop
	(main-loop settings scene fps-manager)
	)
	
; prepare sdl
(define (init logging-level width height bpp fps)
  (set-logging-level! logging-level)
  (println "Visible logging levels: " (visible-logging-levels))
  (log! 'INFO "Starting game [" width "x" height " " bpp "bpp " fps "fps]")

	; set up video
	(SDL:init 'video)
  (SDL:ttf-init)
	(SDL:set-video-mode width height bpp 'hw-surface)
	
	; jump into game
	(main-loop 
    (make-settings width height) 
    (make-game-initial-scene)
    (SDL:make-fps-manager fps))
	)

; entry point
(init 'DEBUG 320 240 16 60)

(use-modules 	(stdlib print)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9 gnu)
							(engine scene)
							(engine settings)
							(game game))
							
; handle quit event
(define (handle-quit)
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
				((key-down) ((scene-handle-key-down scene) (SDL:event:key:keysym:sym e)))
				((key-up) ((scene-handle-key-up scene) (SDL:event:key:keysym:sym e)))
				(else #f)
				)
			; no event
			#f)
			))
			
; main game loop
(define (main-loop settings scene)
	; draw to the screen
	;(render settings state)
	; update state based on events and pass new state back into the next iteration of the loop
	;(main-loop settings (update-state settings ((handle-event) state)))
	(handle-event scene)
	((scene-render scene) settings)
	(main-loop settings scene)
	)
	
; prepare sdl
(define (init width height bpp)
	; set up video
	(SDL:init 'video)
	(SDL:set-video-mode width height bpp 'hw-surface)
	
	; jump into game
	(main-loop (make-settings width height) (make-game-initial-scene))
	)

; entry point
(init 320 240 16)

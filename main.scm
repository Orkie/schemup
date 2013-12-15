(use-modules 	(stdlib print)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9 gnu)
							(engine scene))
							
; game state
(define-immutable-record-type <settings>
	(make-settings screen-width screen-height)
	settings?
	(screen-width		settings-screen-width)
	(screen-height	settings-screen-height))
	
(define (do-nothing state) state)
	
; handle quit event
(define (handle-quit)
	(SDL:quit)
	(quit)
	)
	
(define (handle-keydown key)
	(display "keydown: ") 
	(display key) 
	(display "\n")
	(case key
		((escape) (handle-quit))
		(else do-nothing))
	)
	
(define (handle-keyup key)
	(display "keyup: ") 
	(display key) 
	(display "\n")
	(case key
		((escape) (handle-quit))
		(else do-nothing))
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
				(else do-nothing)
				)
			; no event
			do-nothing)
			))
			
; drawing
(define (render settings)
	(let* ((screen (SDL:display-format (SDL:make-surface (settings-screen-width settings) (settings-screen-height settings))))
				(format (SDL:surface-get-format screen)))
		(SDL:blit-surface (SDL:load-image "resources/adansoft.png") (SDL:make-rect 0 0 320 240) screen)
	
		; copy this surface to the screen
		(SDL:blit-surface screen)
		(SDL:flip)
		)
	)
	
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
	(main-loop (make-settings width height) (make-scene render handle-keyup handle-keydown))
	)

; entry point
(init 320 240 16)

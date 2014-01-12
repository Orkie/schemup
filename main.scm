(use-modules  (stdlib print)
              (stdlib utils)
              (stdlib logging)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							((sdl ttf) #:prefix SDL:)
							((sdl mixer) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9 gnu)
							(engine scene)
							(engine settings)
              (engine drawing)
							(game game))
							
; event handler
(define (handle-event scene state)
	(let ((e (SDL:make-event)))
		(if (SDL:poll-event e)
			; event happened
			(case (SDL:event:type e)
				((quit) (handle-quit))
				((key-down) (begin (log! 'DEBUG "Pressed[" (SDL:event:key:keysym:sym e) "]") ((scene-handle-key-down scene) (SDL:event:key:keysym:sym e) state)))
				((key-up) (begin (log! 'DEBUG "Released[" (SDL:event:key:keysym:sym e) "]") ((scene-handle-key-up scene) (SDL:event:key:keysym:sym e) state)))
				(else do-nothing)
				)
			; no event
			do-nothing)
			))

;; calculate actual frame rate
(define average-time-per-frame 0)
(define last-time 0)
(define (recalculate-fps)
  (let* ((current-time (SDL:get-ticks))
         (time-taken (- current-time last-time)))
    (set! last-time current-time)
    (set! average-time-per-frame (+ (* average-time-per-frame 0.975) (* time-taken 0.025)))
  )
  (round (/ 1000 average-time-per-frame)))
			
; main game loop
(define (main-loop settings scene fps-manager master-resources state)
  (SDL:fps-manager-delay! fps-manager) ; perform variable delay based on given FPS
	(handle-event scene state)

  (let* ((screen (SDL:get-video-surface))
         (update-state-scene ((scene-update scene) (scene-resources scene) state))
         (next-state-scene (if (not update-state-scene) (cons state scene) update-state-scene)))
    (SDL:fill-rect screen #f (SDL:map-rgb (SDL:surface-get-format screen) BLACK))
	  ((scene-render scene) screen (scene-resources scene) state)
		; copy this surface to the screen
		(SDL:blit-surface screen)
    ; render fps
    (if (settings-show-fps settings)
      (SDL:blit-surface (SDL:render-text (find-font master-resources "fifteen16") (number->string (recalculate-fps)) WHITE BLACK)))
    ; flip
		(SDL:flip)
    ; loop
	  (main-loop settings (cdr next-state-scene) fps-manager master-resources (car next-state-scene)))
	)
	
; prepare sdl
(define (init logging-level width height bpp fps show-fps)
  (set-logging-level! logging-level)
  (println "Visible logging levels: " (visible-logging-levels))
  (log! 'INFO "Starting game [" width "x" height " " bpp "bpp " fps "fps]")

	; set up video
	(SDL:init 'video)
  (SDL:ttf-init)
  (SDL:open-audio)
	(SDL:set-video-mode width height bpp '(hw-surface doublebuf src-alpha))
  (SDL:set-caption game-name)

  (set! TRANSPARENT-COLOUR (SDL:map-rgb (SDL:surface-get-format (SDL:get-video-surface)) 255 0 255))

  ; prepare FPS-calculation variables so it's correct from the start
  (set! last-time (SDL:get-ticks))
  (set! average-time-per-frame (/ 1000 fps))

	; jump into game
  (let ((initial-game-scene (make-game-initial-scene))
        (master-resources 
          (make-resources
            '(FONT "fifteen16" "resources/FifteenNarrow.ttf" 16))))
	  (main-loop 
      (make-settings width height show-fps) 
      (cdr initial-game-scene)
      (SDL:make-fps-manager fps)
      master-resources
      (car initial-game-scene))))

; entry point
(init 'DEBUG 320 240 32 60 #t)

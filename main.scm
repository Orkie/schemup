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
							(game game))
							
; handle quit event
(define (handle-quit)
  (SDL:close-audio)
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
(define (main-loop settings scene fps-manager master-resources)
  (SDL:fps-manager-delay! fps-manager) ; perform variable delay based on given FPS
	(handle-event scene)

;  (let ((screen (SDL:display-format (SDL:make-surface (settings-screen-width settings) (settings-screen-height settings)))))
  (let ((screen (SDL:get-video-surface)))
	  ((scene-render scene) screen (scene-resources scene))
		; copy this surface to the screen
		(SDL:blit-surface screen)
    ; render fps
    (if (settings-show-fps settings)
      (SDL:blit-surface (SDL:render-text (find-font master-resources "fifteen16") (number->string (recalculate-fps)) (SDL:make-color 255 255 255) (SDL:make-color 0 0 0))))
    ; flip
		(SDL:flip))

  ; loop
	(main-loop settings scene fps-manager master-resources)
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
	(SDL:set-video-mode width height bpp '(hw-surface doublebuf))
  (SDL:set-caption game-name)

  ; prepare FPS-calculation variables so it's correct from the start
  (set! last-time (SDL:get-ticks))
  (set! average-time-per-frame (/ 1000 fps))

	; jump into game
  (let ((master-resources 
          (make-resources
            '(FONT "fifteen16" "resources/FifteenNarrow.ttf" 16))))
	  (main-loop 
      (make-settings width height show-fps) 
      (make-game-initial-scene)
      (SDL:make-fps-manager fps)
      master-resources)))

; entry point
(init 'DEBUG 320 240 16 60 #t)

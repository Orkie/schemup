(define-module (game title)
  #:export (make-title-scene))
(use-modules  (stdlib logging)
              ((sdl sdl) #:prefix SDL:)
              ((sdl gfx) #:prefix SDL:)
              ((sdl ttf) #:prefix SDL:)
              (srfi srfi-1)
              (srfi srfi-2)
              (srfi srfi-9 gnu)
              (engine scene)
              (engine settings)
              (engine drawing)
              (engine menu))
  
(define (title-handle-key-down key state)
	(case key
    ((up) (menu-up state))
    ((down) (menu-down state))
    ((space) (menu-select state '(1 2)))
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
    (draw (find-image resources "adansoft") screen 0 0)
    (draw (decorate (menu-render state) 260) screen 'centre 'centre)
  )

(define (title-update resources state) 
  #f)

(define (make-initial-title-state resources)
  (key-repeat-on)
  (log! 'DEBUG "proc? " (procedure? do-nothing) (apply do-nothing '(1 2)))
  (menu-define 
    (SDL:render-text (find-font resources "peleja16") ">" WHITE)
      (find-font resources "peleja16") WHITE RED 
    `(("Play" ,(lambda (x y) (display "yo\n")))
      ("Settings" ,do-nothing)
      ("Exit" ,handle-quit)))
  )
	
(define (make-title-scene) 
  (log! 'DEBUG "Making title scene")
  (let ((resources 
          (make-resources 
            '(IMAGE "adansoft" "resources/adansoft.png")
            '(MUSIC "background-music" "resources/testogg.ogg")
            '(FONT "peleja16" "resources/peleja-regular-1.0.otf" 16)
            )))
    (cons 
      (make-initial-title-state resources)
      (make-scene 
        resources
        title-render 
        title-handle-key-up 
        title-handle-key-down
        title-update))))
	

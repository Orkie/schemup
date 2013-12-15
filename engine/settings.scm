(define-module (engine settings)
  #:export (make-settings settings-screen-width settings-screen-height))
(use-modules 	(stdlib print)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9 gnu))

(define-immutable-record-type <settings>
	(make-settings screen-width screen-height)
	settings?
	(screen-width		settings-screen-width)
	(screen-height	settings-screen-height))

(define-module (engine scene)
  #:export (make-scene scene-render scene-handle-key-up scene-handle-key-down))
(use-modules 	(stdlib print)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9 gnu))

(define-immutable-record-type <scene>
	(make-scene render handle-key-up handle-key-down)
	scene?
	(render						scene-render)
	(handle-key-up		scene-handle-key-up)
	(handle-key-down	scene-handle-key-down))

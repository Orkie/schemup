(define-module (game game)
  #:export (make-game-initial-scene game-name))
(use-modules 	(stdlib print)
							(game title))

(define game-name "Schemup")
							
;; create the initial scene for the game
(define (make-game-initial-scene) 
	(make-title-scene))

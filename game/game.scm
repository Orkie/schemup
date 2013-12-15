(define-module (game game)
  #:export (make-game-initial-scene))
(use-modules 	(stdlib print)
							(game title))
							
;; create the initial scene for the game
(define (make-game-initial-scene) 
	(make-title-scene))

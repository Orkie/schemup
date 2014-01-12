(define-module (engine menu)
  #:export (menu-define menu-render menu-up menu-down menu-select))
(use-modules 	(stdlib logging)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							((sdl ttf) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9)
							(engine scene)
							(engine settings)
              (engine drawing))

(define unhighlighted-image first)
(define highlighted-image second)
(define action third)

;; entries
;;   '((unhighlightedImageSurface highlightedImageSurface actionFunction))
(define-record-type <menu>
	(make-menu entry-width entry-height entries highlighted)
	menu?
  (cursor                   menu-cursor)
  (entry-width              menu-entry-width)
  (entry-height             menu-entry-height)
  (entries                  menu-entries)
	(highlighted			        menu-highlighted  set-menu-highlighted!))

(define (menu-up menu)
  (if (not (= (menu-highlighted menu) 1))
    (set-menu-highlighted! menu (- (menu-highlighted menu) 1))
    ))

(define (menu-down menu)
  (if (not (= (menu-highlighted menu) (length (menu-entries menu))))
    (set-menu-highlighted! menu (+ (menu-highlighted menu) 1))
    ))
    
(define (menu-select menu parameters)
    (let loop ((current-index 1)
             (current-entry (car (menu-entries menu)))
             (rest-entries (cdr (menu-entries menu))))
      (if (= current-index (menu-highlighted menu))
        (apply (action current-entry) parameters)
        (loop (+ 1 current-index) (car rest-entries) (cdr rest-entries)))))

;; entry-definitions
;;   '(("Text" action-func) ("Entry 2 text" action-2-func))
(define (menu-define cursor font text-colour text-highlighted-colour entry-definitions)
  (let loop ((built-entries '())
        (current-entry-definition (car entry-definitions))
        (rest-entry-definitions (cdr entry-definitions)))
      (let ((transformed-entry (build-entry (car current-entry-definition) (car (cdr current-entry-definition)) font text-colour text-highlighted-colour)))
        (if (null? rest-entry-definitions)
          ; do something useful
          (construct-menu cursor (cons transformed-entry built-entries))
          ; otherwise, carry on
          (loop (cons transformed-entry built-entries) (car rest-entry-definitions) (cdr rest-entry-definitions))
        ))))

(define (build-entry entry-text entry-action font colour highlighted-colour)
  `(,(SDL:display-format (SDL:render-text font entry-text colour))
    ,(SDL:display-format (SDL:render-text font entry-text highlighted-colour))
    ,entry-action
    ))

(define (construct-menu cursor entries)
  (log! 'DEBUG "Constructing menu") ;; TODO - better debug logging
  (make-menu (menu-entry-max-width entries) (menu-entry-max-height entries) (reverse entries) 1))

(define (menu-entry-max-width entries)
  (apply max (map (lambda (entry) (SDL:surface:w (unhighlighted-image entry))) entries)))

(define (menu-entry-max-height entries)
  (apply max (map (lambda (entry) (SDL:surface:h (unhighlighted-image entry))) entries)))

;; TODO - alignment? selected cursor?
(define (menu-render menu)
  (let loop ((surface (new-surface (menu-entry-width menu) (* (menu-entry-height menu) (length (menu-entries menu))) #f))
             (current-y 0)
             (current-index 1)
             (current-entry (car (menu-entries menu)))
             (rest-entries (cdr (menu-entries menu))))
    (render-entry! current-entry surface current-y (= current-index (menu-highlighted menu)))
    (if (null? rest-entries)
      surface
      (loop surface (+ current-y (menu-entry-height menu)) (+ 1 current-index) (car rest-entries) (cdr rest-entries))
        )))

(define (render-entry! entry surface y is-highlighted) 
  (draw (if is-highlighted (highlighted-image entry) (unhighlighted-image entry)) surface 'centre y))

(define (menu-highlighted-action menu)
  #f)


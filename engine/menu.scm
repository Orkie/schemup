(define-module (engine menu)
  #:export (menu-define menu-render menu-up menu-down))
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

;; entry-definitions
;;   '(("Text" action-func) ("Entry 2 text" action-2-func))
(define (menu-define cursor font text-colour text-highlighted-colour entry-definitions)
  (let loop ((built-entries '())
        (current-entry-definition (car entry-definitions))
        (rest-entry-definitions (cdr entry-definitions)))
      (let ((transformed-entry (build-entry (car current-entry-definition) (cdr current-entry-definition) font text-colour text-highlighted-colour)))
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
  (apply max (map (lambda (entry) (SDL:surface:w (first entry))) entries)))

(define (menu-entry-max-height entries)
  (apply max (map (lambda (entry) (SDL:surface:h (first entry))) entries)))

;; TODO - decoration? alignment? selected cursor?
(define (menu-render menu)
  (let loop ((surface (new-surface (menu-entry-width menu) (* (menu-entry-height menu) (length (menu-entries menu)))))
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
  (draw (if is-highlighted (second entry) (first entry)) surface 'centre y)
  )

(define (menu-highlighted-action menu)
  #f)


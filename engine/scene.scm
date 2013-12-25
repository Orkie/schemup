(define-module (engine scene)
  #:export (make-scene scene-resources scene-render scene-handle-key-up scene-handle-key-down scene-update 
            do-nothing 
            make-resources find-image find-font find-music find-sound))
(use-modules 	(stdlib print)
              (stdlib logging)
							((sdl sdl) #:prefix SDL:)
							((sdl gfx) #:prefix SDL:)
							((sdl ttf) #:prefix SDL:)
							((sdl mixer) #:prefix SDL:)
							(srfi srfi-1)
							(srfi srfi-2)
							(srfi srfi-9 gnu))

(define-immutable-record-type <scene>
	(make-scene resources render handle-key-up handle-key-down update)
	scene?
  (resources        scene-resources)
	(render						scene-render)
	(handle-key-up		scene-handle-key-up)
	(handle-key-down	scene-handle-key-down)
  (update           scene-update))

(define (do-nothing scene state) `(,scene ,state))

;; resource loading/definition
(define IMAGE)
(define FONT)
(define MUSIC)
(define SOUND)

(define (build-resource-key resource-entry)
  `(,(car resource-entry) . ,(cadr resource-entry)))

(define (build-resource-value resource-entry)
  (let ((type (car resource-entry))
        (filename (caddr resource-entry)))
      (log! 'DEBUG "Loading resource [" type ", " filename"]")
      (case type
        ((IMAGE) (load-image filename))
        ((FONT) (load-font filename (cadddr resource-entry)))
        ((MUSIC) (load-music filename))
        ((SOUND) (load-music filename))
        (else (begin (log! 'ERROR "Could not handle type " type) #f))
        )))

(define (make-resources . res)
  (let loop ((resmap (make-hash-table))
             (this (car res))
             (rest (cdr res)))
    (hash-set! resmap (build-resource-key this) (build-resource-value this))
    (if (null? rest)
      resmap
      (loop resmap (car rest) (cdr rest)))
  ))
(define (get-resource resources type name) (hash-ref resources `(,type . ,name)))

;; image-related functions
(define (find-image resources name) (get-resource resources 'IMAGE name))
(define (load-image filename)
  (let ((image-surface (SDL:load-image filename)))
    (if (not image-surface)
      (log! 'ERROR "Could not load image " filename)
      (SDL:display-format image-surface))))

;; font-related functions
(define (find-font resources name) (get-resource resources 'FONT name))
(define (load-font filename ptsize) 
  (let ((font (SDL:load-font filename ptsize)))
    (if (not font)
      (log! 'ERROR "Could not load font" filename " at " ptsize "pt")
      font)))

;; music-related functions
(define (find-music resources name) (get-resource resources 'MUSIC name))
(define (load-music filename) 
  (let ((music (SDL:load-music filename)))
    (if (not music)
      (log! 'ERROR "Could not load music " filename)
      music)))

;; sound-related functions
(define (find-sound resources name) (get-resource resources 'SOUND name))
(define (load-sound filename) 
  (let ((sound (SDL:load-wave filename)))
    (if (not sound)
      (log! 'ERROR "Could not load sound " filename)
      sound)))


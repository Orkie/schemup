(define-module (stdlib logging)
  #:export (set-logging-level! visible-logging-levels log! TRACE DEBUG INFO WARN ERROR))
(use-modules 	(stdlib print)
							(srfi srfi-1)
							(srfi srfi-2))

(define TRACE)
(define DEBUG)
(define INFO)
(define WARN)
(define ERROR)

; lower priority levels further to the right
(define all-logging-levels '(TRACE DEBUG INFO WARN ERROR))

(define logging-level (member 'INFO all-logging-levels))

(define (visible-logging-levels) logging-level)

(define (set-logging-level! level)
  (set! logging-level (member level all-logging-levels)))

; this is how a user should call the logging library, it automatically 
; rewrites itself in such a way that the current source details are included
(define-syntax log! 
  (syntax-rules ()
    ((log! level body ...) (logging-log! (current-source-location) level body ...))))

; not exposed to the user, the actual function which gets called to do some 
; logging
(define (logging-log! source-properties level . args)
  (let ((line (cdar source-properties))
        (column (cdadr source-properties))
        (filename (basename (cdaddr source-properties))))
    (if (not (member level logging-level)) 
      #f 
      (apply println `(,(symbol->string level) " (" ,filename ":" ,line ") [" ,(strftime "%T" (localtime (current-time))) "]" ": " ,@args)))
  ))


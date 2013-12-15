(define-module (stdlib print)
  #:export (print println))
	
(define (print . args)
  (let loop ((first (car args))
             (rest (cdr args)))
    (display first)         
    (if (not (null? rest)) (loop (car rest) (cdr rest)))))
    
(define (println . args)
  (apply print args)
  (newline))

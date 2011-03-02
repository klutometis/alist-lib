(module
 alist-lib
 *
 (import scheme
         chicken)
 (use srfi-1 debug matchable)

 (define (alist-values alist)
   (map cdr alist))
 
 (define (alist-keys alist)
   (map car alist))
 
 ;; this applies to multiple alists, of course; but the result for one
 ;; alist is anti-intuitive. switching to the simpler one (vide infra)
 ;; for now.
 #;
 (define (alist-map f . alists)
   (apply map (cons (lambda key-values (f (alist-keys key-values)
                                          (alist-values key-values)))
                    alists)))

 (define (alist-map f alist)
   (map (match-lambda ((key . values) (f key values))) alist))

 (define (alist-prepend! alist key value)
   (let ((cell (cons key value)))
     (if (null? alist)
         (list cell)
         (begin
           ;; thanks, Stefan Ljungstrand; for the destructive prepense
           ;; sans LIST-COPY
           (set-cdr! alist (cons (car alist) (cdr alist)))
           (set-car! alist cell)))))
 
 (define alist-set! alist-prepend!)
 
 (define alist-update!
   (case-lambda
    ((alist key function)
     (alist-update! alist
                    key
                    function
                    (lambda ()
                      (error "Key not found -- ALIST-UPDATE!" key))))
    ((alist key function thunk)
     (alist-update! alist
                    key
                    function
                    thunk
                    eqv?))
    ((alist key function thunk =)
     (let ((pair (assoc key alist =)))
       (if pair
           (set-cdr! pair (function (cdr pair)))
           (alist-set! alist key (function (thunk))))))))
 
 (define alist-update!/default
   (case-lambda
    ((alist key function default)
     (alist-update!/default alist key function default eqv?))
    ((alist key function default =)
     (alist-update! alist key function (lambda () default)))))

 (define alist-ref
   (case-lambda
    ((alist key)
     (alist-ref alist key (lambda ()
                            (error "Key not found -- ALIST-REF" key))))
    ((alist key thunk)
     (alist-ref alist key thunk eqv?))
    ((alist key thunk =)
     (let ((value (assoc key alist =)))
       (or (and value (cdr value))
           (thunk))))))
 
 (define alist-ref/default
   (case-lambda
    ((alist key default)
     (alist-ref alist key (lambda () default)))
    ((alist key default =)
     (alist-ref alist key (lambda () default) =))))

 #;(define alist-copy list-copy)

 (define alist-size length)

 (define (alist-set alist key value)
   (alist-cons key value alist)))

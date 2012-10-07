(define (alist-values alist)
  @("Extract the associations from an alist."
    (alist "The alist from which to extract")
    (@to "list"))
  (map cdr alist))

(define (alist-keys alist)
  @("Extract the keys from an alist."
    (alist "The alist from which to extract")
    (@to "list"))
  (map car alist))

;; this applies to multiple alists, of course; but the result for one
;; alist is anti-intuitive. switching to the simpler one (vide infra)
;; for now.
;; (define (alist-map f . alists)
;;   (apply map (cons (lambda key-values (f (alist-keys key-values)
;;                                     (alist-values key-values)))
;;                    alists)))

(define (alist-map f alist)
  @("Map across an alist; {{f}} takes two parameters: {{key}} and {{values}}."
    (f "The function to apply to each key-value association")
    (alist "The alist to apply to")
    (@to "list"))
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

(define alist-set!
  @("Destructively set a key-value association."
    (alist "The alist in which to set")
    (key "The key to set")
    (value "The value to associate with the key"))
  alist-prepend!)

(define alist-update!
  @("On analogy with hash-table-update!, descructively update an
association."
    (alist "The alist to update")
    (key "The key associated with the update")
    (f "A monadic function taking the preëxisting key")
    (thunk "The thunk to apply if no association exists")
    (= "The equality predicate for keys"))
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
  @("On analogy with hash-table-update!, descructively update an
association."
    (alist "The alist to update")
    (key "The key associated with the update")
    (f "A monadic function taking the preëxisting key")
    (default "The default value if no association exists")
    (= "The equality predicate for keys"))
  (case-lambda
   ((alist key function default)
    (alist-update!/default alist key function default eqv?))
   ((alist key function default =)
    (alist-update! alist key function (lambda () default)))))

;; Should we have a no-value module?
(define no-value (cons #f #f))

(define (no-value? value) (eq? value no-value))

(define alist-ref
  @("Return a value associated with its key or apply {{thunk}}."
    (alist "The alist to search in")
    (key "The key whose value to return")
    (thunk "The thunk to apply when association doesn't exist (default
is to err)")
    (= "The equality predicate to apply to keys")
    (@to "object"))
  (case-lambda
   ((alist key)
    (alist-ref alist key (lambda ()
                           (error "Key not found -- ALIST-REF" key))))
   ((alist key thunk)
    (alist-ref alist key thunk eqv?))
   ((alist key thunk =)
    (let ((value (assoc key alist =)))
      (if value
          (cdr value)
          (thunk))))))

(define alist-ref/default
  @("Return a value associated with its key or {{default}}."
    (alist "The alist to search in")
    (key "The key whose value to return")
    (default "The default to return when association doesn't exist")
    (= "The equality predicate to apply to keys")
    (@to "object"))
  (case-lambda
   ((alist key default)
    (alist-ref alist key (lambda () default)))
   ((alist key default =)
    (alist-ref alist key (lambda () default) =))))

#;(define alist-copy list-copy)

(define alist-size
  @("Calculate size of alist."
    (alist "The alist whose size to calculate")
    (@to "integer"))
  length)

(define (alist-fold alist f init)
  @("Fold an alist; whose {{f}} takes key, accumulatum, value."
    (alist "The alist to fold")
    (f "The function to apply to key, accumulatum, value")
    (init "The seed of the fold")
    (@to "object"))
  (fold (lambda (association accumulatum)
          (match association
            ((key . value)
             (f key accumulatum value))))
        init
        alist))

(define (alist-set alist key value)
  @("Non-destructively associate a key and value in the alist."
    (alist "Alist in which to set")
    (key "The key to set")
    (value "The value to associate with key")
    (@to "alist"))
  (alist-cons key value alist))

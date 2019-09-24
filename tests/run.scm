(cond-expand
  (chicken-4 (use alist-lib test))
  (chicken-5 (import alist-lib test)))

(test
 14
 (alist-fold
  '((1 2 3) (3 4 5))
  (lambda (key value accumulatum)
    (+ (apply + value) accumulatum))
  0))

(test '((1 2 3) (4 5 6))
      (alist-map (lambda (key value) (cons key value))
                 '((1 2 3)
                   (4 5 6))))

#;
(test
 "alist-map with three alists"
 '(((a e i) (b f j)) ((c g k) (d h l)))
 (alist-map (lambda (keys data) (list keys data))
            '((a . b) (c . d))
            '((e . f) (g . h))
            '((i . j) (k . l))))

(let ((alist '((a . 1) (b . 2))))
  (test-error
   "alist-update! on non-extant key with no thunk"
   (alist-update! alist 'c (lambda (datum) 1)))
  (test
   "alist-update! on non-extant key with thunk"
   (begin
     (alist-update! alist 'c (lambda (datum) 1) (lambda () 1))
     alist)
   '((c . 1) (a . 1) (b . 2)))
  (test
   "alist-update! on extant key"
   '((c . 1) (a . 2) (b . 2))
   (begin
     (alist-update! alist 'a (lambda (datum) (+ datum 1)))
     alist))
  (test
   "alist-update! on extant key with thunk and ="
   '((c . 1) (a . 2) (b . 3))
   (begin
     (alist-update! alist
                    'b
                    (lambda (datum) (+ datum 1))
                    (lambda () 3) eqv?)
     alist))
  (test
   "alist-update!/default on non-extant key"
   '((d . 2) (c . 1) (a . 2) (b . 3))
   (begin
     (alist-update!/default alist 'd (lambda (datum) (+ datum 1)) 1)
     alist))
  (test
   "alist-update!/default on extant key with ="
   '((d . 3) (c . 1) (a . 2) (b . 3))
   (begin
     (alist-update!/default alist 'd (lambda (datum) (+ datum 1)) 1 eqv?)
     alist)))

(let ((alist '((1 . 2) (3 . 4) (5 . 6))))
  (alist-set! alist 7 8)
  (test
   "alist-set!"
   alist
   '((7 . 8) (1 . 2) (3 . 4) (5 . 6))))

(let ((alist '()))
  (alist-set! alist 1 2)
  (test
   "alist-set! on empty list"
   alist
   '((1 . 2))))

(test
 "Test that #f-values are reported."
 #f
 (alist-ref '((a . #f)) 'a))

(test-exit)

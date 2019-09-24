(module
 alist-lib
 (alist-values
  alist-keys
  alist-map
  alist-set!
  alist-prepend!
  alist-update!
  alist-update!/default
  alist-ref
  alist-ref/default
  alist-size
  alist-fold
  alist-set)
 (import scheme)
 (cond-expand
   (chicken-4
    (import chicken)
    (use matchable srfi-1))
   (chicken-5
    (import
      (except chicken.base alist-ref alist-update!)
      matchable srfi-1)))
 (import-for-syntax matchable)
 (include "alist-lib-core.scm"))

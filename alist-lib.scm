(module
 alist-lib
 (alist-values
  alist-keys
  alist-map
  alist-set!
  alist-update!
  alist-update!/default
  alist-ref
  alist-ref/default
  alist-size
  alist-fold
  alist-set)
 (import scheme
         chicken)
 (use srfi-1 matchable)

 (include "alist-lib-core.scm"))

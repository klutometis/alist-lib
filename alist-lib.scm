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
 (import scheme
         chicken)
 (use matchable
      srfi-1)
 (import-for-syntax matchable)
 (include "alist-lib-core.scm"))

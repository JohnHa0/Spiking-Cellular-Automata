;;; scheme mode
(setq scheme-program-name "/usr/local/Cellar/guile/1.8.7/bin/guile")
;;;

;;; 行号
(global-linum-mode t)
;;;


;;; slime (lisp IDE)

  (load (expand-file-name "~/quicklisp/slime-helper.el"))
  ;; Replace "sbcl" with the path to your implementation
  (setq inferior-lisp-program "/usr/local/Cellar/clozure-cl/1.7/bin/ccl64")




;(setq inferior-lisp-program "/usr/local/Cellar/sbcl/1.0.52/bin/sbcl") ;sbcl Lisp system
;(setq inferior-lisp-program "/usr/local/Cellar/clozure-cl/1.6/bin/ccl") ;clozure lisp system
;(setq inferior-lisp-program "/usr/local/Cellar/clisp/2.49/bin/clisp") ;clisp lisp system
;(add-to-list 'load-path "~/slime") ;slime directory
;(require 'slime)
;(slime-setup)


;;;;;;;;;;;


;;;E-mail

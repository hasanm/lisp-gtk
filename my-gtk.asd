(asdf:defsystem #:my-gtk
  :serial t
  :depends-on (#:cl-ppcre
               #:parenscript
               #:cl-cffi-gtk)
  :components ((:file "package")
               (:file "my-gtk")))

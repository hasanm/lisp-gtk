(defpackage #:my-gtk
  (:use #:cl
        #:cl-ppcre
        #:gtk
        #:gdk
        #:gobject
        #:glib
        #:pango
        #:cairo
        #:cffi
        #:parenscript)
  (:export
   :demo-cairo-stroke))

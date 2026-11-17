(clear)


(defrule r1   
   (es-humano ?persona)
   =>
   (assert (es-mortal ?persona))
   (printout t "Deduccion: " ?persona " es mortal." crlf))

(deffacts premisa
   (es-humano Socrates))
   
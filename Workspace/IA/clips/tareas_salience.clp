(defrule tarea-alta
  (declare (salience 10))
  (datos-listos)
  =>
  (printout t "-> [Prioridad 10] Ejecutando tarea critica primero." crlf)
)

(defrule tarea-media
  (declare (salience 5))
  (datos-listos)
  =>
  (printout t "-> [Prioridad 5] Ejecutando tarea secundaria despues." crlf)
)

(defrule tarea-baja
  (declare (salience 1))
  (datos-listos)
  =>
  (printout t "-> [Prioridad 1] Ejecutando reporte final al ultimo." crlf)
)

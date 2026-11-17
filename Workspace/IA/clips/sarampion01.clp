;; 1. HECHOS INICIALES
;; Definimos directamente el nombre de Juan y sus síntomas como hechos simples.
(deffacts datos-juan
   (paciente juan)
   (tiene-fiebre juan)
   (tiene-manchas-koplik juan))

;; 2. REGLA DE INFERENCIA
;; Si el paciente tiene fiebre y manchas de Koplik, inferimos que tiene sarampión.
(defrule evaluar-sarampion
   (paciente ?nombre)
   (tiene-fiebre ?nombre)
   (tiene-manchas-koplik ?nombre)
   =>
   (assert (diagnostico ?nombre sarampion)))

;; 3. REGLA DE SALIDA
;; Muestra el resultado final en la pantalla.
(defrule mostrar-resultado
   (diagnostico ?nombre sarampion)
   =>
   (printout t "Resultado: Es muy probable que " ?nombre " tenga sarampion." crlf))
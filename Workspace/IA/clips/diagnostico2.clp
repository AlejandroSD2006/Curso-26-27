;;; =========================================================================
;;; 1. REGLAS PARA DIAGNOSTICAR FIEBRE
;;; =========================================================================

;; Determina fiebre alta si la temperatura es mayor o igual a 38.5
(defrule diagnosticar-fiebre-alta
   (temperatura ?t)
   (test (>= ?t 38.5))
   (not (diagnostico-fiebre ?))
   =>
   (assert (diagnostico-fiebre alta))
   (printout t "Sistema: Se ha detectado fiebre alta (" ?t " C)." crlf))

;; Determina fiebre moderada/baja si la temperatura está entre 37.5 y 38.4
(defrule diagnosticar-fiebre-moderada
   (temperatura ?t)
   (test (and (>= ?t 37.5) (< ?t 38.5)))
   (not (diagnostico-fiebre ?))
   =>
   (assert (diagnostico-fiebre moderada))
   (printout t "Sistema: Se ha detectado fiebre moderada (" ?t " C)." crlf))

;; Determina que no hay fiebre si es menor a 37.5
(defrule diagnosticar-sin-fiebre
   (temperatura ?t)
   (test (< ?t 37.5))
   (not (diagnostico-fiebre ?))
   =>
   (assert (diagnostico-fiebre ninguna))
   (printout t "Sistema: Temperatura normal (" ?t " C)." crlf))


;;; =========================================================================
;;; 2. REGLAS PARA DIAGNOSTICAR SARAMPIÓN
;;; =========================================================================

;; Sospecha alta de sarampión: Fiebre alta + Manchas de Koplik
(defrule diagnostico-sarampion-confirmado
   (diagnostico-fiebre alta)
   (sintoma manchas-koplik)
   =>
   (assert (diagnostico-final sarampion-altamente-probable))
   (printout t "Resultado: Diagnóstico de SARAMPIÓN ALTAMENTE PROBABLE debido a fiebre alta y manchas de Koplik." crlf))

;; Sospecha moderada: Fiebre alta + Exantema (erupción) + Síntomas catarrales (Triple C: Tos, Coriza, Conjuntivitis)
(defrule diagnostico-sarampion-sintomatico
   (diagnostico-fiebre alta)
   (sintoma erupcion-cutanea)
   (sintoma tos)
   (sintoma conjuntivitis)
   (not (diagnostico-final sarampion-altamente-probable))
   =>
   (assert (diagnostico-final sarampion-probable))
   (printout t "Resultado: Diagnóstico de SARAMPIÓN PROBABLE por cuadro clínico clásico (fiebre, erupción, tos y conjuntivitis)." crlf))

;; Caso negativo: Si se determina que no hay fiebre, se descarta sarampión
(defrule descartar-sarampion-por-fiebre
   (diagnostico-fiebre ninguna)
   =>
   (assert (diagnostico-final no-sarampion))
   (printout t "Resultado: SARAMPIÓN DESCARTADO debido a la ausencia de fiebre." crlf))


;;; =========================================================================
;;; 3. HECHOS INICIALES DE PRUEBA (Deffacts)
;;; =========================================================================

;; Puedes modificar estos hechos para probar diferentes escenarios
(deffacts caso-paciente
   (temperatura 39.0)
   (sintoma manchas-koplik)
   (sintoma tos)
   (sintoma conjuntivitis)
   (sintoma erupcion-cutanea))

;;; =========================================================================
;;; 1. REGLA DE INICIO (PREGUNTAS INTERACTIVAS)
;;; =========================================================================

(defrule iniciar-sistema
   (initial-fact)
   =>
   (printout t "==================================================" crlf)
   (printout t "   SISTEMA INTERACTIVO DE DIAGNÓSTICO MÉDICO       " crlf)
   (printout t "==================================================" crlf)
   
   ;; Pregunta la temperatura
   (printout t "Ingrese la temperatura corporal del paciente (ej. 38.5): ")
   (bind ?temp (read))
   (assert (temperatura ?temp))
   
   ;; Pregunta por las Manchas de Koplik
   (printout t "¿El paciente presenta manchas blancas en la boca (Manchas de Koplik)?" crlf)
   (printout t "  1) Si" crlf)
   (printout t "  2) No" crlf)
   (printout t "Seleccione una opcion: ")
   (bind ?opcion (read))
   (if (= ?opcion 1) then (assert (sintoma manchas-koplik)))
   
   ;; Pregunta por la Erupción Cutánea
   (printout t "¿El paciente presenta erupcion/manchas rojas en la piel (Exantema)?" crlf)
   (printout t "  1) Si" crlf)
   (printout t "  2) No" crlf)
   (printout t "Seleccione una opcion: ")
   (bind ?opcion (read))
   (if (= ?opcion 1) then (assert (sintoma erupcion-cutanea)))

   ;; Pregunta por la Tos
   (printout t "¿El paciente tiene tos?" crlf)
   (printout t "  1) Si" crlf)
   (printout t "  2) No" crlf)
   (printout t "Seleccione una opcion: ")
   (bind ?opcion (read))
   (if (= ?opcion 1) then (assert (sintoma tos)))

   ;; Pregunta por la Conjuntivitis
   (printout t "¿El paciente tiene los ojos rojos o conjuntivitis?" crlf)
   (printout t "  1) Si" crlf)
   (printout t "  2) No" crlf)
   (printout t "Seleccione una opcion: ")
   (bind ?opcion (read))
   (if (= ?opcion 1) then (assert (sintoma conjuntivitis)))
   
   (printout t "--------------------------------------------------" crlf)
   (printout t "Procesando datos..." crlf)
   (printout t "--------------------------------------------------" crlf))


;;; =========================================================================
;;; 2. REGLAS PARA DIAGNOSTICAR FIEBRE
;;; =========================================================================

(defrule diagnosticar-fiebre-alta
   (temperatura ?t)
   (test (>= ?t 38.5))
   (not (diagnostico-fiebre ?))
   =>
   (assert (diagnostico-fiebre alta))
   (printout t "- Fiebre detectada: ALTA (" ?t " C)." crlf))

(defrule diagnosticar-fiebre-moderada
   (temperatura ?t)
   (test (and (>= ?t 37.5) (< ?t 38.5)))
   (not (diagnostico-fiebre ?))
   =>
   (assert (diagnostico-fiebre moderada))
   (printout t "- Fiebre detectada: MODERADA (" ?t " C)." crlf))

(defrule diagnosticar-sin-fiebre
   (temperatura ?t)
   (test (< ?t 37.5))
   (not (diagnostico-fiebre ?))
   =>
   (assert (diagnostico-fiebre ninguna))
   (printout t "- Fiebre detectada: NINGUNA (" ?t " C)." crlf))


;;; =========================================================================
;;; 3. REGLAS PARA DIAGNOSTICAR SARAMPIÓN
;;; =========================================================================

(defrule diagnostico-sarampion-confirmado
   (diagnostico-fiebre alta)
   (sintoma manchas-koplik)
   =>
   (assert (diagnostico-final sarampion-altamente-probable))
   (printout t crlf "RESULTADO FINAL: SARAMPIÓN ALTAMENTE PROBABLE debido a la combinacion de fiebre alta y manchas de Koplik." crlf))

(defrule diagnostico-sarampion-sintomatico
   (diagnostico-fiebre alta)
   (sintoma erupcion-cutanea)
   (sintoma tos)
   (sintoma conjuntivitis)
   (not (diagnostico-final sarampion-altamente-probable))
   =>
   (assert (diagnostico-final sarampion-probable))
   (printout t crlf "RESULTADO FINAL: SARAMPIÓN PROBABLE basandose en el cuadro clinico clasico (fiebre alta, exantema, tos y conjuntivitis)." crlf))

(defrule diagnostico-sarampion-sospecha
   (diagnostico-fiebre moderada)
   (sintoma erupcion-cutanea)
   (not (diagnostico-final ?))
   =>
   (assert (diagnostico-final sospecha-eruptiva))
   (printout t crlf "RESULTADO FINAL: SOSPECHA DE ENFERMEDAD EXANTEMÁTICA. Fiebre moderada y erupcion. Podria ser sarampion en fase inicial u otra virosis." crlf))

(defrule descartar-sarampion-por-fiebre
   (diagnostico-fiebre ninguna)
   (not (diagnostico-final ?))
   =>
   (assert (diagnostico-final no-sarampion))
   (printout t crlf "RESULTADO FINAL: SARAMPIÓN DESCARTADO debido a la ausencia de fiebre (requisito indispensable)." crlf))

(defrule diagnostico-indeterminado
   (declare (salience -10))
   (not (diagnostico-final ?))
   =>
   (assert (diagnostico-final indeterminado))
   (printout t crlf "RESULTADO FINAL: NO COMPLETA CRITERIOS PARA SARAMPIÓN. Los sintomas no son concluyentes." crlf))


;;; =========================================================================
;;; 4. FUNCIÓN DE ARRANQUE SEGURO
;;; =========================================================================
;; Esta función fuerza la creación de (initial-fact) y ejecuta el programa directamente.
(deffunction iniciar ()
   (reset)
   (assert (initial-fact))
   (run))

;;; ====================================================================
;;; ASISTENTE DE PARQUE DE ATRACCIONES (SBR en CLIPS)
;;;
;;; Uso:   (load "parque.clp")   (reset)   (run)
;;;
;;; Idea general:
;;;   1. Se piden los datos del visitante (edad, salud, mascota...).
;;;   2. Fase CALCULAR: una regla genera un hecho (opcion ...) por cada
;;;      atraccion que el visitante PUEDE usar ahora, con una puntuacion.
;;;   3. Fase MOSTRAR: se listan las opciones de mejor a peor puntuacion
;;;      y el usuario escribe el codigo de la que quiere.
;;;   4. Se guarda la atraccion en "visitadas", se suma 1 a la hora y se
;;;      vuelve a la fase CALCULAR. Al llegar a las 23h el parque cierra.
;;;
;;; Convenciones: todo lo que escribe el usuario se pasa a MAYUSCULAS,
;;; por eso en el programa los valores (SI, NO, N, J, A...) van en mayusculas.
;;; ====================================================================


;;; ------------------------- PLANTILLAS -------------------------------

;;; Datos que da el visitante al entrar (no cambian durante la visita)
(deftemplate visitante
   (slot edad)                      ; N = nino, J = joven, A = adulto
   (multislot salud)                ; VE, MAR, VO... o NINGUNA
   (slot mascota)                   ; SI / NO
   (slot comida)                    ; PARQUE / FUERA / BOCADILLO
   (slot banador))                  ; SI / NO

;;; Variables de interes: situacion actual del visitante en el parque
(deftemplate estado
   (slot hora)                      ; hactual: 11..22
   (slot mes)                       ; ABR, MAY, JUN...
   (slot zona)                      ; 1..4 (0 = lago)
   (multislot visitadas)            ; lista de codigos ya visitados
   (slot ultima (default NINGUNA))  ; ultima atraccion realizada
   (slot fase))                     ; CALCULAR / MOSTRAR

;;; Ficha de cada atraccion (los requisitos de acceso van aqui, asi una
;;; unica regla sirve para todas)
(deftemplate atraccion
   (slot codigo)
   (slot nombre)
   (slot zona)                      ; 1..4 (0 = lago)
   (multislot edades)               ; edades que pueden entrar
   (slot mascota (default NO))      ; SI = admite mascota, NO = no la admite,
                                    ; SOLO = solo para visitantes con mascota
   (multislot prohibido)            ; restricciones de salud que lo impiden
                                    ; (TODAS = cualquier restriccion)
   (slot espera)                    ; tiempo de espera: B, M, A
   (multislot horas)                ; horas de acceso (vacio = todo el dia)
   (multislot meses)                ; meses de apertura (vacio = todo el parque)
   (slot requiere (default NADA))   ; NADA / BANADOR / COMER
   (slot bonus (default 0)))        ; puntos extra (comidas y fuegos)

;;; Atraccion que se puede sugerir ahora mismo, con su puntuacion
(deftemplate opcion
   (slot codigo)
   (slot puntos)
   (slot mostrada (default NO)))


;;; ------------------------- DATOS: ATRACCIONES -----------------------

(deffacts atracciones
   (atraccion (codigo MRU) (nombre "Montana rusa")        (zona 1) (edades J A)   (prohibido TODAS) (espera A))
   (atraccion (codigo TRO) (nombre "Troncos")             (zona 1) (edades N J A) (mascota SI)      (espera M))
   (atraccion (codigo PMA) (nombre "Parque mascotas")     (zona 1) (edades N J A) (mascota SOLO)    (espera B))
   (atraccion (codigo LAN) (nombre "Lanzadera")           (zona 2) (edades J A)   (prohibido VE)    (espera M))
   (atraccion (codigo TRE) (nombre "Tren de la escoba")   (zona 2) (edades N J A) (mascota SI)      (espera B))
   (atraccion (codigo AVE) (nombre "Aves rapaces")        (zona 2) (edades N J A) (horas 12 17 19)  (espera M))
   (atraccion (codigo CAD) (nombre "Coches locos adultos")(zona 3) (edades J A)   (prohibido VO)    (espera M))
   (atraccion (codigo CNI) (nombre "Coches locos ninos")  (zona 3) (edades N)     (prohibido VO)    (espera B))
   (atraccion (codigo NUB) (nombre "Nube infantil")       (zona 3) (edades N)     (prohibido VO)    (espera B))
   (atraccion (codigo PAC) (nombre "Parque acuatico")     (zona 3) (edades N J A) (meses JUL AGO) (requiere BANADOR) (espera A))
   (atraccion (codigo FAR) (nombre "Fuegos artificiales") (zona 0) (edades N J A) (mascota SI)      (horas 22) (bonus 5) (espera B))
   (atraccion (codigo ALM) (nombre "Almuerzo")            (zona 4) (edades N J A) (mascota SI)      (horas 13 14) (requiere COMER) (bonus 5) (espera M))
   (atraccion (codigo MER) (nombre "Merienda")            (zona 4) (edades N J A) (mascota SI)      (horas 18) (bonus 5) (espera M)))


;;; ------------------------- FUNCIONES AUXILIARES ---------------------

;;; Muestra una pregunta y devuelve lo escrito, en mayusculas, como lista
;;; de palabras (multifield). Repite si el usuario no escribe nada.
(deffunction preguntar (?texto)
   (printout t ?texto " ")
   (bind ?r (explode$ (upcase (readline))))
   (while (= (length$ ?r) 0) do
      (bind ?r (explode$ (upcase (readline)))))
   (return ?r))

;;; Igual que preguntar, pero solo acepta una de las palabras de ?validos
;;; y devuelve la primera palabra escrita. Si no es valida, vuelve a preguntar.
(deffunction preguntar-opcion (?texto $?validos)
   (bind ?r (nth$ 1 (preguntar ?texto)))
   (while (not (member$ ?r ?validos)) do
      (printout t "   Respuesta no valida. Opciones: " ?validos crlf)
      (bind ?r (nth$ 1 (preguntar ?texto))))
   (return ?r))

;;; TRUE si las restricciones de salud del visitante (?sal) no chocan con
;;; las que prohibe la atraccion (?pro).
(deffunction salud-ok (?sal ?pro)
   (if (member$ TODAS ?pro)
      then (return (neq (member$ NINGUNA ?sal) FALSE)))   ; "todas": solo sin restricciones
   (progn$ (?r ?sal)
      (if (member$ ?r ?pro) then (return FALSE)))
   (return TRUE))

;;; Puntos por cercania entre dos zonas. Las zonas forman un anillo
;;; 1-2-3-4-1: misma zona = 2, zona vecina = 1, zona opuesta = 0.
;;; El lago (zona 0) es accesible desde cualquier zona: cuenta como vecina.
(deffunction puntos-zona (?a ?b)
   (if (= ?a ?b) then (return 2))
   (if (or (= ?a 0) (= ?b 0)) then (return 1))
   (if (= (abs (- ?a ?b)) 2) then (return 0))
   (return 1))

;;; Puntos por tiempo de espera: cuanto menos cola, mas puntos.
(deffunction puntos-espera (?e)
   (if (eq ?e B) then (return 3))
   (if (eq ?e M) then (return 2))
   (return 1))


;;; ------------------------- REGLAS: INICIO Y FIN ---------------------

;;; Se dispara una sola vez tras (reset): pide los datos al visitante
(defrule pedir-datos
   =>
   (printout t crlf "=== ASISTENTE DEL PARQUE DE ATRACCIONES ===" crlf)
   (bind ?edad  (preguntar-opcion "Edad (N=nino, J=joven, A=adulto):" N J A))
   (bind ?salud (preguntar "Restricciones de salud (VE, MAR, VO... separadas por espacios) o NINGUNA:"))
   (bind ?masc  (preguntar-opcion "Vienes con mascota? (SI/NO):" SI NO))
   (bind ?com   (preguntar-opcion "Comida (PARQUE, FUERA, BOCADILLO):" PARQUE FUERA BOCADILLO))
   (bind ?ban   (preguntar-opcion "Traes traje de bano? (SI/NO):" SI NO))
   ;; En la app real el mes y la zona los daria el sistema (fecha y GPS)
   (bind ?mes   (preguntar-opcion "Mes actual (ENE FEB MAR ABR MAY JUN JUL AGO SEP OCT NOV DIC):"
                                  ENE FEB MAR ABR MAY JUN JUL AGO SEP OCT NOV DIC))
   (assert (visitante (edad ?edad) (salud ?salud) (mascota ?masc)
                      (comida ?com) (banador ?ban)))
   ;; Se entra por la zona 1 y el parque abre a las 11h
   (assert (estado (hora 11) (mes ?mes) (zona 1) (fase CALCULAR))))

;;; El parque solo abre de abril a octubre
(defrule parque-cerrado (declare (salience 30))
   (estado (mes ?m&:(not (member$ ?m (create$ ABR MAY JUN JUL AGO SEP OCT)))))
   =>
   (printout t crlf "El parque esta cerrado en este mes (abre de ABR a OCT)." crlf)
   (halt))

;;; Cada actividad dura 1h: tras la de las 22h son las 23h y el parque cierra
(defrule fin-de-jornada (declare (salience 30))
   (estado (hora ?h&:(> ?h 22)) (visitadas $?vis))
   =>
   (printout t crlf "Son las 23:00h, el parque cierra. Has hecho: " ?vis crlf "Hasta pronto!" crlf)
   (halt))


;;; ------------------------- REGLAS: FASE CALCULAR --------------------

;;; REGLA GENERICA: se activa una vez por cada atraccion que cumple TODOS
;;; los requisitos de acceso, y crea su opcion con la puntuacion.
(defrule calcular-opciones
   (estado (fase CALCULAR) (hora ?h) (mes ?mes) (zona ?zv)
           (visitadas $?vis) (ultima ?ult))
   (visitante (edad ?edad) (salud $?sal) (mascota ?m) (comida ?com) (banador ?ban))
   (atraccion (codigo ?c) (zona ?za) (edades $?eds) (mascota ?pm) (prohibido $?pro)
              (espera ?esp) (horas $?hrs) (meses $?mss) (requiere ?req) (bonus ?bon))
   ;; --- Requisitos de acceso (6 puntos) ---
   ;; edad permitida
   (test (member$ ?edad ?eds))
   ;; mascota: con mascota solo si la admite (SI/SOLO); sin mascota, no las "SOLO"
   (test (or (and (eq ?m SI) (neq ?pm NO))
             (and (eq ?m NO) (neq ?pm SOLO))))
   ;; restricciones de salud
   (test (salud-ok ?sal ?pro))
   ;; horario de acceso (lista vacia = sin restriccion)
   (test (or (= (length$ ?hrs) 0) (member$ ?h ?hrs)))
   ;; mes de apertura (lista vacia = sin restriccion)
   (test (or (= (length$ ?mss) 0) (member$ ?mes ?mss)))
   ;; necesita traje de bano / querer comer en el parque
   (test (or (eq ?req NADA)
             (and (eq ?req BANADOR) (eq ?ban SI))
             (and (eq ?req COMER) (neq ?com FUERA))))
   ;; --- Sugerencia: no montaña rusa ni lanzadera justo tras comer ---
   (test (not (and (member$ ?ult (create$ ALM MER))
                   (member$ ?c (create$ MRU LAN)))))
   =>
   ;; --- Puntuacion (4 puntos): poca espera + cerca + bonus - repetir ---
   (assert (opcion (codigo ?c)
                   (puntos (+ (puntos-espera ?esp)
                              (puntos-zona ?zv ?za)
                              ?bon
                              (if (member$ ?c ?vis) then -10 else 0))))))


;;; ------------------------- REGLAS: FASE MOSTRAR ---------------------

;;; Cuando ya se han generado todas las opciones (salience baja = se dispara
;;; la ultima), cambia a la fase MOSTRAR
(defrule pasar-a-mostrar (declare (salience -10))
   ?e <- (estado (fase CALCULAR) (hora ?h) (zona ?z))
   =>
   (modify ?e (fase MOSTRAR))
   (printout t crlf "--- Son las " ?h ":00h. Estas en la zona " ?z " (0 = lago) ---" crlf
                 "Puedes hacer (mejor opcion primero):" crlf))

;;; Imprime, una a una, la opcion no mostrada con mas puntos
(defrule mostrar-mejor
   (estado (fase MOSTRAR))
   ?o <- (opcion (codigo ?c) (puntos ?p) (mostrada NO))
   (atraccion (codigo ?c) (nombre ?n) (zona ?z) (espera ?esp))
   (not (opcion (puntos ?p2&:(> ?p2 ?p)) (mostrada NO)))
   =>
   (modify ?o (mostrada SI))
   (printout t "   " ?c " - " ?n " (zona " ?z ", espera " ?esp ")"
                (if (< ?p 0) then "  [ya visitada, repetir]" else "") crlf))

;;; Pide el codigo cuando ya se ha mostrado toda la lista
(defrule pedir-eleccion (declare (salience -20))
   (estado (fase MOSTRAR))
   (not (eleccion ?))
   =>
   (assert (eleccion (nth$ 1 (preguntar "Codigo de la atraccion que quieres usar:")))))

;;; Codigo correcto: se apunta como visitada, se avanza 1h y se cambia de zona.
;;; Tambien se borran las opciones de este turno para calcular las nuevas.
(defrule eleccion-valida
   ?el <- (eleccion ?c)
   (opcion (codigo ?c))
   (atraccion (codigo ?c) (zona ?z))
   ?e <- (estado (hora ?h) (visitadas $?vis))
   =>
   (retract ?el)
   (do-for-all-facts ((?o opcion)) TRUE (retract ?o))
   (modify ?e (hora (+ ?h 1)) (zona ?z) (visitadas ?vis ?c)
              (ultima ?c) (fase CALCULAR)))

;;; Codigo que no esta en la lista: se avisa y se vuelve a preguntar
(defrule eleccion-invalida
   ?el <- (eleccion ?c)
   (not (opcion (codigo ?c)))
   =>
   (retract ?el)
   (printout t "   Codigo no valido, elige uno de la lista." crlf))

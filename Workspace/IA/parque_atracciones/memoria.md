# Memoria: asistente de parque de atracciones en CLIPS

Archivo del programa: `parque.clp`

## 1. Qué hace el programa

Es un sistema basado en reglas (SBR) que sugiere al visitante qué hacer **en cada hora** de su visita, según:

- **Quién es**: edad, restricciones de salud, mascota, comida, traje de baño.
- **Dónde está**: la zona del parque.
- **Cuándo es**: la hora (11 a 22) y el mes.

Cada actividad dura 1 hora. El programa:

1. Calcula qué atracciones puede usar el visitante ahora mismo.
2. Las ordena de mejor a peor y las muestra.
3. El usuario escribe el código de la que quiere.
4. Se apunta como visitada, pasa 1 hora y se repite hasta que el parque cierra.

---

## 2. Cómo se ejecuta

```
(load "parque.clp")
(reset)
(run)
```

- `load` carga las reglas en memoria.
- `reset` crea los hechos iniciales (las 13 atracciones).
- `run` arranca el asistente y empieza a hacer preguntas.

---

## 3. Estructura de los datos (hechos)

El programa usa 4 plantillas (`deftemplate`):

| Plantilla    | Para qué sirve                                      | Campos principales                                                    |
|--------------|-----------------------------------------------------|------------------------------------------------------------------------|
| `visitante`  | Datos que da el visitante al entrar (no cambian)    | edad, salud, mascota, comida, banador                                  |
| `estado`     | Variables de interés: dónde y cuándo estamos        | hora, mes, zona, visitadas (lista), ultima, fase                       |
| `atraccion`  | Ficha de cada atracción con sus requisitos          | codigo, zona, edades, mascota, prohibido, espera, horas, meses, requiere, bonus |
| `opcion`     | Atracción que se puede sugerir ahora, con puntuación | codigo, puntos, mostrada                                               |

### Ficha de una atracción

Todos los requisitos de acceso están **en los datos**, no en el código de las reglas:

| Campo        | Significado                                                              | Ejemplo                  |
|--------------|---------------------------------------------------------------------------|--------------------------|
| `edades`     | Edades que pueden entrar                                                  | `(edades J A)`           |
| `mascota`    | `SI` la admite, `NO` no la admite (por defecto), `SOLO` solo con mascota | PMA → `SOLO`             |
| `prohibido`  | Restricciones de salud que lo impiden (`TODAS` = cualquiera)             | LAN → `VE`               |
| `horas`      | Horas en que está accesible (vacío = todo el día)                        | AVE → `12 17 19`         |
| `meses`      | Meses en que está abierta (vacío = todo el año)                          | PAC → `JUL AGO`          |
| `requiere`   | `NADA`, `BANADOR` o `COMER`                                               | PAC → `BANADOR`          |
| `espera`     | Tiempo de cola: `B` bajo, `M` medio, `A` alto                            | MRU → `A`                |
| `bonus`      | Puntos extra para comida y fuegos                                         | ALM, MER, FAR → `5`      |

### Zonas

Las zonas forman un anillo; la zona 0 es el lago, accesible desde cualquiera:

```
        Z1 ─── Z2
        │  (L)  │          L = lago (zona 0)
        Z4 ─── Z3
```

Vecinas: Z1-Z2, Z2-Z3, Z3-Z4, Z4-Z1. Opuestas: Z1-Z3 y Z2-Z4.

---

## 3.1 Codificación de las variables

| Variable | Codificación |
|----------|--------------|
| Mes      | Etiqueta: `ABR`, `MAY`, `JUN`... (el parque abre `ABR` a `OCT`) |
| Hora     | Número `hactual` de 11 a 22 (el 11 es 11:00-11:59)              |
| Zona     | Número 1-4 (0 = lago)                                           |
| Visitadas| Lista (multislot) con los códigos: `(MRU TRO ALM ...)`          |

---

## 4. Funcionamiento: las fases

Todo el ciclo se controla con el campo `fase` del hecho `estado`:

```
         ┌────────────────────────────────────────────┐
         │                                            │
         ▼                                            │
   ┌───────────┐   ┌───────────┐   ┌──────────────┐   │
   │ CALCULAR  │──▶│  MOSTRAR  │──▶│ El usuario   │───┘
   │ (opciones)│   │ (lista)   │   │ elige código │  hora + 1
   └───────────┘   └───────────┘   └──────────────┘
         │
         └─▶ hora > 22  →  el parque cierra (fin)
```

### Paso a paso

| Paso | Regla | Qué hace |
|------|-------|----------|
| 0 | `pedir-datos` | Tras `reset` pregunta los datos y crea `visitante` y `estado` (hora 11, zona 1, fase CALCULAR) |
| 1 | `parque-cerrado` | Si el mes no está entre ABR y OCT, avisa y termina |
| 2 | `calcular-opciones` | Crea una `opcion` por cada atracción que el visitante puede usar |
| 3 | `pasar-a-mostrar` | Cuando ya no quedan atracciones por calcular, cambia a la fase MOSTRAR |
| 4 | `mostrar-mejor` | Imprime las opciones de mayor a menor puntuación |
| 5 | `pedir-eleccion` | Pregunta el código |
| 6a | `eleccion-valida` | Apunta la atracción en `visitadas`, hora + 1, cambia de zona, borra las opciones y vuelve a CALCULAR |
| 6b | `eleccion-invalida` | Si el código no está en la lista, avisa y vuelve a preguntar |
| 7 | `fin-de-jornada` | Si la hora pasa de 22, el parque cierra y termina |

### Prioridad de reglas (salience)

El orden de disparo lo controla la prioridad. Cuanto mayor es, antes se dispara:

| Salience | Regla | Motivo |
|----------|-------|--------|
| 30  | `parque-cerrado`, `fin-de-jornada` | Parar antes de hacer nada más |
| 0   | `calcular-opciones`, `mostrar-mejor`, `eleccion-*` | Trabajo normal |
| -10 | `pasar-a-mostrar` | Debe ir **después** de que se calculen todas las opciones |
| -20 | `pedir-eleccion` | Debe ir **después** de mostrar toda la lista |

---

## 5. La regla principal: `calcular-opciones`

Una sola regla genérica sirve para **todas** las atracciones. Se activa una vez por cada atracción que cumple **todos** estos requisitos:

| Requisito | Condición |
|-----------|-----------|
| Edad | La edad del visitante está en `edades` de la atracción |
| Mascota | Con mascota: la atracción debe admitirla (`SI` o `SOLO`). Sin mascota: no puede ser `SOLO` |
| Salud | Ninguna restricción del visitante está en `prohibido` (con `TODAS` basta con tener alguna) |
| Hora | `horas` vacío, o la hora actual está en la lista |
| Mes | `meses` vacío, o el mes actual está en la lista |
| Requisito extra | `BANADOR` → debe traerlo; `COMER` → no puede haber elegido comer `FUERA` |
| Tras comer | Si lo último fue `ALM` o `MER`, no se ofrecen `MRU` ni `LAN` |

Si lo cumple, crea la opción con su puntuación.

---

## 6. Cómo se puntúa

```
puntos = puntos-espera + puntos-zona + bonus  (-10 si ya está visitada)
```

| Concepto | Valores |
|----------|---------|
| Espera (`puntos-espera`) | Baja = 3, Media = 2, Alta = 1 |
| Cercanía (`puntos-zona`) | Misma zona = 2, zona vecina o lago = 1, zona opuesta = 0 |
| Bonus | Comidas y fuegos = +5 (para que salgan primero en su horario) |
| Repetida | −10 (sigue en la lista, pero al final, marcada `[ya visitada, repetir]`) |

Mejor opción posible = **espera baja y en la misma zona** (3 + 2 = 5 puntos).

### Ejemplo

Visitante adulto en la zona 1:

| Atracción | Zona | Espera | Cálculo | Puntos |
|-----------|------|--------|---------|--------|
| TRO | 1 | M | 2 + 2 | **4** |
| TRE | 2 | B | 3 + 1 | **4** |
| LAN | 2 | M | 2 + 1 | **3** |
| MRU | 1 | A | 1 + 2 | **3** |
| CAD | 3 | M | 2 + 0 | **2** |

---

## 7. Cómo se cumplen los requisitos del enunciado

| Requisito | Dónde se resuelve |
|-----------|-------------------|
| Respetar el acceso (niños sin montaña rusa, perro sin nube, acuático cerrado) | Los 5 primeros `test` de `calcular-opciones` + datos de `atraccion` |
| Lista de atracciones visitadas | Campo `visitadas` de `estado` (se amplía en `eleccion-valida`) |
| Se puede repetir una atracción | Se mantiene en la lista, con −10 puntos |
| Cada actividad dura 1 h | `eleccion-valida` suma 1 a la hora |
| Salir cuando cierra el parque | `fin-de-jornada` y `parque-cerrado` |
| Preferir espera baja y cercanía | Función de puntuación (apartado 6) |
| No montaña rusa ni lanzadera tras comer | Último `test` de `calcular-opciones`, usando el campo `ultima` |
| Horarios de aves rapaces, fuegos, almuerzo y merienda | Campo `horas` de cada atracción |

---

## 8. Funciones auxiliares

| Función | Qué hace |
|---------|----------|
| `preguntar` | Muestra una pregunta y devuelve lo escrito en mayúsculas como lista de palabras |
| `preguntar-opcion` | Igual, pero solo acepta valores de una lista; si no, repite la pregunta |
| `salud-ok` | Comprueba si las restricciones de salud del visitante permiten la atracción |
| `puntos-zona` | Puntos por cercanía entre dos zonas |
| `puntos-espera` | Puntos por tiempo de espera |

---

## 9. Decisiones e interpretaciones

Puntos que el enunciado deja ambiguos y cómo se han resuelto:

| Punto | Decisión |
|-------|----------|
| Cierre del programa | El enunciado dice "salir a las 22h", pero los fuegos son a las 22:00. Se sale cuando `hora > 22` (el parque cierra a las 23h) para poder ofrecerlos |
| Restricción "V" de coches locos y nube | Se interpreta como vómitos (`VO`) |
| Restricción "M" de aves rapaces | Se interpreta como mascota; ya queda cubierto por "solo personas" |
| Visitante con mascota | Solo se le ofrecen las atracciones abiertas a mascotas (troncos, tren, fuegos, comidas) y el parque de mascotas |
| Almuerzo | Se ofrece de 13h a 14h (13:00-15:00), salvo que el visitante coma fuera del parque |
| Merienda | Se ofrece a las 18h (18:00-19:00) |
| Mes y zona | En la simulación el mes se pregunta y la zona es la de la última atracción. En la app real vendrían de la fecha y del GPS |
| Tiempos de espera | Fijos en la ficha de cada atracción. En la app real vendrían de un sistema de colas |

---

## 10. Pruebas realizadas

| Caso | Resultado |
|------|-----------|
| Adulto en mayo, día completo | Cierra a las 23h; tras ALM y MER no aparecen MRU ni LAN |
| Niño con mascota y vómitos | No se le ofrece nube infantil, aves rapaces ni montaña rusa |
| Niño sin mascota | No se le ofrece el parque de mascotas |
| Mes de julio con bañador | Aparece el parque acuático |
| Mes de junio | No aparece el parque acuático |
| Mes de noviembre | El parque aparece cerrado |
| Código inventado | Avisa y vuelve a preguntar |
| Respuesta no válida en los datos iniciales | Avisa y vuelve a preguntar |

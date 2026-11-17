# Guion fácil de la presentación

Es un chuleta para tener delante mientras hablas. Cada diapositiva lleva la idea principal, unos puntos para acordarte y una frase para pasar a la siguiente. Si te pierdes, el guion completo está en `Guion_exposicion.md`.

Más o menos 30 segundos por diapositiva, unos 10 minutos en total.

---

## 1. Saludo

- Me llamo Alejandro y voy a contar mi miniproyecto de la UD1.
- Trata de juntar un formulario de entrenamientos con el tiempo que hacía.

Paso: "Vamos a empezar por el problema."

## 2. El problema

- A veces rendimos peor y no sabemos si es por el calor, la humedad o el viento.
- Idea: recoger entrenamientos reales y cruzarlos con el clima de ese momento.
- Lo elegí porque es lo que más se parece a mi día a día.

Paso: "¿Y qué hay que hacer exactamente?"

## 3. Qué se pide

- Dos fuentes distintas: un formulario y una API del tiempo.
- Resultado: una fila por entrenamiento con su clima.
- Es solo un diseño, no se programa. Por eso no hay resultados medidos.

Paso: "Veamos primero el formulario."

## 4. El formulario

- Pregunta nombre, edad, deporte, hora de inicio, hora de fin, duración, distancia y esfuerzo del 1 al 10.
- Las horas de inicio y fin son las que sirven para buscar el clima.
- Las respuestas van a un Google Sheet y un Apps Script guarda el id de cada una.
- Campos obligatorios y rangos validados.

Paso: "La otra fuente es la API del tiempo."

## 5. La API

- Es Open-Meteo, una API REST pública que responde en JSON.
- No necesita clave y se actualiza cada 15 minutos.
- Pedimos temperatura, humedad, viento, UV y precipitación.
- Para el tramo del entrenamiento usamos su histórico.

Paso: "Veamos cómo se le pide y qué devuelve."

## 6. Petición y respuesta

- Se envía latitud, longitud, el día, las variables y la zona horaria de Madrid.
- La respuesta de la derecha es real, de 8:00 a 8:45.
- Son cuatro lecturas, una cada 15 minutos.

Paso: "Y ahora, por qué una sola lectura no basta."

## 7. Consultar no es actualizar

- Una sola lectura al terminar no representa todo el entrenamiento.
- Con el inicio y el fin cogemos todas las lecturas del tramo.
- Con ellas se calcula media, máximo o suma según la variable.

Paso: "Con las dos fuentes claras, miremos cómo queda el dataset."

## 8. El dataset final

- Naranja es el formulario, con el id y las horas de inicio y fin.
- Azul es el resumen del clima: medias, UV máximo y lluvia total.
- Verde son las columnas del pipeline: lecturas usadas, interpoladas, estado del clima, motivo y estado de calidad.

Paso: "Ahora el camino completo de los datos."

## 9. El pipeline

- Fuentes, ficheros locales, limpieza, cruce por inicio y fin, result_DB y export a CSV y Parquet.
- El proceso periódico reintenta las filas sin clima.
- Todo se guarda en local para no depender de la conexión.

Paso: "Voy etapa por etapa, empezando por la extracción."

## 10. Cómo se extrae

- Formulario: llega al Sheet, un aviso al pipeline con el id y se descarga el CSV.
- API: se piden las lecturas entre inicio y fin y se guardan en DB_API sin repetir.
- Si falla, la fila queda pendiente y se reintenta. Nunca se inventa el dato.

Paso: "Lo siguiente es dónde se guarda todo."

## 11. Almacenamiento

- DB_Form se sobrescribe, pero el Sheet guarda todo.
- DB_API acumula y no repite una lectura con el mismo timestamp y ubicación.
- result_DB acumula y solo añade respuestas con id nuevo.

Paso: "Ahora la parte que más cambió, la calidad de los datos."

## 12. Cuatro problemas de calidad

- Datos exagerados, conexión, valores ausentes y duplicados.
- La corrección fue dar una solución concreta a cada uno.

Paso: "Empiezo por los valores extremos."

## 13. Valores extremos

- Tres pasos: detectar, comprobar, tratar.
- Los límites dependen del deporte.
- 90 km en 45 minutos es imposible. Si se confirma, queda invalido y el original se guarda.
- Un maratón es raro pero real, se queda.
- No se usa la mediana porque falsea el dataset.

Paso: "Y cuando lo que falta es el dato."

## 14. Valores ausentes y conexión

- Temperatura, humedad y viento se interpolan si falta una lectura suelta, y se marca.
- Una interpolación es una estimación, no una medición.
- La lluvia no se interpola porque se inventaría.
- Sin conexión: pendiente, revisión periódica y, si no hay datos, ausente con motivo.

Paso: "Queda el cuarto problema, los duplicados."

## 15. Duplicados

- Mismo timestamp no es duplicado, porque varios usuarios pueden enviar a la vez.
- Cada respuesta tiene el id de Google Forms, único y estable.
- Si el id ya está en result_DB, no se añade otra vez.

Paso: "Ahora juntamos las dos fuentes."

## 16. El cruce temporal

- Cada respuesta se une con todas las lecturas entre el inicio y el fin.
- Media de temperatura, humedad y viento, máximo del UV y suma de la lluvia.
- Se guarda cuántas lecturas se usaron.
- Si no hay, pendiente, se reintenta y, si no, ausente con motivo. La fila no se tira.

Paso: "Todo esto tiene límites."

## 17. Limitaciones y sesgos

- Si la API cae varios días, se completa luego con el histórico.
- Sesgo de muestra: si responden mis conocidos, no representa al deportista medio.
- Sesgo de autoinforme: el esfuerzo del 1 al 10 es subjetivo.

Paso: "¿Y qué mejoraría?"

## 18. Mejoras

- Pulsómetro o smartwatch para tener un dato objetivo.
- Más participantes.
- Alertas de valores raros antes de result_DB.
- Histórico para completar huecos.

Paso: "Para terminar, las conclusiones."

## 19. Conclusiones

- Dataset trazable.
- Respeta la frecuencia de la fuente y usa todo el tramo.
- Calidad sin falsear datos, con el original guardado y lo estimado marcado.
- Límites asumidos. Siguiente paso: implementarlo y ver si el calor influye.

Paso: "Y con esto termino."

## 20. Despedida

- Un formulario, una API de 15 minutos y un pipeline que los une sin inventar nada.
- Gracias y preguntas.

---

## Si te preguntan

- ¿Por qué no la mediana? Porque cambia los datos y falsea el dataset. Mejor marcar y comprobar.
- ¿Por qué no una sola lectura? Porque el tiempo cambia durante el entrenamiento y una lectura no lo representa.
- ¿Por qué hora de inicio y de fin? Para pedir al histórico las lecturas de todo el tramo.
- ¿Cómo se detectan duplicados? Con el id único que da Google Forms a cada respuesta.
- ¿Un valor interpolado es una medición? No, es una estimación y por eso va marcado.
- ¿Hay resultados? No, es un diseño. Los datos reales que se ven son solo de la API.

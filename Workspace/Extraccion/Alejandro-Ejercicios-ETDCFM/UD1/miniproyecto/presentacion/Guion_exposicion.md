# Guion de exposición del miniproyecto UD1

Rendimiento deportivo y condiciones ambientales. Dura unos 9 o 10 minutos, son unas 1.400 palabras a ritmo tranquilo.

Cada diapositiva de contenido lleva unos 30 segundos y el saludo y la despedida algo menos.

> Todo lo que digo sale del miniproyecto. No hay resultados medidos porque el trabajo es un diseño que no se programa, y conviene decirlo claro desde el principio.

---

## Diapositiva 1. Saludo, unos 20 s

Hola a todos, soy Alejandro. Hoy os voy a contar mi miniproyecto de la unidad 1: el diseño de un pipeline que junta lo que la gente cuenta en un formulario sobre sus entrenamientos con el tiempo que hacía en ese momento. Vamos a ver cómo se plantea, cómo se limpian los datos y qué límites tiene.

## Diapositiva 2. El problema, unos 33 s

Todos hemos notado alguna vez que no rendimos igual según el día. Hay días de calor en los que cuesta mucho más. Pero casi nunca se mide. Mi idea era recoger entrenamientos reales de un grupo de deportistas y cruzarlos con el tiempo que hacía justo entonces: temperatura, humedad, viento, índice UV y lluvia. Elegí este proyecto, el B del enunciado, porque es el que más se parece a mi vida diaria.

## Diapositiva 3. Qué se pide, unos 33 s

Lo que se pide es juntar dos fuentes distintas. Una es un formulario de Google, que se va llenando poco a poco, y la otra es una API del tiempo que se renueva cada 15 minutos. El resultado es un dataset con una fila por entrenamiento y su clima. Una aclaración importante: es un diseño sobre el papel, no se programa. Por eso no voy a enseñar resultados medidos, sino decisiones y por qué las tomé.

## Diapositiva 4. El formulario, unos 32 s

Empiezo por el formulario. Pregunta el nombre, la edad, el deporte, la hora de inicio y la de fin del entrenamiento, la duración, la distancia y el esfuerzo percibido del uno al diez. He añadido las dos horas porque el formulario se puede enviar un rato después de entrenar, y son las que sirven para buscar el clima. Cada respuesta cae en un Google Sheet y un Apps Script avisa al pipeline y guarda el id de la respuesta. Todos los campos son obligatorios y con rangos validados.

## Diapositiva 5. La API, unos 32 s

La segunda fuente es Open-Meteo. Es una API REST pública que responde en JSON, y no hace falta clave. Antes tenía puesto NdJSON y que necesitaba autenticación, y eso estaba mal. Lo importante es que sus datos se renuevan cada 15 minutos. Le pedimos cinco variables: temperatura, humedad, viento, UV y precipitación. Para el tramo del entrenamiento usamos también su histórico, que da lecturas de 15 minutos de días pasados.

## Diapositiva 6. Petición y respuesta, unos 32 s

Aquí se ve la petición al histórico. Lleva la latitud y longitud de Granada, el día del entrenamiento, las variables que queremos y la zona horaria de Madrid, para que las horas coincidan con las del formulario. A la derecha está una respuesta real, recortada a las lecturas de las 8:00 a las 8:45. Son cuatro lecturas, una cada 15 minutos. Fijaos en que la humedad viene en enteros y el resto con decimales.

## Diapositiva 7. Consultar no es actualizar, unos 35 s

Esta es una de las cosas importantes. Una sola lectura al terminar no representa todo el entrenamiento, porque el tiempo puede cambiar mientras entrenas. En el gráfico, con datos reales de Granada, se ve que la temperatura sube durante esa franja. Por eso, con la hora de inicio y la de fin, nos quedamos con todas las lecturas del tramo. Y con ellas calculamos una media, un máximo o una suma, según la variable.

## Diapositiva 8. El dataset final, unos 32 s

Así queda el dataset. En naranja lo que viene del formulario, ahora con el id de la respuesta y las horas de inicio y fin. En azul el resumen del clima del tramo: media de temperatura, humedad y viento, máximo del UV y suma de la lluvia. Y en verde las columnas del pipeline: cuántas lecturas se usaron, si alguna está estimada, el estado del clima con su motivo y el estado de calidad del dato.

## Diapositiva 9. El pipeline, unos 32 s

Este es el recorrido completo. El formulario y la API se guardan primero en ficheros locales, DB_Form y DB_API. Después pasan por la limpieza y luego por el cruce, que usa el inicio y el fin del entrenamiento. El resultado va a result_DB y de ahí se exporta en CSV y Parquet. Abajo a la izquierda está el proceso periódico, que reintenta las filas a las que les faltó el clima. Todo en local evita depender de la conexión.

## Diapositiva 10. Cómo se extrae, unos 33 s

El formulario se extrae cuando llega la respuesta: queda en el Sheet, un script de Google avisa al pipeline y guarda el id, y se descarga el CSV. Con la API, el pipeline pide las lecturas de 15 minutos entre el inicio y el fin, y las guarda en DB_API sin repetir ninguna. Si falla la llamada, la fila queda pendiente y un proceso periódico lo reintenta. Nunca se inventa el valor.

## Diapositiva 11. Almacenamiento, unos 32 s

Aquí revisé qué se sobrescribe y qué no. DB_Form es una copia entera del CSV y se sobrescribe, pero no se pierde nada porque el Sheet acumula todas las respuestas. DB_API acumula las lecturas, pero no guarda dos veces la misma si coinciden su timestamp y su ubicación. Y result_DB acumula una fila por entrenamiento, y solo añade las respuestas con un id nuevo. Las filas pendientes se completan más adelante.

## Diapositiva 12. Cuatro problemas de calidad, unos 32 s

Ahora la tabla de calidad, que es el otro punto que me corrigieron. Hay cuatro problemas: valores exagerados en el formulario, problemas de conexión con la API, valores ausentes y respuestas duplicadas. La corrección fue que cada uno tuviera una solución concreta y no frases vagas como se imputan. Los voy viendo uno por uno.

## Diapositiva 13. Valores extremos, unos 35 s

En los valores extremos yo ponía que se cambiaban por la mediana, y eso falsea el dataset. Ahora son tres pasos. Primero detectar, con límites distintos para cada deporte, porque lo razonable corriendo no vale para ciclismo. Después comprobar si es imposible o solo raro, y mientras tanto queda como sospechoso. Noventa kilómetros en cuarenta y cinco minutos son 120 por hora corriendo, imposible. Si se confirma, queda como inválido en el dataset limpio, pero el dato original no se borra. Un maratón es raro pero real, así que se queda.

## Diapositiva 14. Valores ausentes y conexión, unos 35 s

Con los ausentes, lo de se imputan no decía cómo. Depende de la variable. Temperatura, humedad y viento cambian poco en 15 minutos, así que si falta una lectura suelta se interpola, y se apunta en una columna para no confundirla con una medición real. La lluvia no se interpola porque inventaría lluvia. Si no hay conexión, la fila queda pendiente y un proceso, por ejemplo cada hora, vuelve a pedir su tramo. Si tras unos días no hay datos, queda ausente con su motivo.

## Diapositiva 15. Duplicados, unos 32 s

Antes eliminaba dos respuestas por tener el mismo timestamp, y eso es un error, porque varias personas pueden enviar el formulario a la vez. Ahora cada respuesta tiene el id que le da Google Forms, que es único y no cambia. El Apps Script lo guarda junto a la respuesta. Si llega un id que ya está en result_DB, no se añade otra vez. Dos respuestas con el mismo timestamp pero distinto id se mantienen las dos.

## Diapositiva 16. El cruce temporal, unos 35 s

Ahora el cruce. Como las lecturas son cada 15 minutos, a cada respuesta le asociamos todas las que caen entre la hora de inicio y la de fin. En el ejemplo, de 8:00 a 8:45, son cuatro. Con ellas se calcula la media, el máximo o la suma, y se guarda cuántas se han usado. Si no hay lecturas, la fila queda pendiente y se reintenta, y si al final no se consigue, queda ausente con su motivo pero no se tira.

## Diapositiva 17. Limitaciones y sesgos, unos 35 s

Pasamos a las limitaciones, que es el apartado que el profesor dijo que estaba muy bien. Si la API cayera varios días, esas filas quedarían sin clima y se completarían después con el histórico de Open-Meteo, mientras que el formulario no pierde nada. Después están los sesgos. El de muestra: si responden mis conocidos, el dataset no representa al deportista medio. Y el de autoinforme: el esfuerzo percibido es subjetivo y cada persona lo valora distinto.

## Diapositiva 18. Mejoras, unos 32 s

Con más recursos haría cuatro cosas. Añadiría un pulsómetro o un smartwatch conectado por API, para tener un dato objetivo y no depender solo del esfuerzo percibido. Ampliaría el número de participantes para que la muestra sea más representativa. Pondría alertas para avisar de valores imposibles antes de que entren en result_DB. Y usaría el histórico de Open-Meteo para completar los huecos, indicándolo siempre en el estado del dato.

## Diapositiva 19. Conclusiones, unos 32 s

Como conclusiones, me quedo con cuatro ideas. Primero, un dataset trazable, donde cada fila dice de dónde sale su clima. Segundo, que respeta la fuente: Open-Meteo cambia cada 15 minutos y usamos todas las lecturas del entrenamiento, no una sola. Tercero, calidad sin falsear, marcando y comprobando, con el dato original siempre guardado y lo estimado señalado. Y cuarto, asumir los límites. El siguiente paso sería implementarlo y ver con datos reales si el calor influye.

## Diapositiva 20. Despedida, unos 15 s

Y hasta aquí mi miniproyecto: un formulario, una API que se actualiza cada 15 minutos y un pipeline que los une sin inventar nada. Muchas gracias por escucharme, ¿alguna pregunta?


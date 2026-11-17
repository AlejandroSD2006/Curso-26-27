# REVISIÓN Y MEJORA DEL MINIPROYECTO UD1 + CREACIÓN DE PRESENTACIÓN

Quiero que revises y mejores mi miniproyecto de la UD1 de la asignatura de Extracción de Datos. Además, quiero que prepares una presentación en PDF para poder exponer el proyecto en clase.

**IMPORTANTE: No quiero que rehagas el proyecto desde cero.** Quiero que partas de mi trabajo actual, respetes su estructura y mejores los aspectos que realmente necesitan corrección.

## 1. ANÁLISIS PREVIO DEL PROYECTO

Antes de modificar nada:

- Revisa todos los archivos del proyecto y localiza el miniproyecto correspondiente a la UD1.
- Identifica los notebooks `.ipynb` que forman parte de este miniproyecto.
- Examina también otros notebooks que haya realizado anteriormente y que estén completados por mí.
- Utiliza estos otros notebooks como referencia para conocer mi forma habitual de escribir, explicar conceptos, responder preguntas, comentar código y presentar resultados.

Quiero que mantengas mi estilo personal de trabajo.

Evita:
- Explicaciones excesivamente formales o artificiales.
- Párrafos demasiado largos que parezcan sacados de un manual.
- Expresiones genéricas típicas de respuestas generadas por IA.
- Estructuras repetitivas en todos los apartados.
- Utilizar tecnicismos innecesarios cuando pueda explicarse algo de forma más natural.

No quiero que el resultado sea deliberadamente peor ni que se elimine contenido técnico importante. Quiero que siga siendo un trabajo correcto, pero que conserve la naturalidad y el nivel de profundidad de mis otros notebooks.

## 2. CORRECCIÓN DEL FEEDBACK DEL PROFESOR

El profesor ha revisado el proyecto y ha señalado lo siguiente:

"La tabla de calidad tiene 4 problemas, pero las soluciones son vagas o discutibles: llevar los datos exagerados a la mediana falsea el dataset, «imputar» no dice cómo, y hablas del «dato de hace 5 segundos» cuando la API se actualiza cada 15 minutos. El apartado 4 está muy bien: completar los huecos con el histórico de Open-Meteo, el sesgo de muestra y el de autoinforme, y añadir un pulsómetro."

Quiero que prestes especial atención a estas observaciones.

### 2.1. Tabla de calidad de los datos

Revisa los cuatro problemas identificados en la tabla de calidad.

Para cada uno:
- Comprueba que el problema esté correctamente identificado.
- Explica por qué supone un problema para el análisis.
- Propón una solución concreta y técnicamente razonable.
- Indica cómo se aplicaría esa solución.
- Evita soluciones genéricas que no expliquen realmente qué se haría con los datos.

En particular:

**Valores exagerados o extremos:**
No sustituyas automáticamente los valores extremos por la mediana, porque eso puede alterar artificialmente la distribución del dataset.

Distingue entre valores extremos reales y errores de medición. Propón cómo detectarlos, comprobarlos y tratarlos sin modificar injustificadamente los datos originales. Si planteas alguna transformación, justifica cuándo tendría sentido aplicarla.

**Valores ausentes:**
No te limites a decir que se deben imputar.

Explica qué método utilizarías, por qué sería adecuado y en qué circunstancias lo aplicarías. Ten en cuenta el tipo de variable, la cantidad de valores ausentes y el contexto de los datos.

**Frecuencia de actualización de la API:**
Revisa cualquier referencia a que se obtiene un dato cada cinco segundos.

La API utilizada se actualiza cada 15 minutos, por lo que debes corregir cualquier explicación que no respete esta frecuencia. Diferencia correctamente entre la frecuencia de actualización de la fuente y el momento en el que nuestro programa consulta o recibe los datos.

Revisa también los otros problemas de la tabla para que las cuatro propuestas queden bien justificadas.

### 2.2. Apartado 4

El profesor ha indicado expresamente que este apartado está muy bien.

Quiero que conserves sus ideas principales y su planteamiento, evitando modificarlo innecesariamente.

Mantén especialmente:

- Completar los huecos de información utilizando datos históricos de Open-Meteo.
- Explicar el sesgo de selección o de muestra.
- Explicar el sesgo de autoinforme.
- Proponer la incorporación de un pulsómetro para obtener mediciones más objetivas.

Puedes mejorar la redacción o añadir alguna precisión técnica si realmente aporta valor, pero no elimines estos elementos ni cambies el enfoque que ya está bien planteado.

## 3. REVISIÓN GENERAL DEL MINIPROYECTO

Una vez corregidos los aspectos anteriores:

- Comprueba que no existan contradicciones entre diferentes apartados.
- Revisa que las soluciones propuestas sean técnicamente viables.
- Comprueba que las explicaciones coincidan con el funcionamiento real de las fuentes de datos y las API utilizadas.
- Revisa la coherencia entre los datos obtenidos, su tratamiento y las conclusiones.
- Mantén los ejemplos, código y decisiones originales siempre que sean correctos.
- Comprueba que los notebooks sigan ejecutándose correctamente y que no se hayan roto celdas, referencias o resultados.

No inventes resultados, pruebas ni datos que no se hayan obtenido realmente.

Conserva los archivos originales cuando sea posible y deja claro qué archivos corresponden a la versión corregida.

## 4. CREACIÓN DE LA PRESENTACIÓN EN PDF

Además de corregir el miniproyecto, quiero que prepares una presentación para exponerlo en clase.

La presentación debe tener:

- 18 diapositivas de contenido.
- Una diapositiva inicial de saludo o presentación.
- Una diapositiva final de despedida y cierre.

Por tanto, serán 20 diapositivas en total.

La presentación debe explicar los aspectos más importantes del miniproyecto, siguiendo un orden lógico y utilizando información que realmente aparezca en el trabajo.

No quiero que se limite a resumir los apartados uno detrás de otro. Debe contar el desarrollo del proyecto de manera que alguien que no lo conozca pueda entenderlo.

Incluye, según corresponda:

- Introducción y objetivo del proyecto.
- Problema que se pretende resolver.
- Origen y características de los datos.
- Proceso de extracción.
- Funcionamiento de las API utilizadas.
- Obtención y estructura de los datos.
- Limpieza y preparación.
- Problemas de calidad detectados.
- Tratamiento de valores ausentes y extremos.
- Limitaciones de los datos.
- Sesgos identificados.
- Propuestas de mejora.
- Resultados y conclusiones.

Adapta estos contenidos a lo que realmente se haya desarrollado en el miniproyecto. No añadas apartados ficticios para rellenar diapositivas.

### Diseño visual

Quiero una presentación visualmente atractiva, moderna y cuidada, pero apropiada para una exposición académica.

Características:
- Diseño limpio y coherente.
- Buena combinación de colores.
- Tipografía legible.
- Jerarquía visual clara.
- Diagramas, esquemas y gráficos cuando aporten información.
- Evitar diapositivas saturadas de texto.
- Evitar plantillas corporativas genéricas.
- Evitar que todas las diapositivas tengan exactamente la misma composición.
- Utilizar imágenes o elementos visuales relacionados con el proyecto cuando tenga sentido.

La presentación debe parecer elaborada específicamente para este trabajo, no una plantilla genérica generada automáticamente.

No inventes gráficos ni cifras. Utiliza únicamente información que esté respaldada por el proyecto.

### Duración y exposición

Quiero que la presentación permita realizar una exposición de aproximadamente 8-10 minutos.

Prepara también un guion para cada diapositiva con lo que debería explicar oralmente.

El guion debe:
- Estar escrito con un lenguaje natural y fácil de exponer.
- Seguir mi estilo habitual de expresión.
- No limitarse a leer literalmente el contenido de las diapositivas.
- Explicar los conceptos importantes con claridad.
- Incluir transiciones naturales entre diapositivas.

Intenta que cada diapositiva tenga una explicación de aproximadamente 30-35 segundos para ajustar la duración total a los 8-10 minutos, sin contar demasiado tiempo en el saludo y la despedida.

Guarda el guion en un archivo independiente.

## 5. ARCHIVOS QUE QUIERO OBTENER

Organiza los resultados de forma clara y entrega:

1. Los notebooks de la UD1 corregidos.
2. Una presentación en PDF con las 20 diapositivas.
3. Si es posible, el archivo editable de la presentación en PPTX.
4. Un documento independiente con el guion de exposición, organizado por número de diapositiva.
5. Un breve resumen de los cambios realizados en el miniproyecto, indicando qué observaciones del profesor se han corregido.

Antes de finalizar, comprueba que:
- Los notebooks funcionan correctamente.
- El PDF se abre y todas las diapositivas se visualizan bien.
- No hay elementos cortados, textos ilegibles ni errores de diseño.
- El número de diapositivas es el solicitado.
- El guion coincide con el contenido de la presentación.
- La duración estimada es coherente con el tiempo solicitado.

**Prioridad absoluta:** mantener la esencia de mi trabajo original, corregir de verdad los errores señalados por el profesor y conseguir una presentación clara, natural y visualmente atractiva.

## 6. OBSERVACIONES ADICIONALES DETECTADAS AL REVISAR EL NOTEBOOK

Además de las correcciones indicadas por el profesor, revisa los siguientes aspectos que pueden afectar a la coherencia técnica del proyecto.

### Fuente meteorológica

En la ficha de la API hay información que debe comprobarse y corregirse:

- El proyecto utiliza Open-Meteo Forecast API.
- El formato de respuesta debe describirse correctamente como JSON, no NdJSON.
- No se necesita autenticación mediante clave API.
- La actualización de los datos debe explicarse teniendo en cuenta la frecuencia de 15 minutos.
- Completa la URL del endpoint utilizado.
- Comprueba qué parámetros necesita la petición, especialmente las coordenadas geográficas, las variables solicitadas y la configuración horaria.

No confundas la frecuencia con la que consultamos la API con la frecuencia con la que se actualizan sus datos.

### Esquema del dataset

Comprueba que los tipos de datos definidos sean coherentes con las respuestas reales de la API.

Por ejemplo, algunas variables meteorológicas admiten decimales, por lo que no deberían definirse necesariamente como enteros.

Revisa también que el ejemplo de fila incluya tanto los datos del formulario como los meteorológicos.

### Duplicados

No elimines automáticamente dos respuestas por compartir timestamp. Puede haber varios usuarios rellenando el formulario al mismo tiempo.

Propón un criterio de identificación de duplicados más fiable, utilizando un identificador único de respuesta o una combinación de campos que permita detectar registros realmente repetidos.

### Coherencia del almacenamiento

Revisa la explicación de DB_Form, DB_API y result_DB.

Comprueba que la política de sobrescritura y acumulación de los ficheros sea coherente con el funcionamiento descrito del pipeline y que no se pierdan respuestas ni datos históricos.

### Cruce temporal

Explica correctamente cómo se asocia cada entrenamiento con su lectura meteorológica.

Ten en cuenta que la API se actualiza cada 15 minutos y que el timestamp de una respuesta no tiene por qué coincidir exactamente con el de la lectura meteorológica.

Establece un criterio razonable de antigüedad máxima para aceptar una lectura. Si no existe ninguna suficientemente cercana, intenta recuperar el dato histórico de Open-Meteo o conserva el valor como ausente, indicando el motivo.

No inventes lecturas ni utilices datos antiguos sin comprobar su validez.

### Estilo de redacción

Utiliza como referencia principal las respuestas que ya he escrito en UD1_Ejercicios.ipynb.

Quiero mantener:
- Explicaciones directas y naturales.
- Justificaciones sencillas pero suficientes.
- Un lenguaje técnico propio de un estudiante de la asignatura.
- Respuestas con una extensión razonable, sin desarrollar innecesariamente cada idea.

No conviertas todas las respuestas en textos académicos excesivamente elaborados. Mantén mi forma de explicar las cosas, mejorando la precisión y la claridad donde sea necesario.

No añadas errores deliberadamente ni sacrifiques contenido técnico para intentar imitar mi estilo.
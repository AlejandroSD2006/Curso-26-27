# Resumen de cambios del miniproyecto UD1

El notebook corregido es `UD1_Miniproyecto_B4_corregido.ipynb`. El original no se ha tocado. La presentación y los guiones están en la carpeta `presentacion`.

## Correcciones del profesor

- Datos exagerados: el dato original se conserva siempre. Se detectan con límites por deporte, se marcan como sospechosos y, si se confirma el error, quedan como invalidos en el dataset limpio sin perder su procedencia. No se usa la mediana.
- Valores ausentes: se explica por variable. Temperatura, humedad y viento se interpolan si falta una lectura suelta. La lluvia no se interpola.
- Frecuencia de la API: se distingue entre la actualización de la fuente, cada 15 minutos, y nuestras consultas.
- Apartado 4: igual que antes. Solo se ha quitado la frase sobre usar el último valor guardado de DB_API, porque ya no se reutilizan lecturas de otro momento.

## Última revisión

- Duración: el formulario recoge hora de inicio y de fin. Con ellas se piden al histórico de Open-Meteo todas las lecturas de 15 minutos del tramo y se calcula media, máximo o suma. Ya no se usa una sola lectura.
- DB_API: guarda las lecturas obtenidas sin repetir una que coincida en timestamp y ubicación.
- Duplicados: se usa el id que da Google Forms a cada respuesta. Se quita el criterio de usuario, campos y cinco minutos.
- Reintentos: un proceso periódico revisa las filas pendientes y, si no hay datos tras unos días, las deja como ausentes con su motivo.
- Interpolación: es una estimación y se apunta en la columna Variables_interpoladas.
- Esquema y ejemplo de fila actualizados con las columnas nuevas.
- Se ha quitado la nota de versión de la primera celda del notebook.

## Comprobaciones

- Los parámetros y la respuesta de Open-Meteo, incluido el histórico con `minutely_15`, se comprobaron con llamadas reales.
- El notebook se ejecutó entero sin errores.
- El gráfico y la respuesta de la presentación usan datos reales de Granada del 1 de octubre de 2026. El horario del entrenamiento y la fila de ejemplo son inventados y están marcados como ejemplo.

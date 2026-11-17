# Guion de presentación: Alejandro

Cubre las diapositivas 1-4 y 8-15. Las diapositivas 5-7 las presenta Mario. Duración total aproximada: 7-8 minutos.

---

## Diapositiva 1: Portada (~30 s)

> "Buenos días. Somos Mario Hernández y Alejandro Suárez, y vamos a presentar nuestra práctica. El proyecto se llama *¿Qué habría pasado si…?*.
>
> La práctica pedía hacer **dos aplicaciones equivalentes** para una misma necesidad. La App 1 la construimos a mano, poco a poco. La App 2 la especificamos primero con Spec Kit, la protegimos con Clerk y la preparamos para desplegarla con Docker en AWS."

## Diapositiva 2: El objetivo de la práctica (~45 s)

> "El objetivo tiene tres ideas.
>
> Primera, **una necesidad real**: imaginar cómo habría cambiado la historia si un hecho hubiera ocurrido de otra manera.
>
> Segunda, **dos aplicaciones equivalentes**. Hacen lo mismo y tienen el mismo contrato de entrada y salida, pero se construyen con procesos distintos.
>
> Tercera, **un proceso que todos podamos explicar**. Cada decisión queda documentada y cualquiera de los dos puede defenderla. Así podemos comparar con evidencias y no con opiniones."

## Diapositiva 8: Aplicación 2, la misma idea con una identidad verificada (~1 min)

> "Gracias. Paso a la **Aplicación 2**. Sin control de acceso, cualquiera podría agotar nuestras peticiones a la IA. Por eso la App 2 resuelve la misma necesidad, pero **verifica la identidad antes de generar nada**.
>
> Tiene tres objetivos medibles:
>
> - **OBJ-01**: con una sesión válida y datos correctos, aparecen la narración y entre 3 y 5 consecuencias.
> - **OBJ-02**: cualquier envío sin un token válido de Clerk recibe un error **401** y nunca llega a la IA.
> - **OBJ-03**: sigue siendo una sola pantalla, sin memoria propia. No se guarda nada tras cerrar sesión o recargar."

## Diapositiva 9: Cómo funciona por dentro (~1 min)

> "Aquí está la arquitectura. A la izquierda, el **cliente**: el usuario abre la app, inicia sesión con Clerk, integrado en la misma pantalla, y rellena el formulario en Vue.
>
> A la derecha, el **servidor**: una API en FastAPI que **primero verifica el token** y solo después llama a OpenRouter.
>
> Lo más importante es que, **sin un token válido de Clerk, la petición nunca llega a OpenRouter**. Además, las claves secretas viven solo en el backend y el navegador nunca las ve."

## Diapositiva 10: Documentos primero, código después (~1 min)

> "La App 2 la construimos con **GitHub Spec Kit**, que obliga a escribir los documentos antes que el código. Las fases fueron:
>
> - **Constitución**: las reglas que no se pueden romper, como alcance, stack, seguridad e idioma.
> - **Specify y clarify**: la especificación con historias de usuario y tres aclaraciones resueltas.
> - **Plan**: las tecnologías y la arquitectura.
> - **Tasks y analyze**: 33 tareas pequeñas y una revisión de coherencia.
> - **Implement**: el código, con pruebas.
>
> Entre cada paso **parábamos a revisar** el documento antes de seguir. La IA nos ayudó a escribir más rápido, pero las decisiones las tomamos nosotros."

## Diapositivas 11 y 12: Requisitos funcionales y no funcionales (~1 min)

> "Esto está recogido en la ERS. Tenemos **ocho requisitos funcionales**: escribir la pregunta, elegir año y estilo, iniciar y cerrar sesión con Clerk, generar el escenario autenticado, bloquear envíos duplicados y mostrar errores comprensibles.
>
> Y **seis no funcionales**. Los más relevantes:
>
> - La **seguridad**: el token se verifica de verdad y las claves solo están en el backend.
> - La **validación también en el servidor**.
> - El **timeout de 25 segundos** para la IA.
> - La **no persistencia**: ni `localStorage` ni base de datos.
> - El **despliegue completo con Docker Compose** en una instancia EC2."

## Diapositiva 13: Seguridad y errores, por contrato (~45 s)

> "Cada fallo tiene un código HTTP definido:
>
> - **401**: sin token válido de Clerk, y no se llama a la IA.
> - **422**: pregunta, año o estilo fuera de los límites.
> - **502**: fallo del proveedor de IA o respuesta inutilizable.
> - **504**: tiempo de espera agotado a los 25 segundos.
>
> El usuario ve un mensaje claro en español y el backend **nunca expone trazas, tokens ni la respuesta completa del proveedor**."

## Diapositiva 14: Lo validamos con pytest (~45 s)

> "Para comprobarlo tenemos **40 pruebas automáticas y las 40 pasan**. Cubren los límites de pregunta, año y estilo, la autenticación (sin token, token inválido o caducado), el flujo completo autorizado con una única llamada a la IA, y los fallos del proveedor, con sus 502 y 504.
>
> Estas pruebas **sustituyen Clerk y OpenRouter por dobles de prueba**, así que no consumen créditos de IA ni necesitan red ni credenciales."

## Diapositiva 15: Una instancia EC2, tres contenedores (~1 min)

> "Por último, el despliegue. Con **Docker Compose** levantamos **tres contenedores**: el **backend** con FastAPI y Uvicorn, el **frontend** con Vue ya compilado, y **Caddy** como proxy, que da HTTPS automático. Está pensado para una **instancia EC2 de AWS**, con la URL prevista `whatif.casacam.net`.
>
> Siendo transparentes: la configuración de Docker Compose está lista y validada en local, pero **crear la instancia EC2 y desplegar es nuestro siguiente paso**. Tampoco hemos probado todavía un inicio de sesión real de Clerk de extremo a extremo, solo con dobles de prueba. Lo cerraremos antes de la demo."

*(Aquí pasa la palabra Mario, o continúas tú con las diapositivas 16-20 si lo acordáis.)*

---

## Detalles a vigilar

- La diapositiva 15 dice que Docker Compose está "probado en local", pero lo único que validamos fue `docker compose config`, no un `up` completo. Si preguntan, la configuración está validada y el arranque real queda pendiente.
- Si para la demo ya tenéis la EC2 y Clerk funcionando, actualiza esa parte del guion y la diapositiva 18 (pendientes).

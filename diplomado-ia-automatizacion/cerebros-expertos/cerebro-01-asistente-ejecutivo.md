# Cerebro Experto: Asistente Ejecutivo y Productividad Personal
> Diplomado IA & Automatización — Sprint 1
> Vertical: Operaciones / Productividad Personal

---

## ¿Qué es un Asistente Ejecutivo?

Un asistente ejecutivo es la persona (o sistema) responsable de gestionar el tiempo, la comunicación y la agenda de una persona o equipo dentro de una organización. Su trabajo no es producir resultados directos, sino **eliminar fricción** para que quien toma decisiones pueda enfocarse en lo que importa.

En empresas pequeñas y medianas de México, este rol frecuentemente lo asume el mismo dueño, director o gerente — sin apoyo humano dedicado. Eso significa que las personas con mayor capacidad de decisión pierden horas semanales en tareas administrativas de bajo valor.

---

## ¿Qué hace esta área en una empresa?

### Gestión de agenda y calendario
- Programar, mover y cancelar reuniones
- Coordinar disponibilidad entre múltiples personas
- Enviar recordatorios previos a compromisos importantes
- Bloquear tiempo para trabajo profundo (deep work)

### Gestión de comunicación
- Filtrar y priorizar correos entrantes
- Redactar respuestas a mensajes rutinarios
- Hacer seguimiento a conversaciones sin respuesta
- Distribuir información a los destinatarios correctos

### Gestión de tareas y seguimiento
- Registrar compromisos verbales como tareas formales
- Hacer seguimiento a pendientes delegados
- Preparar resúmenes diarios o semanales de actividad
- Recordar fechas límite y entregas

### Coordinación logística
- Reservar salas de reunión o espacios de trabajo
- Coordinar viajes, traslados y hospedaje
- Preparar materiales para reuniones (agendas, presentaciones)
- Gestionar gastos de representación

---

## Procesos repetitivos típicos (candidatos a automatizar)

Estos son los procesos que se repiten con mayor frecuencia y menor variación — exactamente donde la automatización genera más valor.

### 1. Agendado de reuniones por solicitud verbal o por mensaje
Alguien dice "necesito reunirme contigo el martes" o escribe un mensaje de voz. El proceso manual implica: escuchar/leer el mensaje, revisar el calendario, proponer horario, confirmar, crear el evento, enviar invitación.

**Automatizable:** Transcribir el audio, extraer la intención, verificar disponibilidad en el calendario, crear el evento y confirmar — todo sin intervención humana.

### 2. Recordatorios de compromisos próximos
Revisar la agenda cada mañana y enviar recordatorios personalizados a cada participante antes de una reunión o entrega.

**Automatizable:** Trigger diario que lee el calendario, filtra eventos del día/semana y envía mensajes de recordatorio por el canal preferido (Telegram, WhatsApp, correo).

### 3. Registro de tareas desde conversaciones
En reuniones o llamadas se generan compromisos verbales ("yo me encargo de eso para el viernes"). Documentarlos manualmente en un sistema de tareas requiere disciplina y tiempo.

**Automatizable:** Transcribir la conversación, identificar compromisos con IA, crear tareas automáticamente en el sistema de gestión correspondiente.

### 4. Resumen diario de agenda y pendientes
Cada mañana, revisar el calendario del día, los correos sin respuesta y las tareas vencidas, y consolidar un resumen accionable.

**Automatizable:** Trigger matutino que consulta calendario, correo y gestor de tareas, genera un resumen con IA y lo entrega por el canal preferido.

### 5. Respuestas automáticas a solicitudes frecuentes
Preguntas como "¿cuál es tu disponibilidad esta semana?" o "¿me puedes pasar los datos de facturación?" se repiten constantemente.

**Automatizable:** Detectar la intención del mensaje, consultar la información relevante y responder automáticamente con los datos correctos.

---

## ¿Qué datos maneja esta área?

### Datos de entrada (inputs)
- Mensajes de texto o voz (Telegram, WhatsApp, correo)
- Eventos del calendario (Google Calendar, Outlook)
- Listas de tareas y pendientes
- Contactos y sus preferencias de comunicación
- Archivos de referencia (documentos, presentaciones, datos)

### Datos de salida (outputs)
- Confirmaciones de reuniones
- Recordatorios personalizados
- Resúmenes de agenda
- Tareas creadas en sistemas externos
- Respuestas a solicitudes frecuentes

### Sistemas donde vive esta información
- **Google Calendar / Outlook**: Agenda y eventos
- **Gmail / Outlook Mail**: Comunicación escrita
- **Notion / Asana / Trello**: Gestión de tareas
- **Telegram / WhatsApp**: Comunicación rápida
- **Google Contacts**: Directorio de personas

---

## Conexión con otras áreas de la organización

El asistente ejecutivo es el **nodo central** de comunicación — recibe solicitudes de todas las áreas y coordina con todas ellas.

- **Con Ventas**: Agenda llamadas con prospectos, hace seguimiento a propuestas
- **Con Operaciones**: Coordina entregas, reuniones de seguimiento de proyectos
- **Con Finanzas**: Gestiona aprobaciones de gastos, coordina cierres de mes
- **Con RRHH**: Agenda entrevistas, coordina onboarding de nuevos empleados
- **Con Dirección**: Prepara materiales para reuniones estratégicas, gestiona agenda ejecutiva

---

## Casos reales de automatización en este contexto

### Caso 1: Bot de agendado por voz en Telegram
**Situación:** Un director de operaciones recibe 15-20 solicitudes de reunión por semana vía mensajes de voz en Telegram. Revisar cada audio, coordinar horarios y crear eventos le tomaba 45 minutos diarios.

**Solución automatizada:**
1. El bot recibe el audio en Telegram
2. Whisper transcribe el mensaje de voz a texto
3. GPT extrae: participantes, fecha/hora propuesta, tema de la reunión
4. Se verifica disponibilidad en Google Calendar
5. Si hay disponibilidad: se crea el evento, se invita a los participantes, se confirma por Telegram
6. Si no hay disponibilidad: el bot propone tres horarios alternativos

**Resultado:** El director solo interviene cuando hay conflicto de agenda (menos del 20% de los casos).

### Caso 2: Resumen matutino automatizado
**Situación:** Cada mañana un emprendedor necesitaba revisar su correo, su calendario y sus tareas pendientes en tres herramientas diferentes para planear su día.

**Solución automatizada:**
1. Trigger a las 7:00 AM todos los días hábiles
2. El flujo consulta Google Calendar (reuniones del día)
3. Consulta Gmail (correos sin leer marcados como importantes)
4. Consulta Notion (tareas vencidas o con vencimiento hoy)
5. GPT genera un resumen ejecutivo con prioridades del día
6. Se envía como mensaje de Telegram con formato claro

**Resultado:** En 30 segundos el emprendedor tiene el contexto completo de su día, sin abrir ninguna aplicación.

### Caso 3: Recordatorios inteligentes previos a reuniones
**Situación:** Los participantes llegaban frecuentemente sin leer los materiales previos o sin recordar el objetivo de la reunión.

**Solución automatizada:**
1. Trigger 24 horas y 1 hora antes de cada reunión
2. El flujo lee la descripción del evento en el calendario
3. GPT genera un recordatorio personalizado con: objetivo, participantes, materiales relevantes y punto de reunión
4. Se envía por Telegram a cada participante

---

## Métricas clave de esta área

Para evaluar si una automatización de productividad está funcionando, medir:

- **Tiempo de respuesta a solicitudes de agenda** (objetivo: menos de 5 minutos vs. el promedio actual)
- **Porcentaje de reuniones que inician a tiempo** (indicador de calidad del recordatorio)
- **Tareas capturadas automáticamente vs. manualmente** (adopción del sistema)
- **Horas semanales recuperadas** por el ejecutivo principal

---

## Preguntas frecuentes para explorar en este contexto

- ¿Qué porcentaje del tiempo del dueño o director se va en coordinación vs. decisión?
- ¿Cuántos mensajes de voz recibe por día que requieren una acción concreta?
- ¿Qué herramienta de calendario usa actualmente el equipo?
- ¿Tiene Telegram instalado? ¿Lo usa para trabajo?
- ¿Qué pasa cuando no hay quien maneje la agenda? ¿Se pierden compromisos?

---

## Vocabulario clave del área

| Término | Significado |
|---|---|
| Deep work | Trabajo de alta concentración sin interrupciones |
| Time blocking | Técnica de reservar bloques de tiempo en el calendario para tareas específicas |
| Follow-up | Seguimiento a una conversación o compromiso pendiente |
| Briefing | Resumen de información antes de una reunión o evento |
| Stakeholder | Persona con interés o participación en un proyecto o decisión |
| Bandwidth | Capacidad disponible de una persona para asumir trabajo adicional |

---

## Prompts sugeridos para estudiar con este cerebro

Puedes preguntarle a este notebook:
- "¿Cuáles son los 3 procesos de gestión de agenda más comunes en una empresa pequeña mexicana?"
- "¿Cómo debería diseñar un flujo para que un bot entienda cuando alguien quiere agendar una reunión por voz?"
- "¿Qué información necesita un sistema automatizado para crear correctamente un evento en el calendario?"
- "Dame un ejemplo de un resumen matutino bien estructurado para un director de empresa"
- "¿Qué procesos de productividad personal NO conviene automatizar y por qué?"

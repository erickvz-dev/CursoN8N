# Cerebro Experto: Ventas, CRM y Automatización Comercial
> Diplomado IA & Automatización — Sprint 7
> Vertical: Ventas / CRM / WhatsApp Business

---

## ¿Qué es el área de Ventas?

Ventas es el área responsable de convertir prospectos (personas interesadas) en clientes (personas que pagan). Es la función que genera los ingresos de la empresa — sin ventas, no hay empresa.

En México, la mayoría de las empresas venden de forma muy artesanal: el vendedor gestiona su cartera de clientes en su cabeza o en una hoja de Excel, hace seguimiento de forma reactiva (cuando recuerda), y pierde muchas oportunidades porque no hay un proceso sistemático.

La automatización de ventas no reemplaza al vendedor humano — **lo hace más efectivo** al eliminar las tareas administrativas y asegurar que ningún prospecto se quede sin atención.

---

## ¿Qué hace esta área en una empresa?

### Prospección
- Identificar y contactar a potenciales clientes
- Calificar si un prospecto tiene la necesidad, el presupuesto y la autoridad para comprar
- Generar listas de prospectos desde diferentes fuentes (redes sociales, eventos, referidos)
- Hacer outreach inicial (primer contacto)

### Nutrición de prospectos (Lead Nurturing)
- Mantener contacto con prospectos que no están listos para comprar
- Educarlos sobre el producto o servicio con contenido relevante
- Construir confianza y autoridad antes de la propuesta
- Identificar el momento en que el prospecto está listo para comprar

### Presentación y propuesta
- Hacer demostraciones del producto o servicio
- Entender las necesidades específicas del cliente
- Elaborar propuestas económicas personalizadas
- Manejar objeciones

### Cierre y postventa
- Negociar y cerrar el contrato
- Gestionar la firma de documentos
- Hacer el onboarding del nuevo cliente
- Mantener la relación para generar recompras y referidos

### Gestión del CRM
- Registrar todas las interacciones con prospectos y clientes
- Actualizar el status de cada oportunidad en el pipeline
- Reportar el avance de ventas a dirección
- Analizar el desempeño del equipo comercial

---

## Procesos repetitivos típicos (candidatos a automatizar)

### 1. Captura y registro de leads desde múltiples fuentes
Los prospectos llegan por Instagram, Facebook, WhatsApp, formulario web, eventos y referidos. Registrarlos manualmente en el CRM es tedioso y frecuentemente se olvida.

**Automatizable:** Cuando llega un lead desde cualquier canal, un flujo lo captura automáticamente, lo registra en el CRM con la fuente de origen y envía una notificación al vendedor responsable.

### 2. Primera respuesta a prospectos
El tiempo de primera respuesta es crítico en ventas. Un estudio muestra que responder en los primeros 5 minutos aumenta la probabilidad de conversión 9 veces vs. responder después de 30 minutos.

**Automatizable:** Cuando llega un lead, el sistema envía inmediatamente una respuesta personalizada por el canal de origen (WhatsApp, Instagram DM, correo), presentando la empresa y solicitando información para calificar al prospecto.

### 3. Seguimiento automático de prospectos sin respuesta
El 80% de las ventas requieren más de 5 contactos, pero el 92% de los vendedores se rinden antes del 4to intento. El seguimiento consistente es la diferencia entre cerrar y perder la venta.

**Automatizable:** Un flujo monitorea los prospectos que no han respondido en X días y envía mensajes de seguimiento secuenciales — cada uno con un ángulo diferente y relevante para el prospecto.

### 4. Calificación inicial de leads (Lead Scoring)
No todos los prospectos tienen el mismo potencial. Dedicar el mismo tiempo a un prospecto ideal y a uno que no califica es un desperdicio del tiempo del vendedor.

**Automatizable:** Cuando llega un lead, un chatbot (ManyChat o n8n) hace 3-5 preguntas de calificación, procesa las respuestas con IA y asigna una puntuación. Los leads de alta puntuación van directo al vendedor; los de baja puntuación entran a una secuencia de nutrición.

### 5. Actualización del CRM post-llamada
Después de hablar con un prospecto, el vendedor debería actualizar el CRM con lo que discutieron, los próximos pasos y la nueva fecha de seguimiento. En la práctica, esto se hace inconsistentemente.

**Automatizable:** El vendedor envía un mensaje de voz al bot después de la llamada. La IA transcribe y extrae: resumen de la llamada, compromisos adquiridos, próxima acción y fecha. Actualiza el CRM automáticamente.

---

## ¿Qué datos maneja esta área?

### Datos de entrada (inputs)
- Datos de contacto del prospecto (nombre, empresa, teléfono, correo)
- Fuente de origen (¿cómo nos encontró?)
- Necesidades y presupuesto del prospecto
- Historial de interacciones (llamadas, correos, WhatsApps)
- Propuestas y contratos

### Datos de salida (outputs)
- Prospectos calificados listos para el vendedor
- Secuencias de seguimiento activas
- Propuestas generadas
- Reportes del pipeline (cuánto hay en cada etapa)
- Proyecciones de ventas

### Sistemas donde vive esta información
- **HubSpot**: CRM completo con automatización (muy popular en México)
- **Kommo (antes amoCRM)**: CRM especializado en WhatsApp y Telegram
- **ManyChat**: Automatización de chatbots en Instagram y Facebook Messenger
- **WhatsApp Business API**: Mensajería empresarial con automatización
- **Pipedrive / Zoho CRM**: CRMs alternativos populares
- **Google Sheets**: Manejo básico de prospectos en empresas pequeñas

---

## El Embudo de Ventas (Funnel)

El embudo visualiza cómo los prospectos avanzan desde el primer contacto hasta la compra:

```
CONCIENCIA     → Miles de personas ven tu contenido
    ↓
INTERÉS        → Cientos se interesan y buscan más información
    ↓
CONSIDERACIÓN  → Decenas comparan tu oferta con alternativas
    ↓
INTENCIÓN      → Varios solicitan cotización o demo
    ↓
EVALUACIÓN     → Pocos están en negociación activa
    ↓
COMPRA         → Uno o dos cierran el mes
```

La automatización tiene un rol diferente en cada etapa:
- **Conciencia e interés**: Contenido automatizado (redes sociales, email marketing)
- **Consideración**: Chatbot de calificación y nutrición
- **Intención y evaluación**: Vendedor humano apoyado por CRM automatizado
- **Compra**: Firma digital y onboarding automatizado

---

## ManyChat, Kommo y WhatsApp Business — Ecosistema de ventas conversacional

### ManyChat
Plataforma de chatbots para Instagram y Facebook Messenger. Permite:
- Responder automáticamente a comentarios y DMs
- Calificar prospectos con preguntas automatizadas
- Enviar secuencias de mensajes programados
- Conectar con CRMs vía webhooks

### WhatsApp Business API
La versión empresarial de WhatsApp que permite:
- Enviar mensajes masivos (con plantillas aprobadas)
- Automatizar respuestas
- Integrar con CRMs y sistemas de ventas
- Asignar conversaciones a diferentes agentes

**Importante**: La API de WhatsApp Business requiere aprobación de Meta y tiene costos por mensaje. Es diferente a la app gratuita de WhatsApp Business.

### Kommo (antes amoCRM)
CRM especializado en ventas conversacionales vía WhatsApp y Telegram:
- Centraliza todas las conversaciones de WhatsApp en un solo lugar
- Permite que múltiples vendedores atiendan desde una sola línea
- Automatiza seguimientos y recordatorios
- Se integra con n8n vía API

---

## Conexión con otras áreas de la organización

- **Con Marketing**: Recibe los leads generados por campañas y contenido
- **Con Operaciones**: Le entrega los nuevos clientes para onboarding
- **Con Finanzas**: Informa los cierres para facturación y reconocimiento de ingresos
- **Con RRHH**: Comunica las necesidades de capacitación del equipo comercial
- **Con Dirección**: Reporta el pipeline, el forecast y los resultados

---

## Casos reales de automatización en este contexto

### Caso 1: Sistema de nutrición de prospectos con ManyChat + HubSpot
**Situación:** Una escuela de inglés generaba 200 leads al mes desde Instagram, pero solo el equipo lograba atender a 30-40. Los demás prospectos se enfriaban y nunca compraban.

**Solución automatizada:**
1. Cuando alguien comenta o manda DM en Instagram, ManyChat inicia una conversación
2. El bot hace 3 preguntas de calificación: nivel actual, disponibilidad, objetivo
3. Las respuestas se envían a n8n vía webhook
4. n8n registra el prospecto en HubSpot con su calificación y etapa
5. HubSpot envía una secuencia de 5 correos en 10 días con contenido educativo
6. Si el prospecto abre los correos o hace clic, n8n le asigna un puntaje más alto y notifica al vendedor

**Resultado:** El equipo de ventas ahora atiende prospectos calientes (ya nutrido por el sistema) en lugar de fríos. La tasa de cierre aumentó del 12% al 28%.

### Caso 2: Bot de calificación y agenda por WhatsApp
**Situación:** Una consultora de software recibía solicitudes por WhatsApp. Cada solicitud requería 15-20 minutos de conversación para entender el proyecto antes de poder dar una respuesta.

**Solución automatizada:**
1. El bot de WhatsApp recibe la solicitud inicial
2. Hace preguntas específicas: tipo de proyecto, presupuesto aproximado, urgencia, tamaño de empresa
3. Con las respuestas, la IA genera un resumen del proyecto y lo clasifica
4. Si califica: le ofrece al prospecto agendar una llamada con un consultor y muestra horarios disponibles
5. Si no califica: le comparte recursos gratuitos relevantes y lo invita a un formulario más detallado

**Resultado:** Los consultores solo hablan con prospectos calificados. El tiempo de calificación bajó de 20 minutos a 0 (automatizado).

### Caso 3: Actualización automática del CRM post-interacción
**Situación:** El equipo de ventas de una distribuidora tenía 5 vendedores en campo. Ninguno actualizaba el CRM de forma consistente — al gerente le era imposible saber el estado real de las oportunidades.

**Solución automatizada:**
1. Después de cada visita o llamada, el vendedor graba un mensaje de voz de 2 minutos con un resumen
2. El mensaje llega al bot de Telegram
3. Whisper transcribe el audio
4. GPT extrae: cliente, resumen de la reunión, acuerdos, próxima acción, probabilidad de cierre
5. n8n actualiza el registro en HubSpot con toda esa información
6. El gerente recibe un resumen diario de todas las interacciones del equipo

**Resultado:** El CRM pasó de estar actualizado en un 30% a un 95%. El gerente puede hacer forecasting real.

---

## El Demo Day — Presentar automatización como caso de negocio

En el Sprint 7, los alumnos presentan su proyecto ante un jurado. Para que la presentación sea efectiva, debe responder estas preguntas:

**¿Cuál era el problema?**
- Describir el proceso manual actual: tiempo, costo, errores
- Cuantificar el impacto: "perdíamos X leads por semana" o "tardábamos X horas en hacer Y"

**¿Cuál es la solución?**
- Demostrar el flujo en vivo — no un video, el sistema real
- Mostrar cada herramienta y cómo se conectan
- Explicar las decisiones de diseño: "usamos Telegram porque el equipo ya lo usa"

**¿Qué resultados genera?**
- Tiempo ahorrado (horas/semana o mes)
- Costo reducido (MXN/mes)
- Métricas de negocio mejoradas (tasa de conversión, tiempo de respuesta)
- ROI: cuánto costó implementar vs. cuánto ahorra al mes

**¿Es escalable y vendible?**
- ¿Se puede replicar para otros clientes del mismo sector?
- ¿Qué modificaciones necesitaría para adaptarse?
- ¿Cuánto cobrarías por implementarlo?

---

## Métricas clave de esta área

- **Tasa de conversión de lead a cliente**: Leads / Clientes cerrados × 100
- **Tiempo de ciclo de venta**: Días desde el primer contacto hasta el cierre
- **Valor promedio del contrato (ACV)**: Ingreso promedio por nuevo cliente
- **Costo de adquisición de cliente (CAC)**: Inversión total en ventas y marketing / nuevos clientes
- **Lifetime Value (LTV)**: Ingresos totales esperados de un cliente durante su relación
- **Tasa de seguimiento**: % de prospectos que reciben seguimiento en menos de 24 horas

---

## Vocabulario clave del área

| Término | Significado |
|---|---|
| Lead | Persona o empresa que ha mostrado interés y dejó sus datos |
| Prospecto | Lead que ha sido calificado y tiene potencial real de compra |
| Pipeline | Conjunto de oportunidades de venta activas en diferentes etapas |
| Forecast | Proyección de ventas esperadas para el siguiente período |
| Lead scoring | Sistema de puntuación para calificar la calidad de un lead |
| Nurturing | Proceso de educar y mantener el contacto con prospectos que no están listos |
| CRM | Customer Relationship Management — sistema para gestionar relaciones con clientes |
| Funnel | Embudo de ventas — representación visual de las etapas del proceso comercial |
| Churn | Tasa de clientes que cancelan o dejan de comprar |
| Upsell | Vender una versión más cara o premium a un cliente existente |
| Cross-sell | Vender un producto complementario a un cliente existente |
| Outreach | Contacto proactivo hacia prospectos que aún no nos conocen |

---

## Prompts sugeridos para estudiar con este cerebro

- "¿Cuáles son las etapas del proceso de ventas y en qué etapas tiene sentido automatizar vs. mantener el toque humano?"
- "¿Cómo funciona ManyChat para calificar prospectos en Instagram y cómo se conecta con un CRM?"
- "¿Qué diferencia hay entre WhatsApp Business (app gratuita) y la API de WhatsApp Business?"
- "¿Cómo calcularía el ROI de un sistema de automatización de ventas para presentarlo en el Demo Day?"
- "Dame un ejemplo de una secuencia de 5 mensajes de nurturing para una escuela de programación"

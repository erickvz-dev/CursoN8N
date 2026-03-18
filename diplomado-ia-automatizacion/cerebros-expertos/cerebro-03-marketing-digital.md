# Cerebro Experto: Marketing Digital y Orquestación de Contenido
> Diplomado IA & Automatización — Sprint 3
> Vertical: Marketing Digital / Redes Sociales / Análisis

---

## ¿Qué es el Marketing Digital?

El marketing digital es el conjunto de estrategias y acciones que una empresa realiza en canales digitales (redes sociales, motores de búsqueda, correo electrónico, sitios web) para atraer clientes, construir marca y generar ventas.

A diferencia del marketing tradicional, el digital tiene una ventaja crucial: **todo es medible**. Puedes saber exactamente cuántas personas vieron tu contenido, cuántas interactuaron, cuántas compraron — y optimizar en consecuencia.

El reto es que esta medición y optimización constante requiere mucho trabajo manual si no está automatizado.

---

## ¿Qué hace esta área en una empresa?

### Gestión de redes sociales
- Crear y publicar contenido en Instagram, Facebook, LinkedIn, TikTok
- Responder comentarios y mensajes directos
- Monitorear menciones de la marca
- Gestionar la comunidad de seguidores

### Creación de contenido
- Redactar copys (textos) para posts, anuncios y emails
- Definir hashtags relevantes para cada publicación
- Adaptar el tono según la red social y la audiencia
- Mantener consistencia con la identidad de marca

### Análisis y métricas
- Revisar el engagement de cada publicación (likes, comentarios, shares, saves)
- Analizar el alcance y las impresiones
- Identificar qué tipo de contenido funciona mejor
- Reportar resultados a dirección y ajustar estrategia

### Captación de leads
- Diseñar formularios y páginas de captura
- Gestionar campañas pagadas (Meta Ads, Google Ads)
- Hacer seguimiento a prospectos generados por redes
- Nutrir leads con secuencias de contenido

---

## Procesos repetitivos típicos (candidatos a automatizar)

### 1. Ciclo completo de publicación en redes sociales
El proceso manual es: idea → escribir copy → diseñar imagen → publicar → monitorear. Si se hace para múltiples redes y múltiples veces por semana, consume el 60-70% del tiempo del equipo de marketing.

**Automatizable:** Un agente orquestador recibe un tema o producto, genera el copy, crea el diseño, publica en Instagram y guarda el registro — sin intervención humana para contenido estándar.

### 2. Monitoreo diario de engagement
Revisar manualmente las métricas de cada post (¿cuántos likes? ¿cuántos comentarios? ¿qué comentaron?) y decidir si responder o tomar acción.

**Automatizable:** Un flujo programado consulta las métricas de todos los posts del día anterior, identifica los que tuvieron engagement inusual (muy alto o muy bajo) y genera un reporte con insights y recomendaciones.

### 3. Captura y clasificación de leads desde comentarios
Cuando alguien comenta "¿cómo compro?" o "quiero más información" en un post, hay una oportunidad de venta que se pierde si no se responde rápido.

**Automatizable:** Monitorear comentarios, detectar intención de compra con IA, responder automáticamente y registrar el prospecto en el CRM para seguimiento del equipo de ventas.

### 4. Generación de reportes de desempeño
Cada semana o mes, alguien tiene que entrar a las plataformas de analítica, copiar números, pegarlos en una hoja de cálculo y generar gráficas para la presentación al cliente o a dirección.

**Automatizable:** Un flujo consulta las APIs de analítica, consolida los datos y genera un reporte en formato visual listo para presentar.

### 5. Publicación de contenido evergreen programado
Hay contenido que siempre es relevante (tips, datos curiosos, testimonios) que puede republicarse en diferentes momentos del año.

**Automatizable:** Una biblioteca de contenido evergreen se publica automáticamente en los días y horarios de menor actividad del equipo, manteniendo frecuencia de publicación sin esfuerzo adicional.

---

## ¿Qué datos maneja esta área?

### Datos de entrada (inputs)
- Calendario editorial con temas, fechas y canales
- Briefing de campaña (objetivo, audiencia, oferta)
- Assets visuales (imágenes, videos, logos)
- Datos de productos y servicios
- Feedback del equipo de ventas sobre qué preguntan los clientes

### Datos de salida (outputs)
- Posts publicados con copy e imagen
- Reportes de engagement y alcance
- Lista de leads captados con información de contacto
- Análisis de contenido más efectivo
- Recomendaciones de estrategia basadas en datos

### Sistemas donde vive esta información
- **Instagram / Facebook Business**: Publicación y métricas orgánicas
- **Meta Business Suite**: Gestión centralizada de Meta
- **Facebook Graph API**: Acceso programático a datos e Instagram
- **HubSpot / ActiveCampaign**: CRM y automatización de marketing
- **Google Analytics**: Tráfico web generado por redes sociales
- **Notion / Airtable**: Calendario editorial y gestión de contenido

---

## Conexión con otras áreas de la organización

- **Con Ventas**: Los leads generados por marketing son los prospectos que trabaja ventas
- **Con Producción Visual**: Necesita las piezas gráficas para publicar
- **Con Dirección**: Reporta resultados y propone ajustes estratégicos
- **Con Servicio al Cliente**: Los comentarios y DMs de redes son primera línea de atención
- **Con Producto**: Las campañas deben alinearse con lanzamientos y actualizaciones

---

## El concepto de Agente Orquestador

En automatización avanzada, un **orquestador** es un sistema central que no hace el trabajo operativo directamente, sino que **decide qué herramienta especializada llamar** según el objetivo.

Analogía: Es como un director de orquesta. Él no toca ningún instrumento, pero sabe exactamente cuándo debe entrar el violín, cuándo los metales y cuándo la percusión. El resultado es armonioso porque hay coordinación inteligente.

En marketing digital, el orquestador funciona así:
```
Solicitud: "Crea un post para Instagram sobre nuestra promo de fin de mes"
    ↓
Orquestador analiza la solicitud
    ↓
Llama a: Generador de Copy → produce el texto del post
    ↓
Llama a: Diseñador → crea la imagen con el copy
    ↓
Llama a: Publicador → sube el post a Instagram
    ↓
Llama a: Monitor → espera 24h y reporta el engagement
```

Cada "herramienta" es un subworkflow especializado. El orquestador solo coordina.

---

## Casos reales de automatización en este contexto

### Caso 1: Sistema de publicación autónoma semanal
**Situación:** Una marca de ropa publicaba 5 veces por semana en Instagram. El community manager dedicaba 3 horas diarias a crear contenido, diseñar y publicar.

**Solución automatizada:**
1. Los lunes, el dueño llena una hoja con: 5 temas de la semana y el producto destacado de cada día
2. Un agente orquestador procesa cada fila:
   - Genera copy optimizado para Instagram con GPT
   - Crea la imagen con la plantilla de la marca en Canva
   - Programa la publicación en el horario de mayor engagement
3. El community manager solo revisa y aprueba los borradores

**Resultado:** De 15 horas semanales a 2 horas de revisión.

### Caso 2: Sistema de captura automática de leads desde comentarios
**Situación:** En cada publicación de una escuela de idiomas, varios usuarios preguntaban por precios e inscripciones. El equipo respondía cuando podía, pero muchos prospectos se enfriaban antes de recibir respuesta.

**Solución automatizada:**
1. Un webhook escucha nuevos comentarios en los posts de Instagram
2. GPT analiza cada comentario y detecta si hay intención de compra
3. Si detecta intención: responde automáticamente con información básica y un link al formulario
4. Registra el perfil del usuario en HubSpot como prospecto
5. El equipo de ventas recibe una notificación inmediata con el contexto

**Resultado:** Tiempo de primera respuesta: de horas a segundos. Conversión de prospectos aumentó 40%.

### Caso 3: Reporte semanal automatizado de métricas
**Situación:** Cada lunes, el gerente de marketing pasaba 2 horas extrayendo métricas de Instagram, copiándolas a una hoja de cálculo y preparando la presentación para la reunión de dirección.

**Solución automatizada:**
1. Cada domingo a las 11 PM, un flujo consulta la Facebook Graph API
2. Extrae: alcance, impresiones, engagement, crecimiento de seguidores, top 3 posts
3. GPT genera un análisis narrativo de los resultados
4. Se genera un reporte HTML con gráficas y se envía por email a dirección
5. Se guarda en Google Sheets para histórico

**Resultado:** El lunes el reporte ya está en el inbox. La reunión dura 20 minutos en lugar de una hora.

---

## Métricas clave de esta área

### Métricas de contenido
- **Engagement Rate**: (likes + comentarios + shares) / alcance × 100. Bueno en Instagram: 3-6%
- **Alcance**: Personas únicas que vieron el contenido
- **Impresiones**: Veces que se mostró el contenido (puede incluir repeticiones)
- **Saves**: Veces que guardaron el post — indicador de contenido de alto valor

### Métricas de negocio
- **CPL (Costo por Lead)**: Inversión total / leads generados
- **Tasa de conversión**: Leads que se convirtieron en clientes
- **ROI de campaña**: (ingresos generados - inversión) / inversión × 100

### Métricas de automatización
- **Tiempo ahorrado por ciclo de publicación**
- **Posts publicados sin intervención humana**
- **Tiempo de respuesta a leads desde redes**

---

## Vocabulario clave del área

| Término | Significado |
|---|---|
| Copy | El texto de un post, anuncio o comunicación de marketing |
| Engagement | Interacciones del público con el contenido (likes, comentarios, shares) |
| Alcance (Reach) | Número de personas únicas que vieron una publicación |
| Impresiones | Número total de veces que se mostró una publicación |
| CTA | Call to Action — instrucción que le dices al usuario qué hacer ("Compra ahora", "Conoce más") |
| Funnel | Embudo de ventas — proceso por el que pasa un prospecto hasta convertirse en cliente |
| Lead | Prospecto que ha mostrado interés y dejó sus datos de contacto |
| Hashtag | Etiqueta de tema en redes sociales para facilitar la búsqueda de contenido |
| KPI | Indicador clave de desempeño — métrica que mide el éxito de un objetivo |
| Orgánico | Alcance o resultados logrados sin pagar por publicidad |
| Paid / Pagado | Resultados logrados mediante inversión en publicidad |

---

## Prompts sugeridos para estudiar con este cerebro

- "¿Cuál es la diferencia entre alcance e impresiones en Instagram y por qué importa?"
- "¿Cómo funciona un agente orquestador y en qué se diferencia de un flujo lineal?"
- "Dame 5 ejemplos de procesos de marketing digital que se pueden automatizar sin perder autenticidad"
- "¿Qué información necesito para calcular el engagement rate de un post?"
- "¿Cómo debería estructurar un sistema de captura de leads desde comentarios de Instagram?"

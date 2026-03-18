# Cerebro para Antigravity — Reportes Financieros en Tiempo Real

## Rol

Eres un Ingeniero de Automatización Senior experto en n8n, bases de datos PostgreSQL y creación de APIs web. Tu trabajo es diseñar flujos que sean operables, claros y que un equipo no técnico pueda mantener.

## Objetivo

Diseñar un flujo **bajo demanda (Pull)** que se active mediante una URL (Webhook), extraiga datos de PostgreSQL (Supabase), los procese con IA y devuelva un reporte renderizado en HTML directamente al navegador del usuario.

**Cero uso de correos electrónicos.** El reporte es una página web accesible desde cualquier dispositivo.

---

## Reglas de Arquitectura

### 1. Trigger — Webhook GET

- Usa siempre un nodo **Webhook**.
- Método: `GET`.
- En la opción **"Respond"** selecciona **"Using 'Respond to Webhook' Node"**. Esto es obligatorio para poder controlar la salida final.
- Nombre del nodo: `Webhook - Entrada`.

### 2. Extracción de datos — Postgres

- Usa el nodo **Postgres** con la operación `Execute Query`.
- La consulta SQL base es: `SELECT * FROM "Gastos";`
- Si el cliente necesita filtrar por estado, la consulta sería: `SELECT * FROM "Gastos" WHERE "Estado" = 'Aprobado';`
- Nombre del nodo: `Supabase - Leer Gastos`.

### 3. Procesamiento de datos — IA

- Usa el nodo **Basic LLM Chain** (o equivalente) con modelo `gpt-4o-mini`.
- Conecta la salida de Postgres como input.
- Nombre del nodo: `OpenAI - Generar Reporte`.

### 4. Prompt del Analista (System Prompt exacto)

```
Eres un director financiero. Recibes un JSON con los gastos del período.
Analízalos y extrae los siguientes insights:
- Total gastado
- Categoría con mayor gasto
- Top 3 empleados por monto
- Gastos pendientes vs aprobados
- Recomendaciones breves (máximo 2)

Tu ÚNICA salida debe ser código HTML puro y limpio, con CSS integrado (estilo moderno, tipografía sans-serif, colores neutros y una tabla de datos legible).
No uses markdown. No escribas texto fuera del HTML. El primer carácter de tu respuesta debe ser < y el último debe ser >.
```

### 5. Salida al usuario — Respond to Webhook

- Usa el nodo **Respond to Webhook**.
- **"Respond With"**: `Text`.
- **"Response Body"**: mapea la salida de texto del nodo de IA.
- **"Response Headers"**: agrega el header `Content-Type: text/html` para que el navegador renderice correctamente.
- Nombre del nodo: `Responder al Navegador`.

### 6. Sticky Notes (obligatorias)

Agrega una Sticky Note en cada nodo con este contenido:

| Nodo | Texto de la nota |
|---|---|
| Webhook | `1. ENTRADA: Cualquier persona con este enlace puede solicitar el reporte. Activa el flujo en tiempo real.` |
| Postgres | `2. CONSULTA DB: Lee todos los gastos de Supabase en el momento en que alguien abre el enlace.` |
| OpenAI | `3. ANÁLISIS IA: Convierte los datos crudos en un reporte financiero legible en formato HTML.` |
| Respond to Webhook | `4. SALIDA: Envía el HTML como página web. El navegador lo renderiza como reporte final.` |

---

## Diagrama del flujo

```
Webhook (GET)
    ↓
Postgres — SELECT * FROM "Gastos"
    ↓
Basic LLM Chain — Analista financiero → HTML
    ↓
Respond to Webhook — Content-Type: text/html
```

---

## Notas de implementación

- **Credenciales de Supabase en n8n**: usa el nodo Postgres con la conexión directa (host, puerto, nombre de DB, usuario, contraseña). NO uses la API REST de Supabase para esta consulta — el nodo Postgres es más eficiente para lecturas masivas.
- **Si hay muchos registros**: agrega `LIMIT 50` a la consulta SQL para no sobrecargar el contexto del modelo.
- **Seguridad del enlace**: el Webhook queda público por defecto. Si el cliente necesita protección, agrega un parámetro `?token=SECRET` en la URL y valídalo con un nodo IF antes del Postgres.

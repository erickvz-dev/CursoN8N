# Cerebro Maestro — Skills de n8n para Vibe Coding

## Rol

Eres un Ingeniero de Automatización Senior con experiencia real construyendo workflows de producción en n8n. Conoces las particularidades de cada nodo, las trampas comunes y cómo conectar datos entre pasos sin errores.

Este documento es tu base de conocimiento permanente. **Aplícalo siempre** antes de construir cualquier workflow.

---

## Reglas Generales de Construcción

### 1. Un workflow a la vez
- Nunca construyas dos workflows en un solo prompt.
- Construye, publica vía MCP, espera confirmación del usuario y luego continúa.

### 2. Nombres de nodos descriptivos
- Cada nodo lleva un nombre que describe su función exacta: `"Telegram - Recibir Foto"`, `"OpenAI - Leer Ticket"`, `"Postgres - Registrar Gasto"`.
- Nunca dejes nombres genéricos como `"Code"`, `"HTTP Request"`, `"IF"`.

### 3. Sticky Notes obligatorias
- Agrega una Sticky Note pegada a cada nodo con una línea que explique qué hace y por qué.
- Formato: `"N. FUNCIÓN: Explicación breve."` (ej: `"3. ANÁLISIS IA: Convierte la foto del ticket en datos estructurados."`).

---

## Expresiones y Referencias entre Nodos

### Acceder a datos del nodo anterior
```
{{ $json.campo }}
```

### Acceder a datos de un nodo específico por nombre
```
{{ $('Nombre del Nodo').item.json.campo }}
```

### Acceder a datos binarios del nodo anterior
```
{{ $binary.data }}
```

### Interpolación de texto (dentro de campos de texto)
```
El monto es: {{ $json.monto }} MXN
```

### Expresión condicional inline
```
{{ $json.score >= 75 ? "Aprobado" : "Rechazado" }}
```

### Acceder a un item específico de un array
```
{{ $json.results[0].text }}
```

---

## Nodos de Telegram — Configuración Exacta

### Telegram Trigger (recibir mensajes)
- **Nodo**: `Telegram Trigger`
- **Campo "Updates"**: Selecciona `message` para mensajes normales (fotos, texto, audio).
- **Para recibir SOLO callback queries** (respuestas de botones inline): selecciona `callback_query` en vez de `message`.
- **Credential**: Usa la credencial de Telegram Bot ya configurada en n8n.

#### Filtrar solo mensajes con foto
Después del Telegram Trigger, agrega un nodo **IF**:
- Condición: `{{ $json.message.photo }}` → `exists` (is not empty).
- Rama TRUE: continúa el flujo.
- Rama FALSE: ignora (o responde con mensaje de "solo acepto fotos").
- **Nombre del nodo**: `"IF - ¿Tiene Foto?"`.

#### Datos disponibles en el trigger
- Chat ID del remitente: `{{ $json.message.chat.id }}`
- Nombre del remitente: `{{ $json.message.from.first_name }}`
- ID del mensaje: `{{ $json.message.message_id }}`
- File ID de la foto (la de mayor resolución): `{{ $json.message.photo.pop().file_id }}`

### Telegram - Obtener Archivo (Get File)
- **Nodo**: `Telegram` con operación `Get File`.
- **File ID**: `{{ $json.message.photo.pop().file_id }}` (o del nodo anterior si ya lo extrajiste).
- **Importante**: Marca la opción **"Download"** para que n8n descargue el archivo como dato binario. Sin esto, solo obtienes la URL pero no el contenido.

### Telegram - Enviar Mensaje con Botones Inline
- **Nodo**: `Telegram` con operación `Send Message`.
- **Chat ID**: el del gerente (puede ser un ID fijo o variable).
- **Text**: el resumen del gasto.
- **Reply Markup**: selecciona `Inline Keyboard`.
- **Inline Keyboard (JSON)**: usa el campo "Reply Markup" → "Inline Keyboard" con este formato:

```json
{
  "inline_keyboard": [
    [
      {"text": "✅ Aprobar", "callback_data": "aprobar_{{ $json.id }}"},
      {"text": "❌ Rechazar", "callback_data": "rechazar_{{ $json.id }}"}
    ]
  ]
}
```

**Trampa común**: El `reply_markup` debe ser un objeto JSON válido, no un string. n8n tiene un campo visual para configurar el inline keyboard — úsalo si está disponible.

### Telegram - Responder Callback Query
- **Nodo**: `Telegram` con operación `Answer Callback Query`.
- **Callback Query ID**: `{{ $json.callback_query.id }}`
- **Text** (opcional): `"Registrado ✅"` — se muestra como toast en el móvil del gerente.
- **Propósito**: Quita el spinner de "cargando" del botón en Telegram. Sin este nodo, el botón parece fallar.

### Datos disponibles en un Callback Query
- Callback data: `{{ $json.callback_query.data }}` → ej: `"aprobar_42"`
- Chat ID del gerente: `{{ $json.callback_query.message.chat.id }}`
- Message ID original: `{{ $json.callback_query.message.message_id }}`

---

## OpenAI Vision (Análisis de Imágenes) — Configuración Exacta

### Opción recomendada: HTTP Request con API de OpenAI

El nodo nativo "OpenAI" de n8n **no siempre soporta imágenes directamente**. La forma más confiable es usar un **HTTP Request**:

- **Nodo**: `HTTP Request`
- **Method**: `POST`
- **URL**: `https://api.openai.com/v1/chat/completions`
- **Authentication**: `Generic Credential Type` → `Header Auth`
  - Name: `Authorization`
  - Value: `Bearer TU_API_KEY` (o usa la credencial configurada)
- **Body (JSON)**:

```json
{
  "model": "gpt-4o",
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "TU_PROMPT_AQUÍ"
        },
        {
          "type": "image_url",
          "image_url": {
            "url": "data:image/jpeg;base64,{{ $binary.data.toString('base64') }}"
          }
        }
      ]
    }
  ],
  "max_tokens": 500
}
```

- **Nombre del nodo**: `"OpenAI - Leer Ticket"` (o lo que corresponda).

### Opción alternativa: Nodo OpenAI nativo (si soporta visión)

Si la versión de n8n tiene soporte de visión en el nodo OpenAI:
- **Model**: `gpt-4o`
- **Messages**: Configura un mensaje con tipo `image` y pasa el binario.
- **Verifica** que la imagen llegue correctamente revisando el log de ejecución.

### Acceder a la respuesta de OpenAI
```
{{ $json.choices[0].message.content }}
```

### Trampa común con Vision
- **El binario debe existir**: Si el nodo anterior no descargó la imagen (falta la opción "Download" en Telegram Get File), el campo `$binary` estará vacío y OpenAI recibirá una imagen corrupta.
- **Formato base64**: La imagen se envía como `data:image/jpeg;base64,CONTENIDO`. El tipo MIME debe coincidir con el formato real (jpeg, png).
- **Tamaño máximo**: Imágenes mayores a 20MB pueden fallar. Los tickets de celular normalmente pesan 2-5MB.

---

## Nodo Code — Parseo de Datos

### Parsear JSON de un string
Cuando OpenAI responde con un string que contiene JSON (ej: `'{"monto": 42.50, ...}'`):

```javascript
const respuesta = $input.first().json.choices[0].message.content;

// Limpiar posibles backticks de markdown
const limpio = respuesta.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();

const datos = JSON.parse(limpio);

return [{
  json: {
    fecha: datos.fecha,
    empleado: datos.empleado,
    monto: parseFloat(datos.monto),
    categoria: datos.categoria
  }
}];
```

**Trampa común**: OpenAI a veces envuelve el JSON en bloques de markdown (` ```json ... ``` `). El `.replace()` se encarga de eso.

### Extraer acción e ID de un callback_data
Para parsear `"aprobar_42"`:

```javascript
const callbackData = $input.first().json.callback_query.data;
const partes = callbackData.split('_');

return [{
  json: {
    accion: partes[0],       // "aprobar" o "rechazar"
    registroId: partes[1]    // "42"
  }
}];
```

---

## Nodo Postgres (Supabase) — Configuración Exacta

### Credenciales de conexión
- **Host**: El host de Supabase (ej: `db.xxxx.supabase.co`)
- **Port**: `5432`
- **Database**: `postgres` (por defecto en Supabase)
- **User**: `postgres`
- **Password**: La password del proyecto
- **SSL**: Activar (Supabase requiere SSL)

### INSERT
- **Operation**: `Insert`
- **Schema**: `public`
- **Table**: `Gastos`
- **Columns**: mapea cada campo del JSON a la columna correspondiente.
- **Return Fields**: marca `*` o `id` para obtener el ID del registro insertado (necesario para los botones de callback).

### UPDATE con condición
- **Operation**: `Update`
- **Schema**: `public`
- **Table**: `Gastos`
- **Columns**: solo el campo a actualizar (ej: `Estado`).
- **Where**: `id = {{ $json.registroId }}`

### SELECT
- **Operation**: `Execute Query`
- **Query**: `SELECT * FROM "Gastos";`
- **Nota**: Los nombres de tabla y columna en Supabase son **case-sensitive** porque PostgreSQL usa comillas dobles. Siempre usa `"Gastos"`, `"Estado"`, etc.

---

## Nodo Webhook — Configuración Exacta

### Webhook GET (para reportes bajo demanda)
- **Method**: `GET`
- **Respond**: Selecciona `"Using 'Respond to Webhook' Node"` — obligatorio para controlar la respuesta final.
- **Path**: un slug descriptivo (ej: `reporte-gastos`).

### Respond to Webhook
- **Respond With**: `Text`
- **Response Body**: la salida del nodo de IA.
- **Response Headers**: agrega `Content-Type: text/html` para que el navegador renderice HTML.

---

## Nodo IF — Condiciones

### Comparar strings
- **Value 1**: `{{ $json.campo }}`
- **Operation**: `Equals`
- **Value 2**: `"valor esperado"`

### Verificar si un campo existe
- **Value 1**: `{{ $json.message.photo }}`
- **Operation**: `Is Not Empty`

### Comparar números
- **Value 1**: `{{ $json.score }}`
- **Operation**: `Larger or Equal`
- **Value 2**: `75`

---

## Patrones de Error Handling

### Manejo básico con IF
Después de un nodo que puede fallar (OpenAI, HTTP Request), agrega un IF:
- Condición: verifica que la respuesta tenga el campo esperado.
- Rama FALSE: envía notificación de error o mensaje amable al usuario.

### Try/Catch en Code nodes
```javascript
try {
  const datos = JSON.parse(respuesta);
  return [{ json: datos }];
} catch (error) {
  return [{ json: { error: true, mensaje: "No pude procesar la respuesta de la IA" } }];
}
```

### Patrón "notificación de error al usuario"
Si algo falla, el último recurso es notificar al usuario original vía Telegram:
- Nodo Telegram → Send Message.
- Chat ID: el del usuario que envió el mensaje original.
- Text: `"No pude procesar tu imagen. Intenta con una foto más clara del ticket."`.

---

## Checklist Antes de Publicar un Workflow

1. **¿Todos los nodos tienen nombre descriptivo?** No dejes "Code", "IF", "HTTP Request" genéricos.
2. **¿Hay Sticky Notes en cada nodo?** Con el formato `"N. FUNCIÓN: Explicación"`.
3. **¿Los datos fluyen correctamente?** Verifica que las expresiones `{{ $json.campo }}` apuntan al nodo correcto.
4. **¿Hay manejo de error?** Al menos un IF que atrape respuestas inesperadas de la IA.
5. **¿El workflow está activo?** Publicar vía MCP no siempre lo activa — verifica.

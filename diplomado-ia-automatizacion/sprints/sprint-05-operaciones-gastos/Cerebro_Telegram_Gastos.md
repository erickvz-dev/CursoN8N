# Cerebro — Pipeline de Aprobación de Gastos (Telegram + IA + Supabase)

## Rol

Eres un Ingeniero de Automatización Senior experto en n8n, Telegram Bot API, OpenAI Vision y PostgreSQL (Supabase). Tu trabajo es diseñar flujos robustos que un equipo no técnico pueda operar desde su celular.

## Objetivo

Construir **dos workflows separados** que operan como un pipeline de aprobación de gastos:

1. **Captura de Gastos**: Colaborador envía foto del ticket por Telegram → IA extrae datos → Supabase registra → gerente recibe notificación con botones.
2. **Aprobación de Gastos**: Gerente pulsa botón → Supabase actualiza estado → colaborador recibe confirmación.

**Los workflows se construyen uno a la vez.** Primero el de Captura, se prueba, y luego el de Aprobación.

---

## Reglas de Arquitectura — Workflow 1: Captura de Gastos

### Nombre del workflow
`Sprint5 - Captura de Gastos`

### Diagrama del flujo

```
Telegram Trigger (message)
    ↓
IF - ¿Tiene Foto?
    ├─ FALSE → Telegram - Responder "Solo acepto fotos"
    └─ TRUE ↓
        Telegram - Obtener Archivo (Get File + Download)
            ↓
        HTTP Request - OpenAI Vision (analizar imagen)
            ↓
        Code - Parsear JSON
            ↓
        IF - ¿JSON Válido?
            ├─ FALSE → Telegram - Responder "No pude leer el ticket"
            └─ TRUE ↓
                Postgres - Registrar Gasto (INSERT, retorna id)
                    ↓
                Telegram - Notificar al Gerente (con botones inline)
```

### Nodo 1 — Telegram Trigger
- **Tipo**: `Telegram Trigger`
- **Updates**: `message`
- **Credential**: Usar la credencial de Telegram Bot configurada en n8n.
- **Nombre**: `Telegram - Recibir Mensaje`
- **Sticky Note**: `1. ENTRADA: Recibe cualquier mensaje del bot. El siguiente nodo filtra solo fotos.`

### Nodo 2 — IF: ¿Tiene Foto?
- **Tipo**: `IF`
- **Condición**: `{{ $json.message.photo }}` → `Is Not Empty`
- **Nombre**: `IF - ¿Tiene Foto?`
- **Rama FALSE**: conectar a un nodo Telegram que responda al usuario:
  - Chat ID: `{{ $json.message.chat.id }}`
  - Text: `📸 Este bot solo procesa fotos de tickets. Envíame una imagen de tu recibo.`
- **Sticky Note**: `2. FILTRO: Solo deja pasar mensajes con foto adjunta. Los demás reciben instrucciones.`

### Nodo 3 — Telegram: Obtener Archivo
- **Tipo**: `Telegram` → Operación: `Get File`
- **File ID**: `{{ $json.message.photo.pop().file_id }}`
- **Download**: ✅ Activado (OBLIGATORIO — sin esto no hay imagen para la IA)
- **Nombre**: `Telegram - Descargar Imagen`
- **Sticky Note**: `3. DESCARGA: Obtiene la foto del ticket como archivo binario. La opción Download DEBE estar activa.`

### Nodo 4 — HTTP Request: OpenAI Vision
- **Tipo**: `HTTP Request`
- **Method**: `POST`
- **URL**: `https://api.openai.com/v1/chat/completions`
- **Authentication**: `Generic Credential Type` → `Header Auth`
  - Header Name: `Authorization`
  - Header Value: `Bearer {{ $credentials.openAiApi.apiKey }}` (o usa la credencial de Header Auth con tu API key de OpenAI)
- **Send Headers**: Agrega `Content-Type: application/json`
- **Send Body**: `JSON`
- **Body**:

```json
{
  "model": "gpt-4o",
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "Analiza esta imagen de un ticket o recibo. Extrae los datos y responde ÚNICAMENTE con un JSON válido, sin texto adicional, sin backticks, sin markdown. Formato exacto: {\"fecha\": \"DD/MM/YYYY\", \"empleado\": \"nombre visible en el ticket o 'No especificado'\", \"monto\": 0.00, \"categoria\": \"comida|transporte|materiales|servicios|otro\"}"
        },
        {
          "type": "image_url",
          "image_url": {
            "url": "data:image/jpeg;base64,{{ $binary.data.data }}"
          }
        }
      ]
    }
  ],
  "max_tokens": 200
}
```

- **Nombre**: `OpenAI - Leer Ticket`
- **Sticky Note**: `4. VISIÓN IA: Envía la foto como base64 al API de OpenAI. Responde con JSON puro: fecha, empleado, monto, categoría.`

**Notas importantes**:
- Se usa HTTP Request en vez del nodo OpenAI nativo porque el nodo nativo no siempre soporta imágenes.
- `$binary.data.data` accede al contenido base64 del archivo descargado por Telegram.
- `max_tokens: 200` limita la respuesta para evitar texto extra.

### Nodo 5 — Code: Parsear JSON
- **Tipo**: `Code`
- **Language**: `JavaScript`
- **Código**:

```javascript
const respuesta = $input.first().json.choices[0].message.content;

// Limpiar backticks de markdown si OpenAI los agrega
const limpio = respuesta.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();

try {
  const datos = JSON.parse(limpio);
  
  return [{
    json: {
      fecha: datos.fecha || 'No especificada',
      empleado: datos.empleado || 'No especificado',
      monto: parseFloat(datos.monto) || 0,
      categoria: datos.categoria || 'otro',
      json_valido: true,
      chat_id_original: $('Telegram - Recibir Mensaje').item.json.message.chat.id,
      nombre_remitente: $('Telegram - Recibir Mensaje').item.json.message.from.first_name || 'Colaborador'
    }
  }];
} catch (error) {
  return [{
    json: {
      json_valido: false,
      error: error.message,
      respuesta_cruda: limpio,
      chat_id_original: $('Telegram - Recibir Mensaje').item.json.message.chat.id
    }
  }];
}
```

- **Nombre**: `Code - Parsear Respuesta IA`
- **Sticky Note**: `5. PARSEO: Limpia y convierte la respuesta de la IA a campos individuales. Guarda el chat_id original para notificaciones.`

### Nodo 6 — IF: ¿JSON Válido?
- **Tipo**: `IF`
- **Condición**: `{{ $json.json_valido }}` → `Equals` → `true` (boolean)
- **Nombre**: `IF - ¿JSON Válido?`
- **Rama FALSE**: conectar a un nodo Telegram que responda al chat_id_original:
  - Chat ID: `{{ $json.chat_id_original }}`
  - Text: `⚠️ No pude leer los datos del ticket. Intenta con una foto más clara, bien iluminada y enfocada.`
- **Sticky Note**: `6. VALIDACIÓN: Verifica que la IA devolvió JSON parseable. Si falla, pide una mejor foto.`

### Nodo 7 — Postgres: Registrar Gasto
- **Tipo**: `Postgres`
- **Operation**: `Execute Query`
- **Query**:
```sql
INSERT INTO "Gastos" ("Fecha", "Empleado", "Monto", "Categoria", "Estado")
VALUES ('{{ $json.fecha }}', '{{ $json.empleado }}', {{ $json.monto }}, '{{ $json.categoria }}', 'Pendiente')
RETURNING id;
```
- **Credential**: Usar la conexión Postgres a Supabase configurada en n8n.
- **Nombre**: `Supabase - Registrar Gasto`
- **Sticky Note**: `7. BASE DE DATOS: Inserta el gasto con Estado='Pendiente'. Retorna el id para los botones de aprobación.`

**Nota**: Usar `RETURNING id` es obligatorio — sin el ID no podemos construir los botones de callback.

### Nodo 8 — Telegram: Notificar al Gerente
- **Tipo**: `Telegram` → Operación: `Send Message`
- **Chat ID**: `[ID_DEL_CHAT_DEL_GERENTE]` (el usuario lo reemplaza con el chat ID real del gerente)
- **Text**:
```
📋 *Nuevo gasto por aprobar*

👤 Empleado: {{ $('Code - Parsear Respuesta IA').item.json.empleado }}
💰 Monto: ${{ $('Code - Parsear Respuesta IA').item.json.monto }}
📂 Categoría: {{ $('Code - Parsear Respuesta IA').item.json.categoria }}
📅 Fecha: {{ $('Code - Parsear Respuesta IA').item.json.fecha }}
```
- **Parse Mode**: `Markdown`
- **Reply Markup**: `Inline Keyboard`
- **Inline Keyboard JSON**:
```json
{
  "inline_keyboard": [
    [
      {"text": "✅ Aprobar", "callback_data": "aprobar_{{ $json[0].id }}"},
      {"text": "❌ Rechazar", "callback_data": "rechazar_{{ $json[0].id }}"}
    ]
  ]
}
```
- **Nombre**: `Telegram - Notificar Gerente`
- **Sticky Note**: `8. NOTIFICACIÓN: Envía resumen al gerente con botones de decisión. El callback_data lleva el ID del registro.`

**Nota**: `$json[0].id` viene del `RETURNING id` del INSERT. El ID se embebe en el callback para que el Workflow 2 sepa qué registro actualizar.

---

## Reglas de Arquitectura — Workflow 2: Aprobación de Gastos

### Nombre del workflow
`Sprint5 - Aprobación de Gastos`

### Diagrama del flujo

```
Telegram Trigger (callback_query)
    ↓
Code - Extraer Acción e ID
    ↓
Postgres - Actualizar Estado
    ↓
Telegram - Responder Callback (quitar spinner)
    ↓
Telegram - Notificar Colaborador
```

### Nodo 1 — Telegram Trigger (Callback Query)
- **Tipo**: `Telegram Trigger`
- **Updates**: `callback_query` (NO `message`)
- **Credential**: Misma credencial de Telegram Bot.
- **Nombre**: `Telegram - Recibir Decisión`
- **Sticky Note**: `1. ENTRADA: Se activa SOLO cuando el gerente pulsa un botón inline. No responde a mensajes de texto.`

### Nodo 2 — Code: Extraer Acción e ID
- **Tipo**: `Code`
- **Language**: `JavaScript`
- **Código**:

```javascript
const callbackData = $input.first().json.callback_query.data;
const partes = callbackData.split('_');

const accion = partes[0]; // "aprobar" o "rechazar"
const registroId = parseInt(partes[1]); // 42

const nuevoEstado = accion === 'aprobar' ? 'Aprobado' : 'Rechazado';
const emoji = accion === 'aprobar' ? '✅' : '❌';

return [{
  json: {
    accion: accion,
    registroId: registroId,
    nuevoEstado: nuevoEstado,
    emoji: emoji,
    callbackQueryId: $input.first().json.callback_query.id,
    chatIdGerente: $input.first().json.callback_query.message.chat.id
  }
}];
```

- **Nombre**: `Code - Extraer Acción e ID`
- **Sticky Note**: `2. PARSEO: Separa "aprobar_42" en acción="aprobar" e id=42. Prepara datos para los siguientes nodos.`

### Nodo 3 — Postgres: Actualizar Estado
- **Tipo**: `Postgres`
- **Operation**: `Execute Query`
- **Query**:
```sql
UPDATE "Gastos" SET "Estado" = '{{ $json.nuevoEstado }}' WHERE id = {{ $json.registroId }};
```
- **Nombre**: `Supabase - Actualizar Estado`
- **Sticky Note**: `3. BASE DE DATOS: Cambia el Estado del gasto a "Aprobado" o "Rechazado" según la decisión del gerente.`

### Nodo 4 — Telegram: Responder Callback
- **Tipo**: `Telegram` → Operación: `Answer Callback Query`
  - Si no existe esa operación, usa `HTTP Request` con POST a `https://api.telegram.org/bot[TOKEN]/answerCallbackQuery` con body `{"callback_query_id": "{{ $json.callbackQueryId }}", "text": "Registrado ✅"}`
- **Callback Query ID**: `{{ $json.callbackQueryId }}`
- **Text**: `Registrado ✅`
- **Nombre**: `Telegram - Confirmar Clic`
- **Sticky Note**: `4. UX: Quita el spinner del botón en Telegram. Sin esto, el botón parece trabado.`

### Nodo 5 — Telegram: Notificar Resultado
- **Tipo**: `Telegram` → Operación: `Send Message`
- **Chat ID**: `{{ $json.chatIdGerente }}` (por ahora al gerente; en producción sería al colaborador original)
- **Text**: `{{ $json.emoji }} El gasto #{{ $json.registroId }} fue **{{ $json.nuevoEstado }}**.`
- **Parse Mode**: `Markdown`
- **Nombre**: `Telegram - Notificar Resultado`
- **Sticky Note**: `5. NOTIFICACIÓN: Confirma la decisión al chat. En producción, esto iría al colaborador original.`

---

## Trampas Comunes y Cómo Evitarlas

| Trampa | Causa | Solución |
|---|---|---|
| OpenAI no lee la imagen | No se activó "Download" en Telegram Get File | Verificar que el nodo tiene Download = ✅ |
| `$binary.data` es undefined | El nodo anterior no pasó datos binarios | Revisar la cadena: Trigger → Get File (con Download) → HTTP Request |
| JSON parse error en Code | OpenAI envolvió el JSON en ``` markdown | El código ya incluye `.replace()` para limpiar backticks |
| Botón de Telegram no hace nada | El Workflow 2 no está activo, o el trigger escucha `message` en vez de `callback_query` | Verificar que el trigger usa `callback_query` y el workflow está ON |
| `RETURNING id` no devuelve nada | Se usa operación visual "Insert" de Postgres en vez de "Execute Query" | Usar Execute Query con la sentencia SQL completa |
| El gerente no recibe notificación | El Chat ID del gerente es incorrecto | El gerente debe escribirle al bot primero; luego buscar su chat ID en el log del trigger |

---

## Nota sobre el Chat ID del Gerente

Para obtener el Chat ID del gerente:
1. El gerente debe enviar cualquier mensaje al bot de Telegram.
2. Revisa el log del Telegram Trigger en n8n.
3. Busca `message.chat.id` — ese es el número que se pone en el nodo de notificación.
4. Alternativamente, usa `@userinfobot` en Telegram para obtener tu propio ID.

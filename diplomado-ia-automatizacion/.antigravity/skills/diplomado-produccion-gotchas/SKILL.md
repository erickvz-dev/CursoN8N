---
name: diplomado-produccion-gotchas
description: Gotchas, quirks y patrones reales descubiertos construyendo los workflows del diplomado. Use when n8n produce comportamiento inesperado, al importar/exportar JSON, al integrar Telegram con funciones no nativas (sendVoice, inline keyboard), al usar chainLlm con systemMessage, o al trabajar con Postgres/Supabase columns.
---

# Gotchas de Producción — Diplomado IA

Patrones verificados en producción. Cada sección documenta un problema real encontrado al construir los workflows del diplomado y su solución.

---

## Quick Reference

| Problema | Solución rápida |
|----------|----------------|
| `systemMessage` desaparece al importar | Poner todo en el `text` del chainLlm |
| Telegram no tiene sendVoice | HTTP Request a la API directa |
| Telegram no soporta inline keyboard | HTTP Request con `JSON.stringify()` |
| Postgres columnas no encontradas | Usar comillas dobles: `"Gastos"` |
| LLM envuelve HTML en backticks | Code node de limpieza post-LLM |
| TTS excede límite | Imponer 2500 chars en prompt del LLM |
| Webhook responde `{}` vacío | Configurar `responseMode: "responseNode"` |
| OpenAI Vision formato inesperado | Verificar si campos vienen directos o anidados |

---

## Telegram — Funciones que requieren HTTP Request

El nodo nativo `n8n-nodes-base.telegram` v1.2 NO soporta:

- **`sendVoice`** (notas de voz con waveform)
- **`reply_markup`** (inline keyboard / botones)
- **`answerCallbackQuery`** (quitar spinner de botón)

### sendVoice (Sprint 6)

```json
{
  "method": "POST",
  "url": "https://api.telegram.org/bot{TOKEN}/sendVoice",
  "sendBody": true,
  "contentType": "multipart-form-data",
  "bodyParameters": {
    "parameters": [
      { "name": "chat_id", "value": "={{ chatId }}" },
      { "parameterType": "formBinaryData", "name": "voice", "inputDataFieldName": "data" }
    ]
  }
}
```

- Formato audio DEBE ser `opus` (Telegram requiere OGG/OPUS para waveform)
- Si se envía MP3, Telegram lo muestra como archivo adjunto, no como nota de voz
- **Alternativa simple:** usar `sendAudio` del nodo nativo (muestra reproductor, no waveform)

### Inline Keyboard (Sprint 5)

```javascript
// Usar JSON.stringify para evitar problemas con emojis y newlines
"jsonBody": "={{ JSON.stringify({ chat_id: chatId, text: mensaje, reply_markup: { inline_keyboard: [[{ text: '✅ Aprobar', callback_data: 'aprobar_' + id }]] } }) }}"
```

### Callback Data

- Trigger callback: `updates: ["callback_query"]` (NO `"message"`)
- Chat ID: `$json.callback_query.message.chat.id`
- Data: `$json.callback_query.data` (formato: `"accion_id"`)
- Siempre llamar `answerCallbackQuery` después para quitar el spinner

---

## LLM Chain — systemMessage se pierde al importar

**CRÍTICO:** n8n a veces descarta el `systemMessage` del sub-nodo `lmChatOpenAi` durante el import del JSON.

**Solución:** Poner TODAS las instrucciones directamente en el campo `text` del nodo `chainLlm`:

```json
{
  "type": "@n8n/n8n-nodes-langchain.chainLlm",
  "parameters": {
    "promptType": "define",
    "text": "=Eres un director financiero...\n{{ $json.datos }}\n..."
  }
}
```

**No depender de systemMessage.** Si se usa, verificar después de cada import que sigue presente en la UI.

---

## OpenAI TTS — Text-to-Speech

- **Nodo:** `@n8n/n8n-nodes-langchain.openAi` v2, `resource: "audio"`, `operation: "generate"`
- **Modelos:** `gpt-4o-mini-tts` (expresivo), `tts-1` (rápido), `tts-1-hd` (alta calidad)
- **Voces:** alloy (neutra), echo (grave), nova (cálida), shimmer, fable, onyx
- **Límite duro:** 4,096 caracteres por llamada
- **Práctica:** imponer ~2,500 chars en el prompt del LLM como colchón
- **Formato para Telegram:** `opus` obligatorio
- **Salida:** dato binario en propiedad `data`, fluye automáticamente al siguiente nodo

---

## OpenAI Vision — Formato de respuesta variable

El nodo `@n8n/n8n-nodes-langchain.openAi` con Vision devuelve datos de DOS formas:

```javascript
// Caso 1: campos directos (nodo nativo n8n)
if (response.fecha || response.monto) { data = response; }
// Caso 2: texto anidado (HTTP Request a API raw)
else { rawText = response.choices?.[0]?.message?.content; }
```

- Requiere `"inputType": "base64"` para imágenes binarias
- Imagen: `data:image/jpeg;base64,{{ $binary.data.data }}`

---

## Postgres / Supabase — Quoting

- Supabase crea columnas **lowercase** por defecto
- Nombres de tabla con mayúscula requieren comillas dobles en SQL: `"Gastos"`, `"Transacciones"`
- n8n exporta `SET "estado"` con double quotes (funciona correcto)
- Si Postgres retorna múltiples filas, agregar Code node para consolidar ANTES del LLM:

```javascript
const allItems = $input.all().map(item => item.json);
return [{ json: { datos: JSON.stringify(allItems, null, 2), total: allItems.length } }];
```

---

## Webhook + Respond to Webhook

- Sin `responseMode: "responseNode"`, n8n responde inmediatamente con `{}` vacío
- Respond to Webhook necesita header explícito:
  - HTML: `Content-Type: text/html`
  - JSON: `Content-Type: application/json`
- El `responseBody` debe apuntar al campo limpio: `{{ $json.html }}`

---

## LLM Output Cleanup

Los modelos frecuentemente envuelven HTML en ` ```html ... ``` ` a pesar de instrucciones contrarias.

**Solución — Code node entre LLM y Respond to Webhook:**

```javascript
let text = $input.first().json.text || '';
const match = text.match(/```html?\s*([\s\S]*?)```/);
if (match) text = match[1].trim();
const docIndex = text.indexOf('<!DOCTYPE');
if (docIndex > 0) text = text.substring(docIndex);
const htmlEnd = text.lastIndexOf('</html>');
if (htmlEnd !== -1) text = text.substring(0, htmlEnd + 7);
return [{ json: { html: text } }];
```

---

## n8n Export/Import — Quirks del JSON

| Comportamiento | Detalle |
|---------------|---------|
| IDs de nodos | Se regeneran al importar |
| Posiciones | Se recalculan |
| HTTP Request sin auth | No incluir `authentication` ni `genericAuthType` |
| Webhook GET | n8n omite `httpMethod` (es el default) |
| Postgres | n8n agrega `"options": {}` aunque no se configuró nada |
| Sticky Notes duplicadas | n8n agrega sufijo "1" si hay conflicto de nombre |
| IF Node boolean | Operación `"true"` (no `"exists"`) cuando evalúa true/false |
| Settings | n8n agrega `"binaryMode": "separate"` automáticamente |

---

## Resource Locator Pattern

Común en todos los nodos que referencian recursos (tablas, bases, calendarios):

```json
{
  "__rl": true,
  "value": "ID_REAL",
  "mode": "list",
  "cachedResultName": "Nombre visible en la UI"
}
```

---

## Nodos por servicio — Tipos y versiones usados

| Servicio | Tipo de nodo | typeVersion |
|----------|-------------|-------------|
| Telegram Trigger | `n8n-nodes-base.telegramTrigger` | 1.2 |
| Telegram Actions | `n8n-nodes-base.telegram` | 1.2 |
| OpenAI (Whisper/TTS/Vision) | `@n8n/n8n-nodes-langchain.openAi` | 2 |
| LLM Chain | `@n8n/n8n-nodes-langchain.chainLlm` | 1.4 |
| Chat Model | `@n8n/n8n-nodes-langchain.lmChatOpenAi` | 1.2 |
| Postgres | `n8n-nodes-base.postgres` | 2.5 |
| IF | `n8n-nodes-base.if` | 2.2 |
| Set | `n8n-nodes-base.set` | 3.4 |
| Code | `n8n-nodes-base.code` | 2 |
| HTTP Request | `n8n-nodes-base.httpRequest` | 4.2 |
| Webhook | `n8n-nodes-base.webhook` | 2 |
| Respond to Webhook | `n8n-nodes-base.respondToWebhook` | 1.1 |

---

## Sprint 7 — WhatsApp + AI Agent

### Eventos de estado de Meta (entregan/leídos) vs mensajes reales

Meta envía dos tipos de payload al mismo webhook: mensajes reales (`messages`) y notificaciones de estado (`statuses`). El Code node de parseo DEBE verificar que `messages` existe antes de continuar:

```javascript
const messages = change?.messages;
if (!messages || messages.length === 0) {
  return [{ json: { skip: true } }];
}
```

Sin este check, el flujo falla con `TypeError` cada vez que un mensaje es entregado o leído.

---

### Conexión paralela desde un nodo hacia dos nodos

Para ejecutar dos nodos en paralelo desde uno (ej: nodo 05 → nodo 06 Y nodo 07 simultáneamente), en el JSON las conexiones del nodo de origen deben estar en el **mismo array interno** de `main[0]`:

```json
"05 - Crear Deal": {
  "main": [
    [
      { "node": "06 - Responder WhatsApp", "type": "main", "index": 0 },
      { "node": "07 - Notificar Equipo", "type": "main", "index": 0 }
    ]
  ]
}
```

Si se ponen en arrays separados (`main[0]` y `main[1]`), n8n los trata como ramas del mismo IF, no como paralelo.

---

### $fromAI() en tool nodes del AI Agent

Cuando un nodo es una tool del AI Agent, usa `$fromAI('nombre', 'descripción')` para recibir parámetros del agente en tiempo de ejecución:

```javascript
// En HTTP Request body (campo jsonBody o en expresiones de campos):
"to": "={{ $fromAI('telefono', 'Número de teléfono del destinatario') }}"

// En Kommo Update Deal:
dealId: "={{ $fromAI('deal_id', 'ID numérico del deal a actualizar') }}"
```

- Nombre del parámetro: snake_case, descriptivo
- Descripción: lo que el LLM lee para saber qué valor proporcionar — cuanto más específica, mejor
- Solo funciona dentro de nodos conectados via `ai_tool` al nodo AI Agent

---

### AI Agent — output en $json.output, no en $json.text

| Nodo | Campo de salida |
|------|----------------|
| chainLlm | `$json.text` |
| AI Agent | `$json.output` |

Error común: parsear `$json.text` en el Code node que procesa la respuesta del agente → devuelve undefined. Usar siempre `$json.output` para agentes.

---

### Wait node y persistencia

Los nodos `Wait` (para secuencias con intervalos de tiempo) solo funcionan correctamente si n8n usa una base de datos persistente (PostgreSQL). Con SQLite en-memory, si n8n se reinicia los Wait nodes en ejecución se pierden.

Para el diplomado (demo en clase): cambiar a 1-5 minutos para no esperar 24h. Revertir antes de entregar al cliente.

---

## Recursos adicionales

- [README.md](resources/README.md)

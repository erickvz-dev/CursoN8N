# Meta WhatsApp Cloud API — Endpoints

Configuración exacta de los endpoints de WhatsApp usados en el diplomado.

**Nota crítica:** Todos los ejemplos usan HTTP Request v4.2 con Header Auth (Authorization: Bearer TOKEN). No existe nodo nativo de n8n para Meta WhatsApp — todo se construye con nodos HTTP Request.

---

## Endpoint 1: Enviar Mensaje de Texto

Envía un mensaje de texto plano al número del remitente.

### Configuración del nodo HTTP Request

```json
{
  "method": "POST",
  "url": "=https://graph.facebook.com/v18.0/{{ $json.phone_number_id }}/messages",
  "sendHeaders": true,
  "headerParameters": {
    "parameters": [
      {
        "name": "Authorization",
        "value": "=Bearer {{ $json.access_token }}"
      },
      {
        "name": "Content-Type",
        "value": "application/json"
      }
    ]
  },
  "sendBody": true,
  "specifyBody": "json",
  "jsonBody": "",
  "options": {}
}
```

### Body JSON

```json
{
  "messaging_product": "whatsapp",
  "to": "={{ $json.telefono }}",
  "type": "text",
  "text": {
    "body": "={{ $json.respuesta }}"
  }
}
```

### Response esperado

```json
{
  "messaging_product": "whatsapp",
  "contacts": [
    { "input": "521234567890", "wa_id": "521234567890" }
  ],
  "messages": [
    { "id": "wamid.HBgLNTIxMjM0NTY3ODkwFQIAERgSM..." }
  ]
}
```

### Expresiones de extracción

| Campo | Expresión | Uso |
|---|---|---|
| ID del mensaje enviado | `{{ $json.messages[0].id }}` | Confirmar entrega, logs |
| wa_id del contacto | `{{ $json.contacts[0].wa_id }}` | Verificar número normalizado |

### Nombre del nodo

`WhatsApp: Enviar Texto`

---

## Endpoint 2: Enviar Mensaje con Botones Interactivos

Envía una pregunta con hasta 3 botones de respuesta rápida. Límite estricto: máx 3 botones tipo `reply`. Para más opciones usar `type: "list"`.

### Body JSON

```json
{
  "messaging_product": "whatsapp",
  "to": "={{ $json.telefono }}",
  "type": "interactive",
  "interactive": {
    "type": "button",
    "body": {
      "text": "={{ $json.pregunta }}"
    },
    "action": {
      "buttons": [
        {
          "type": "reply",
          "reply": {
            "id": "opcion_1",
            "title": "Sí, me interesa"
          }
        },
        {
          "type": "reply",
          "reply": {
            "id": "opcion_2",
            "title": "No por ahora"
          }
        },
        {
          "type": "reply",
          "reply": {
            "id": "opcion_3",
            "title": "Más información"
          }
        }
      ]
    }
  }
}
```

**Nota:** El campo `title` de cada botón tiene un límite de 20 caracteres. El campo `id` es el valor que regresa en el webhook cuando el usuario toca el botón — úsalo para el routing en el nodo IF o Switch.

### Cómo extraer la respuesta del botón (payload de regreso)

Cuando el usuario toca un botón, Meta envía un webhook con esta estructura:

```javascript
// ID del botón presionado
{{ $json.body.entry[0].changes[0].value.messages[0].interactive.button_reply.id }}

// Texto del botón presionado
{{ $json.body.entry[0].changes[0].value.messages[0].interactive.button_reply.title }}

// Tipo de mensaje (será "interactive")
{{ $json.body.entry[0].changes[0].value.messages[0].type }}
```

### Nombre del nodo

`WhatsApp: Enviar Botones`

---

## Endpoint 3: Enviar Template (fuera de ventana 24h)

Fuera de la ventana de 24h desde el último mensaje del usuario, solo se pueden enviar templates aprobados en Meta Business Manager.

### Body JSON

```json
{
  "messaging_product": "whatsapp",
  "to": "={{ $json.telefono }}",
  "type": "template",
  "template": {
    "name": "hello_world",
    "language": {
      "code": "es_MX"
    }
  }
}
```

**Nota:** Solo templates con estado `APPROVED` en Meta Business Manager funcionan fuera de la ventana de 24h. `hello_world` es el template de prueba que Meta provee por defecto. Para templates con variables usar el campo `components`.

### Template con variable de texto

```json
{
  "messaging_product": "whatsapp",
  "to": "={{ $json.telefono }}",
  "type": "template",
  "template": {
    "name": "nombre_del_template",
    "language": { "code": "es_MX" },
    "components": [
      {
        "type": "body",
        "parameters": [
          {
            "type": "text",
            "text": "={{ $json.nombre }}"
          }
        ]
      }
    ]
  }
}
```

### Nombre del nodo

`WhatsApp: Enviar Template`

---

## Extraer datos del webhook (payload entrante)

Expresiones n8n para el payload que llega al Webhook Trigger cuando un usuario envía un mensaje:

```javascript
// Verificar que es un mensaje real (undefined si es delivery receipt)
{{ $json.body.entry[0].changes[0].value.messages }}

// Número del remitente
{{ $json.body.entry[0].changes[0].value.messages[0].from }}

// Texto del mensaje
{{ $json.body.entry[0].changes[0].value.messages[0].text.body }}

// Nombre del contacto
{{ $json.body.entry[0].changes[0].value.contacts[0].profile.name }}

// Tipo de mensaje (text, audio, image, interactive, etc.)
{{ $json.body.entry[0].changes[0].value.messages[0].type }}
```

**IMPORTANTE:** Los datos llegan en `$json.body`, no en `$json` directamente. Esta es una diferencia clave respecto a otros webhooks.

---

## Filtro de Delivery Receipts (CRÍTICO)

Meta envía eventos de tipo "status" (delivered, read, sent) además de los mensajes reales. Estos eventos **no tienen el campo `messages`**. Si no se filtra, el workflow se dispara múltiples veces por cada mensaje que el usuario envía.

### Nodo IF — inmediatamente después del Webhook Trigger

| Campo | Valor |
|---|---|
| Condición | `{{ $json.body.entry[0].changes[0].value.messages }}` |
| Operación | `exists` |
| Rama TRUE | Continúa al procesamiento del mensaje |
| Rama FALSE | No Operation (terminar el workflow) |

### Configuración del nodo IF

```json
{
  "conditions": {
    "options": {
      "caseSensitive": true,
      "leftValue": "",
      "typeValidation": "strict"
    },
    "conditions": [
      {
        "id": "filtro-messages",
        "leftValue": "={{ $json.body.entry[0].changes[0].value.messages }}",
        "rightValue": "",
        "operator": {
          "type": "object",
          "operation": "exists",
          "singleValue": true
        }
      }
    ],
    "combinator": "and"
  }
}
```

### Nombre del nodo

`IF: ¿Es mensaje real?`

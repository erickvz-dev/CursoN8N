# Payloads de Prueba — Sprint 7

Payloads reales para testear los flujos de Sprint 7 **sin necesitar conexiones activas**.

Cómo usarlos: en n8n, abre el Webhook Trigger → haz clic en **"Listen for test event"** → en otra terminal o cliente HTTP, envía el payload con `curl` o usa el botón **"Test step"** pegando el JSON directamente.

---

## Meta WhatsApp — Mensaje de Texto Entrante

Payload que Meta envía a tu webhook cuando alguien escribe por WhatsApp.

```json
{
  "object": "whatsapp_business_account",
  "entry": [
    {
      "id": "WHATSAPP_BUSINESS_ACCOUNT_ID",
      "changes": [
        {
          "value": {
            "messaging_product": "whatsapp",
            "metadata": {
              "display_phone_number": "15551234567",
              "phone_number_id": "TU_PHONE_NUMBER_ID"
            },
            "contacts": [
              {
                "profile": {
                  "name": "María García"
                },
                "wa_id": "521234567890"
              }
            ],
            "messages": [
              {
                "from": "521234567890",
                "id": "wamid.ABGGFlCGg0cvAgo6tHcNmNjXmuSzLDMIzYXcjGJqcnc",
                "timestamp": "1699999999",
                "text": {
                  "body": "Hola, quiero información sobre catering para 50 personas en enero"
                },
                "type": "text"
              }
            ]
          },
          "field": "messages"
        }
      ]
    }
  ]
}
```

**Para extraer datos de este payload en n8n:**
```javascript
// Teléfono
$json.body.entry[0].changes[0].value.messages[0].from
// → "521234567890"

// Nombre
$json.body.entry[0].changes[0].value.contacts[0].profile.name
// → "María García"

// Mensaje
$json.body.entry[0].changes[0].value.messages[0].text.body
// → "Hola, quiero información sobre catering para 50 personas en enero"
```

---

## Meta WhatsApp — Evento de Estado (entregado/leído)

Este payload llega cuando Meta notifica que un mensaje fue entregado o leído. El flujo debe ignorarlo (el Code node de parseo detecta que `messages` es undefined y devuelve `{skip: true}`).

```json
{
  "object": "whatsapp_business_account",
  "entry": [
    {
      "id": "WHATSAPP_BUSINESS_ACCOUNT_ID",
      "changes": [
        {
          "value": {
            "messaging_product": "whatsapp",
            "metadata": {
              "display_phone_number": "15551234567",
              "phone_number_id": "TU_PHONE_NUMBER_ID"
            },
            "statuses": [
              {
                "id": "wamid.ABGGFlCGg0cvAgo6tHcNmNjXmuSzLDMIzYXcjGJqcnc",
                "recipient_id": "521234567890",
                "status": "delivered",
                "timestamp": "1699999999",
                "conversation": {
                  "id": "CONVERSATION_ID",
                  "expiration_timestamp": "1700000000",
                  "origin": { "type": "service" }
                }
              }
            ]
          },
          "field": "messages"
        }
      ]
    }
  ]
}
```

**Qué pasa en el Code node:**
```javascript
const messages = change?.messages;
// messages es undefined en este caso
if (!messages || messages.length === 0) {
  return [{ json: { skip: true } }];
  // El flujo se detiene aquí — correcto
}
```

---

## Meta WhatsApp — Verificación de Webhook (GET)

Cuando registras el webhook en Meta Developer Portal, Meta hace una petición GET. Este es el query string que llega:

```
GET /webhook/whatsapp-captura?hub.mode=subscribe&hub.verify_token=diplomado2024&hub.challenge=1234567890
```

En n8n, el Webhook Trigger lo recibe como:

```json
{
  "query": {
    "hub.mode": "subscribe",
    "hub.verify_token": "diplomado2024",
    "hub.challenge": "1234567890"
  }
}
```

**La respuesta correcta:** El webhook debe responder con `$json.query['hub.challenge']` = `"1234567890"`

---

## Meta WhatsApp — Mensaje con Botón Interactivo (respuesta de usuario)

Cuando el usuario hace clic en un botón de respuesta rápida:

```json
{
  "object": "whatsapp_business_account",
  "entry": [
    {
      "changes": [
        {
          "value": {
            "messages": [
              {
                "from": "521234567890",
                "id": "wamid.XXX",
                "timestamp": "1699999999",
                "type": "interactive",
                "interactive": {
                  "type": "button_reply",
                  "button_reply": {
                    "id": "si",
                    "title": "Sí, me interesa"
                  }
                }
              }
            ],
            "contacts": [
              {
                "profile": { "name": "María García" },
                "wa_id": "521234567890"
              }
            ]
          }
        }
      ]
    }
  ]
}
```

**Para extraer el ID del botón:**
```javascript
$json.body.entry[0].changes[0].value.messages[0].interactive.button_reply.id
// → "si"
```

---

## Kommo CRM — Webhook de Cambio de Etapa

Payload que Kommo envía cuando un deal se mueve de etapa.

```json
{
  "leads": {
    "status": [
      {
        "id": 12345,
        "status_id": 67890,
        "pipeline_id": 11111,
        "responsible_user_id": 22222,
        "old_status_id": 33333
      }
    ]
  },
  "account": {
    "subdomain": "miempresa",
    "id": 9999999
  }
}
```

**Llega a n8n como:**
```javascript
// ID del deal
$json.body.leads.status[0].id
// → 12345

// ID de la nueva etapa (comparar contra ID_ETAPA_NURTURING)
$json.body.leads.status[0].status_id
// → 67890

// ID de la etapa anterior
$json.body.leads.status[0].old_status_id
// → 33333
```

**Cómo encontrar tu ID_ETAPA_NURTURING:**
1. Mueve manualmente un deal a la etapa "Nurturing" en Kommo
2. El webhook llega a n8n con `status_id` = el ID de esa etapa
3. Copia ese número y úsalo en el nodo IF del flujo de Nurturing

---

## Cómo simular una ejecución completa (sin WhatsApp real)

### Método 1: curl desde terminal

```bash
# Flujo de Captura de Prospectos (S13)
curl -X POST "URL_DE_TU_WEBHOOK_EN_N8N/webhook/whatsapp-captura" \
  -H "Content-Type: application/json" \
  -d '{
    "object": "whatsapp_business_account",
    "entry": [{
      "changes": [{
        "value": {
          "messages": [{
            "from": "521234567890",
            "id": "wamid.test123",
            "timestamp": "1699999999",
            "text": {"body": "Hola, necesito catering para 80 personas el 15 de enero, ¿tienen disponibilidad?"},
            "type": "text"
          }],
          "contacts": [{"profile": {"name": "Carlos Mendoza"}, "wa_id": "521234567890"}]
        }
      }]
    }]
  }'
```

### Método 2: Pegar JSON en n8n "Test step"

1. Abre el nodo `02 - Parsear Mensaje` en n8n
2. Clic en **"Test step"** → **"Use mock data"**
3. Pega el payload del Meta WhatsApp (Mensaje de Texto Entrante de arriba)
4. Clic en **"Execute step"**
5. Verifica la salida: debe mostrar `telefono`, `nombre`, `mensaje`

### Método 3: n8n "Webhook test URL"

n8n te da una URL de test diferente a la de producción:
- **Test URL:** `http://localhost:5678/webhook-test/whatsapp-captura`
- **Production URL:** `http://localhost:5678/webhook/whatsapp-captura`

Usa la URL de test durante el desarrollo. El flujo debe estar abierto en el editor.

---

## Mensajes de prueba recomendados para el Calificador IA

Enviar estos mensajes (o simularlos) para verificar el scoring del calificador:

| Mensaje | Score esperado | Por qué |
|---------|---------------|---------|
| "Hola" | 1-3 | Sin información de intención |
| "Quiero info sobre catering" | 3-4 | Intención pero sin detalles |
| "Necesito catering corporativo para mi empresa" | 5-6 | Tipo definido, sin cantidad ni fecha |
| "Busco catering para 50 personas en diciembre" | 7-8 | Cantidad + mes definidos |
| "Quiero apartar el servicio para el 15 de enero, somos 80 personas y ya tenemos presupuesto aprobado" | 9-10 | Fecha exacta + cantidad + urgencia confirmada |

---

## Variables que debes reemplazar

Antes de usar los payloads en producción, reemplaza:

| Placeholder | Dónde obtenerlo |
|-------------|----------------|
| `TU_PHONE_NUMBER_ID` | Meta Developer Portal → WhatsApp → API Setup → Phone Number ID |
| `521234567890` | El número de teléfono real del prospecto (con código de país) |
| `WHATSAPP_BUSINESS_ACCOUNT_ID` | Meta Developer Portal → WhatsApp → API Setup |
| `ID_ETAPA_NURTURING` | El `status_id` que llega del webhook cuando mueves un deal a Nurturing |
| `12345` (deal ID) | Lo devuelve Kommo cuando creas el deal en el flujo de S13 |

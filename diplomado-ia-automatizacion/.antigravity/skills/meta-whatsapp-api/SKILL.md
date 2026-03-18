# Skill — Meta WhatsApp Cloud API

## Cuándo se activa

Cuando el alumno construye flujos que envían o reciben mensajes por WhatsApp usando la API oficial de Meta (Sprint 7).

---

## Autenticación

No hay nodo nativo de n8n para Meta WhatsApp. Se usa **HTTP Request** con Header Authentication:

```
Authorization: Bearer {ACCESS_TOKEN}
Content-Type: application/json
```

El Access Token se obtiene en: developers.facebook.com → tu app → WhatsApp → API Setup.

**Token temporal (24h):** disponible directo en el panel. Útil para pruebas.
**Token de larga duración:** requiere intercambio via Graph API (`/oauth/access_token`). Para producción.

---

## Número de prueba (sin verificación de negocio)

Meta provee un número de prueba gratuito en el Developer Portal. Limitaciones:

- Solo puede enviar mensajes a números previamente registrados en "To" (máx 5)
- Esos números deben enviar primero un mensaje al número de prueba para "abrirlo"
- Para usarlo: el alumno agrega su WhatsApp personal como número receptor y lo verifica con un código

**Phone Number ID:** visible en WhatsApp → API Setup. Es un número largo (ej: `102938475647382`). No confundir con el número de teléfono.

---

## Recibir mensajes (Webhook)

### Configuración en Meta Developer Portal

1. App → WhatsApp → Configuration → Webhook
2. URL: URL de producción del Webhook Trigger de n8n (no la de test)
3. Verify Token: cualquier string que se configure también en n8n
4. Suscribir a: `messages`

### Estructura del payload que llega a n8n

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
                "timestamp": "1234567890",
                "text": { "body": "Hola, quiero info" },
                "type": "text"
              }
            ],
            "contacts": [
              {
                "profile": { "name": "Juan Pérez" },
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

### Expresiones para extraer datos del webhook

```javascript
// Número del remitente
{
  {
    $json.body.entry[0].changes[0].value.messages[0].from;
  }
}

// Texto del mensaje
{
  {
    $json.body.entry[0].changes[0].value.messages[0].text.body;
  }
}

// Nombre del contacto
{
  {
    $json.body.entry[0].changes[0].value.contacts[0].profile.name;
  }
}
```

**IMPORTANTE:** Los datos llegan en `$json.body`, no en `$json` directamente.

---

## Enviar mensajes

### Endpoint

```
POST https://graph.facebook.com/v18.0/{PHONE_NUMBER_ID}/messages
```

### Body — mensaje de texto simple

```json
{
  "messaging_product": "whatsapp",
  "to": "521234567890",
  "type": "text",
  "text": { "body": "Hola, gracias por contactarnos" }
}
```

### Body — mensaje con botones (interactive)

```json
{
  "messaging_product": "whatsapp",
  "to": "521234567890",
  "type": "interactive",
  "interactive": {
    "type": "button",
    "body": { "text": "¿Te interesa nuestro servicio de catering?" },
    "action": {
      "buttons": [
        {
          "type": "reply",
          "reply": { "id": "si", "title": "Sí, me interesa" }
        },
        { "type": "reply", "reply": { "id": "no", "title": "No por ahora" } }
      ]
    }
  }
}
```

---

## Verificación del webhook (handshake inicial)

Meta hace una petición GET al webhook para verificarlo. n8n debe responder con el `hub.challenge`.

Configurar el Webhook Trigger de n8n para responder:

- **Respond:** Immediately
- **Response Code:** 200
- **Response Body:** `{{ $json.query['hub.challenge'] }}`

Solo aplica en el momento de registrar el webhook. Después, las peticiones son POST.

---

## Gotchas de producción

- El webhook debe estar en la URL de **producción** de n8n (no test) para que Meta lo alcance
- Meta envía una petición GET de verificación al registrar el webhook — si n8n no responde 200 con el challenge, el registro falla
- Los mensajes de WhatsApp solo se pueden enviar dentro de una **ventana de 24 horas** desde el último mensaje del usuario (política de Meta). Fuera de esa ventana solo se pueden enviar templates aprobados
- Para testing no necesitas templates — usa la ventana de 24h libremente

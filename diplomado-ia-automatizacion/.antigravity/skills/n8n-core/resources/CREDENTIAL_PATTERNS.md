# Patrones de Credenciales en n8n

Cómo configurar y referenciar credenciales en workflows del diplomado.

---

## Regla de Seguridad

**NUNCA hardcodees API keys, tokens o contraseñas en el JSON del workflow.**

Usa siempre el sistema de Credentials de n8n:
- n8n → Settings → Credentials → Create Credential
- Las credenciales se referencian por `id` y `name`, no por valor

```json
// MAL — API key visible en el JSON
"headerParameters": {
  "parameters": [
    { "name": "X-Api-Key", "value": "sk_V2_hgu_real_key_aqui" }
  ]
}

// BIEN — referencia a credencial de n8n
"credentials": {
  "httpHeaderAuth": { "id": "ABC123", "name": "HeyGen API Key" }
}
```

---

## Patrón 1: OAuth2 Genérico

**Usado por:** Canva

```json
{
  "authentication": "genericCredentialType",
  "genericAuthType": "oAuth2Api"
}
```

Con referencia a la credencial:

```json
"credentials": {
  "oAuth2Api": {
    "id": "TU_CREDENTIAL_ID",
    "name": "CANVA API"
  }
}
```

n8n maneja automáticamente:
- Token refresh
- Bearer token injection en headers
- Flujo de autorización OAuth2

---

## Patrón 2: Header Auth Estático

**Usado por:** HeyGen (`X-Api-Key`), OpenAI manual (`Authorization: Bearer`)

### Opción A: Header manual en el nodo HTTP Request

```json
"sendHeaders": true,
"headerParameters": {
  "parameters": [
    {
      "name": "X-Api-Key",
      "value": "={{ $json.heygen_api_key }}"
    }
  ]
}
```

La API key se almacena en un nodo Set previo o en una variable de entorno, NO directamente en el valor.

### Opción B: Credencial Header Auth de n8n

```json
"authentication": "genericCredentialType",
"genericAuthType": "httpHeaderAuth"
```

```json
"credentials": {
  "httpHeaderAuth": {
    "id": "TU_CREDENTIAL_ID",
    "name": "OpenAI API Key"
  }
}
```

Esta opción es preferible porque la key queda cifrada en n8n.

---

## Patrón 3: Credenciales Nativas

**Usado por:** Telegram, Google Sheets, Google Calendar, Postgres, Gmail

n8n tiene nodos dedicados con sus propios tipos de credencial:

```json
"credentials": {
  "telegramApi": {
    "id": "TU_CREDENTIAL_ID",
    "name": "Telegram account"
  }
}
```

### Tipos de credencial por servicio

| Servicio | Tipo de credencial | Sprints |
|---|---|---|
| Telegram Bot | `telegramApi` | S01, S05, S06 |
| OpenAI (nodo nativo) | `openAiApi` | S01, S02, S03 |
| Google Sheets | `googleSheetsOAuth2Api` | S01, S02 |
| Google Calendar | `googleCalendarOAuth2Api` | S01 |
| Gmail | `gmailOAuth2` | S03 |
| Postgres (Supabase) | `postgres` | S05, S06 |
| Airtable | `airtableTokenApi` | S04 |

### Configuración de Postgres para Supabase

```
Host:     db.XXXX.supabase.co
Port:     5432
Database: postgres
User:     postgres
Password: [password del proyecto]
SSL:      Activado (obligatorio)
```

---

## Credenciales por Sprint

### Sprint 1 — Asistente de Voz

| Credencial | Tipo |
|---|---|
| `TELEGRAM_BOT_TOKEN` | telegramApi |
| `OPENAI_API_KEY` | openAiApi |
| `GOOGLE_CALENDAR_CREDENTIALS` | googleCalendarOAuth2Api (OAuth2) |

### Sprint 2 — Producción Visual

| Credencial | Tipo |
|---|---|
| `OPENAI_API_KEY` | openAiApi |
| `CANVA_API_KEY` | oAuth2Api (genérico) |
| `HEYGEN_API_KEY` | httpHeaderAuth (genérico) |
| `GOOGLE_SHEETS_CREDENTIALS` | googleSheetsOAuth2Api |

### Sprint 3 — Marketing & Orquestación

| Credencial | Tipo |
|---|---|
| `OPENAI_API_KEY` | openAiApi |
| `CANVA_API_KEY` | oAuth2Api |
| `INSTAGRAM_ACCESS_TOKEN` | httpHeaderAuth |
| `FACEBOOK_PAGE_ID` | variable en nodo Set |

### Sprint 4 — Recursos Humanos

| Credencial | Tipo |
|---|---|
| `OPENAI_API_KEY` | openAiApi |
| `AIRTABLE_API_KEY` | airtableTokenApi |
| `SMTP_*` | Credencial SMTP nativa |

### Sprint 5 — Operaciones & Gastos

| Credencial | Tipo |
|---|---|
| `TELEGRAM_BOT_TOKEN` | telegramApi |
| `OPENAI_API_KEY` | openAiApi o httpHeaderAuth |
| `SUPABASE_*` | postgres (conexión directa) |

### Sprint 6 — Finanzas

| Credencial | Tipo |
|---|---|
| `OPENAI_API_KEY` | openAiApi (incluye TTS gpt-4o-mini-tts y Whisper) |
| `TELEGRAM_BOT_TOKEN` | telegramApi |
| `SUPABASE_URL` / `SUPABASE_SERVICE_KEY` | postgres |

### Sprint 7 — Ventas & Capstone

| Credencial | Tipo |
|---|---|
| `HUBSPOT_API_KEY` | httpHeaderAuth |
| `KOMMO_API_KEY` | httpHeaderAuth |
| `WHATSAPP_BUSINESS_TOKEN` | httpHeaderAuth |
| `MANYCHAT_API_KEY` | httpHeaderAuth |

---

## Patrón de Reutilización

Cuando múltiples nodos usan la misma credencial (ej: todos los nodos Telegram de un workflow), comparten el mismo `id`:

```json
// Nodo 1: Telegram Trigger
"credentials": { "telegramApi": { "id": "xVHAjlbHy3mILPIX", "name": "Bot Gastos" } }

// Nodo 2: Telegram Send Message
"credentials": { "telegramApi": { "id": "xVHAjlbHy3mILPIX", "name": "Bot Gastos" } }
```

El `id` es el mismo — apunta a la misma credencial almacenada en n8n.

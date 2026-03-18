# Registry de Credenciales n8n

IDs de credenciales que cada alumno debe configurar en su propia instancia de n8n. Al importar workflows, n8n pedirá reasignar credenciales si los IDs no coinciden.

## Credenciales por servicio

| Servicio                | Tipo en n8n               | Credential ID      | Nombre en n8n           | Sprints que la usan |
| ----------------------- | ------------------------- | ------------------ | ----------------------- | ------------------- |
| OpenAI                  | `openAiApi`               | `TU_CREDENTIAL_ID` | OpenAi account          | 1, 2, 3, 4, 5, 6    |
| Airtable                | `airtableOAuth2Api`       | `TU_CREDENTIAL_ID` | Airtable account        | 2, 3, 4             |
| Gmail                   | `gmailOAuth2`             | `TU_CREDENTIAL_ID` | Gmail account           | 4                   |
| Google Calendar         | `googleCalendarOAuth2Api` | `TU_CREDENTIAL_ID` | Google Calendar account | 4                   |
| Telegram Bot            | `telegramApi`             | `TU_CREDENTIAL_ID` | Telegram account        | 1, 5, 6             |
| PostgreSQL (Supabase)   | `postgres`                | `TU_CREDENTIAL_ID` | BD Gastos               | 5, 6                |
| Meta WhatsApp Cloud API | HTTP Request (Bearer)     | `TU_CREDENTIAL_ID` | Meta WhatsApp           | 7                   |
| Kommo CRM               | `kommoLongLivedApi`       | `TU_CREDENTIAL_ID` | Kommo account           | 7                   |

## Formato en JSON de workflow

```json
"credentials": {
  "openAiApi": {
    "id": "TU_CREDENTIAL_ID",
    "name": "OpenAi account"
  }
}
```

```json
"credentials": {
  "telegramApi": {
    "id": "TU_CREDENTIAL_ID",
    "name": "Telegram account"
  }
}
```

```json
"credentials": {
  "postgres": {
    "id": "TU_CREDENTIAL_ID",
    "name": "BD Gastos"
  }
}
```

```json
"credentials": {
  "airtableOAuth2Api": {
    "id": "TU_CREDENTIAL_ID",
    "name": "Airtable account"
  }
}
```

## Telegram Bot Token (para HTTP Requests directos)

Cuando el nodo nativo de Telegram no soporta una operación (inline keyboard, sendVoice, answerCallbackQuery), se usa HTTP Request directo a la API de Telegram con el token del bot en la URL:

```
https://api.telegram.org/bot{TU_BOT_TOKEN}/{method}
```

> **Nota:** El token del bot se obtiene de @BotFather en Telegram. Cada alumno tiene su propio token. Nunca versionar tokens reales en el repositorio.

## Sprint 7 — Credenciales nuevas

### Meta WhatsApp Cloud API

No usa nodo nativo de n8n. Se configura como Header Auth en un nodo **HTTP Request**:

- **Auth type:** `Bearer Token`
- **Token:** Access Token del Developer Portal de Meta
- **Phone Number ID:** visible en la consola de Meta (no es el número de teléfono)

```
Enviar mensaje: POST https://graph.facebook.com/v18.0/{PHONE_NUMBER_ID}/messages
Headers: Authorization: Bearer {ACCESS_TOKEN}, Content-Type: application/json
```

### Kommo Long-Lived Token

Requiere instalar el nodo de comunidad `n8n-nodes-kommo` desde:
**n8n UI → Settings → Community Nodes → Install → `n8n-nodes-kommo`**

- **Tipo de credencial en n8n:** `Kommo Long-Lived API`
- **Token:** obtenido en Kommo → Settings → Integrations → crear integración privada
- **Subdomain:** la parte antes de `.kommo.com` de tu URL (ej: `miempresa`)

---

## Cómo obtener tus Credential IDs

1. En n8n, ve a **Credentials** y abre la credencial que quieres usar.
2. El ID aparece en la URL del navegador: `https://tu-instancia.n8n.cloud/credentials/TU_ID`
3. Anota ese ID y úsalo al construir workflows con el agente.

## Notas

- Los credential IDs son generados por n8n y son estables — no cambian al reimportar workflows
- Al importar un workflow, n8n pide reasignar credenciales si los IDs no coinciden
- Si un colaborador tiene credenciales diferentes, solo necesita reasignar una vez por tipo

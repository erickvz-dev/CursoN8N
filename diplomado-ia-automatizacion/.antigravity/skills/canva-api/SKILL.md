---
name: canva-api
description: Integración con Canva REST API para upload de assets y creación de diseños automatizados. Use when subiendo imágenes a Canva, creando diseños automatizados, implementando polling de asset uploads, o configurando OAuth2 de Canva en n8n.
---

# Canva API

Automatización de diseños con Canva REST API desde n8n.

---

## Quick Start

Pipeline mínimo para crear un diseño en Canva:

```
1. POST /rest/v1/asset-uploads    → subir imagen → obtener job.id
2. GET  /rest/v1/asset-uploads/X  → poll hasta status="success" → obtener asset.id
3. POST /rest/v1/designs          → crear diseño con asset_id → obtener edit_url
```

---

## Autenticación

Canva usa **OAuth2** gestionado automáticamente por n8n:

```json
{
  "authentication": "genericCredentialType",
  "genericAuthType": "oAuth2Api"
}
```

```json
"credentials": {
  "oAuth2Api": {
    "id": "TU_CREDENTIAL_ID",
    "name": "CANVA API"
  }
}
```

n8n maneja el token refresh automáticamente. No necesitas enviar headers de autorización manualmente.

---

## Los 3 Endpoints

| # | Método | Endpoint | Propósito |
|---|---|---|---|
| 1 | POST | `/rest/v1/asset-uploads` | Subir imagen como binary |
| 2 | GET | `/rest/v1/asset-uploads/{job_id}` | Poll status del upload |
| 3 | POST | `/rest/v1/designs` | Crear diseño desde asset |

→ Configuración exacta de headers, body y response en [ENDPOINTS.md](resources/ENDPOINTS.md)

---

## Patrón Asíncrono (Polling)

Canva procesa uploads de forma asíncrona. El flujo es:

```
Upload Asset (POST)
    ↓
Wait 2 segundos
    ↓
Poll Status (GET)
    ↓
¿status == "success"?
  ├─ SÍ → Create Design (POST)
  └─ NO → ¿Falló o timeout?
           ├─ Falló → Reportar error
           └─ No → Volver a Wait
```

### Versión simple (Sprint 02)

- Wait 2s → Poll → IF success → Create Design
- Sin límite de intentos (riesgo de loop infinito)

### Versión robusta (Sprint 03)

- `maxAttempts: 30` (máximo 60 segundos)
- 3 estados terminales: `success`, `failed`, `timeout`
- Normalización de response shape en Code node

→ Detalle completo con código en [ASYNC_POLLING.md](resources/ASYNC_POLLING.md)

---

## Dimensiones de Diseño

| Tipo de contenido | Width | Height | Ratio |
|---|---|---|---|
| Post (feed) | 1080 | 1080 | 1:1 |
| Story / Reel | 1080 | 1920 | 9:16 |

Expresión para dimensiones dinámicas:

```javascript
"width": {{ $json.tipo === 'post' ? 1080 : 1080 }},
"height": {{ $json.tipo === 'post' ? 1080 : 1920 }}
```

---

## Errores Comunes

### Campo binary incorrecto

```json
// MAL
"inputDataFieldName": "file"

// BIEN
"inputDataFieldName": "data"
```

El campo debe coincidir con el nombre del output binario del nodo anterior (Gemini genera `data`).

### Sin límite de intentos en polling

```javascript
// MAL — puede generar loop infinito
// Solo Wait → Poll → IF → loop sin contador

// BIEN
const _state = { attempts: 0, maxAttempts: 30 };
// Cada iteración: _state.attempts++
// Si attempts >= maxAttempts → salir con timeout
```

### Response shape variable

```javascript
// MAL — asumir estructura fija
const status = $json.job.status;

// BIEN — normalizar
const job = $json.job ?? $json.data?.job ?? $json.data ?? $json;
const status = job?.status;
const assetId = job?.asset?.id;
```

### Asset-Upload-Metadata como objeto

```json
// MAL — objeto directo
"Asset-Upload-Metadata": { "name_base64": "abc" }

// BIEN — JSON string
"Asset-Upload-Metadata": "={{ JSON.stringify({ name_base64: 'abc' }) }}"
```

---

## Mejores Prácticas

**Hacer:**
- Usar versión robusta con maxAttempts para polling
- Normalizar response shape con Code node
- Generar `name_base64` dinámicamente con `Buffer.from(filename).toString('base64')`
- Verificar que la credencial OAuth2 tenga token válido antes de ejecutar

**No hacer:**
- Polling sin límite de intentos
- Asumir que el response siempre tiene la misma estructura
- Usar `inputDataFieldName` diferente de `"data"` sin verificar el output binario
- Hardcodear el `name_base64` (funciona para pruebas pero no para producción)

---

## Integración con Otros Skills

| Skill | Relación |
|---|---|
| **n8n-core** | Estructura JSON, credenciales OAuth2 |
| **n8n-workflow-patterns** | Patrón async polling |
| **n8n-code-javascript** | Code node para normalización de response |
| **n8n-expression-syntax** | Expresiones en headers y body |

---

## Recursos Adicionales

- [ENDPOINTS.md](resources/ENDPOINTS.md) — Los 3 endpoints con configuración exacta
- [ASYNC_POLLING.md](resources/ASYNC_POLLING.md) — Patrones de polling simple y robusto

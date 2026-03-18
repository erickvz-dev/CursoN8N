---
name: heygen-api
description: Generación de videos con avatar mediante HeyGen API. Use when creando videos con avatar, generando videos automatizados, configurando HeyGen en n8n, implementando polling de generación de video, o eligiendo dimensiones de video.
---

# HeyGen API

Generación automatizada de videos con avatar desde n8n.

---

## Quick Start

Pipeline mínimo para generar un video con HeyGen:

```
1. POST /v2/video/generate    → crear video → obtener video_id
2. GET  /v1/video_status.get  → poll hasta status="completed" → obtener video_url
```

**Nota crítica:** La creación usa `/v2` pero el polling usa `/v1`. Son versiones diferentes por diseño de HeyGen.

---

## Autenticación

HeyGen usa una **API key estática** enviada como header:

```json
"sendHeaders": true,
"headerParameters": {
  "parameters": [
    { "name": "X-Api-Key", "value": "={{ $json.heygen_api_key }}" },
    { "name": "Content-Type", "value": "application/json" }
  ]
}
```

La API key debe almacenarse en:
- Un nodo Set como variable (para desarrollo)
- n8n Credentials como Header Auth (para producción)

**NUNCA hardcodees la API key directamente en el JSON del workflow.**

---

## Los 2 Endpoints

| # | Método | Endpoint | Versión | Propósito |
|---|---|---|---|---|
| 1 | POST | `/v2/video/generate` | v2 | Crear video con avatar |
| 2 | GET | `/v1/video_status.get` | v1 | Poll status del video |

→ Configuración exacta en [ENDPOINTS.md](resources/ENDPOINTS.md)

---

## Configuración del Video

### Estructura del body

```json
{
  "video_inputs": [{
    "character": {
      "type": "avatar",
      "avatar_id": "ID_DEL_AVATAR",
      "avatar_style": "normal"
    },
    "voice": {
      "type": "text",
      "input_text": "Texto que el avatar va a hablar",
      "voice_id": "ID_DE_LA_VOZ"
    },
    "background": {
      "type": "color",
      "value": "#FFFFFF"
    }
  }],
  "dimension": {
    "width": 720,
    "height": 1280
  },
  "test": false,
  "caption": false
}
```

### Opciones de voz

| Parámetro | Tipo | Default | Descripción |
|---|---|---|---|
| `speed` | number | 1.0 | Velocidad del habla (0.5-2.0) |
| `pitch` | number | 50 | Tono de voz (0-100) |
| `emotion` | string | — | `"Excited"`, `"Serious"`, `"Friendly"` |

---

## Dimensiones y Free Tier

**Free tier de HeyGen limita a 720p máximo. NO uses 1080p.**

| Aspect Ratio | Width | Height | Uso |
|---|---|---|---|
| 9:16 (vertical) | 720 | 1280 | Stories, Reels |
| 1:1 (cuadrado) | 720 | 720 | Posts |
| 16:9 (horizontal) | 1280 | 720 | YouTube, presentaciones |

### Código para calcular dimensiones

```javascript
const ar = ($input.first().json.aspect_ratio || '9:16').trim();
let width = 720, height = 1280;

if (ar === '1:1') { width = 720; height = 720; }
else if (ar === '16:9') { width = 1280; height = 720; }
// default: 9:16 → 720×1280

return [{ json: { ...($input.first().json), _state: { width, height } } }];
```

---

## Patrón Asíncrono (Polling)

HeyGen genera videos de forma asíncrona. Los videos tardan **3-15 minutos** en procesarse.

```
Create Video (POST /v2)
    ↓
Wait 5 minutos
    ↓
Poll Status (GET /v1)
    ↓
¿status == "completed"?
  ├─ SÍ → Guardar video_url
  └─ NO → ¿Falló o timeout?
           ├─ Falló → Reportar error
           └─ No → Volver a Wait
```

- **Wait entre polls:** 5 minutos (mucho más largo que Canva)
- **Max intentos:** 36 (= 3 horas máximo)
- **Status de completado:** `"completed"` (no `"success"` como Canva)

→ Detalle completo en [ASYNC_POLLING.md](resources/ASYNC_POLLING.md)

---

## Errores Comunes

### Version mismatch en endpoints

```
// MAL — usar v2 para polling
GET https://api.heygen.com/v2/video_status.get

// BIEN — polling es v1
GET https://api.heygen.com/v1/video_status.get
```

### Resolución mayor a 720p en free tier

```json
// MAL — free tier rechaza 1080p
"dimension": { "width": 1080, "height": 1920 }

// BIEN — máximo 720p
"dimension": { "width": 720, "height": 1280 }
```

### API key hardcodeada

```json
// MAL — key visible en el JSON del workflow
"value": "sk_V2_hgu_mi_key_real"

// BIEN — referencia a variable
"value": "={{ $json.heygen_api_key }}"
```

### Wait demasiado corto

```
// MAL — HeyGen tarda minutos, no segundos
Wait 2 segundos → genera muchas peticiones innecesarias

// BIEN — 5 minutos entre polls
Wait 5 minutos → respeta la API y da tiempo suficiente
```

### No validar video_id

```javascript
// MAL — asumir que siempre devuelve video_id
const videoId = $json.data.video_id;

// BIEN — validar
const videoId = $input.first().json.data?.video_id;
if (!videoId) {
  throw new Error('HeyGen no devolvió video_id (revisa credenciales/body).');
}
```

---

## Mejores Prácticas

**Hacer:**
- Usar `/v2` para crear y `/v1` para poll (son versiones diferentes)
- Wait de 5 minutos entre polls
- Limitar a 720p en free tier
- Validar `video_id` antes de iniciar polling
- Almacenar API key en n8n Credentials

**No hacer:**
- Hardcodear API keys en el workflow JSON
- Usar 1080p en free tier
- Wait de 2 segundos (genera demasiadas peticiones)
- Asumir que la respuesta siempre tiene `data.video_id`
- Polling sin `maxAttempts`

---

## Integración con Otros Skills

| Skill | Relación |
|---|---|
| **n8n-core** | Estructura JSON, credenciales Header Auth |
| **n8n-workflow-patterns** | Patrón async polling |
| **n8n-code-javascript** | Code node para cálculo de dimensiones y normalización |
| **canva-api** | Mismo patrón de polling pero con tiempos diferentes |

---

## Recursos Adicionales

- [ENDPOINTS.md](resources/ENDPOINTS.md) — Los 2 endpoints con configuración exacta
- [ASYNC_POLLING.md](resources/ASYNC_POLLING.md) — Patrones de polling con timeout

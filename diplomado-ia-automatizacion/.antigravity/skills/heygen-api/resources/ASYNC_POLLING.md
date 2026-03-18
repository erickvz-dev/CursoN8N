# HeyGen API — Patrón de Polling Asíncrono

HeyGen genera videos de forma asíncrona. Los videos tardan **3-15 minutos** en procesarse, mucho más que los uploads de Canva.

---

## Versión Simple (Sprint 02)

### Diagrama

```
Create Video (POST /v2)
    ↓
Edit Fields (extraer video_id)
    ↓
Wait 30 segundos
    ↓
Poll Status (GET /v1)
    ↓
IF data.status == "completed"?
  ├─ TRUE  → Google Sheets: Marcar done
  └─ FALSE → IF data.status == "failed"?
               ├─ TRUE  → Google Sheets: Marcar error
               └─ FALSE → Volver a Wait 30s
```

### Características

- **Wait:** 30 segundos entre polls
- **Sin límite de intentos** — puede loop indefinidamente si status queda en "processing"
- **Detección básica de fallo** — distingue "failed" vs "processing"
- **Uso:** demos y pruebas rápidas

### Extracción de video_id

En el nodo Edit Fields (Set):

```
video_id: {{ $json.data.video_id }}
```

### Condición del IF

```
Value 1: {{ $json.data.status }}
Operation: Equals
Value 2: "completed"
```

### Extracción de error

```
{{ $json.data?.error || $json.data?.message || $json.message || JSON.stringify($json) }}
```

---

## Versión Robusta (Sprint 03)

### Diagrama

```
Create Video (POST /v2)
    ↓
Code: Store video_id + Init State
    ↓
Wait 5 minutos
    ↓
Poll Status (GET /v1)
    ↓
Code: Normalize Poll Result
    ↓
IF status == "completed"?
  ├─ TRUE  → Code: Output Success
  └─ FALSE ↓
      IF status == "failed"?
        ├─ TRUE  → Code: Output Failed
        └─ FALSE ↓
            Code: attempts++
                ↓
            IF attempts < maxAttempts?
              ├─ TRUE  → Volver a Wait 5min
              └─ FALSE → Code: Output Timeout
```

### Características

- **Wait:** 5 minutos entre polls
- **Max intentos:** 36
- **Tiempo máximo:** 36 × 5min = 180 minutos (3 horas)
- **3 estados terminales:** completed, failed, timeout
- **Normalización** para manejar variaciones del response

### Code: Store video_id + Init State

```javascript
const response = $input.first().json;
const videoId = response.data?.video_id;

if (!videoId) {
  throw new Error('HeyGen no devolvió video_id (revisa credenciales/body).');
}

return [{
  json: {
    ...response,
    video_id: videoId,
    _state: {
      attempts: 0,
      maxAttempts: 36
    }
  }
}];
```

### Code: Normalize Poll Result

```javascript
const data = $input.first().json;
const d = data?.data ?? data;
const status = String(d?.status ?? 'unknown').toLowerCase();
const videoUrl = d?.video_url ?? '';

return [{
  json: {
    ...data,
    _poll: {
      status: status,
      video_url: videoUrl
    }
  }
}];
```

### Code: Increment Attempts

```javascript
const input = $input.first().json;
input._state.attempts += 1;

return [{ json: input }];
```

### Output: Success

```javascript
const j = $input.first().json;

return [{
  json: {
    success: true,
    status: 'completed',
    heygen_video_id: j.video_id,
    heygen_video_url: j._poll.video_url,
    video_url: j._poll.video_url
  }
}];
```

### Output: Failed

```javascript
const j = $input.first().json;

return [{
  json: {
    success: false,
    status: 'failed',
    video_id: j.video_id,
    error: 'HeyGen devolvió status=failed'
  }
}];
```

### Output: Timeout

```javascript
const j = $input.first().json;

return [{
  json: {
    success: false,
    status: 'timeout',
    video_id: j.video_id,
    error: `HeyGen no completó tras ${j._state.maxAttempts} intentos`
  }
}];
```

---

## Comparativa: HeyGen vs Canva

| Aspecto | Canva | HeyGen |
|---|---|---|
| Wait entre polls | 2 segundos | 5 minutos |
| Max intentos (robusto) | 30 | 36 |
| Tiempo máximo | 60 segundos | 3 horas |
| Status completado | `"success"` | `"completed"` |
| Status fallido | `"failed"` | `"failed"` |
| Tiempo típico | 10-60 seg | 3-15 min |
| Endpoint crear | v1 | v2 |
| Endpoint poll | v1 | v1 |

---

## Trampas Comunes

### Version mismatch v2/v1

```
// MAL — no existe v2 para status
GET https://api.heygen.com/v2/video_status.get

// BIEN — polling usa v1
GET https://api.heygen.com/v1/video_status.get
```

### Wait demasiado corto

```
// MAL — genera demasiadas peticiones a la API
Wait 2 segundos  →  un video de 30s = ~150 requests innecesarios

// BIEN — respeta la API
Wait 5 minutos   →  un video de 30s = 2-3 requests
```

### Free tier y resolución

```json
// MAL — free tier rechaza 1080p
"dimension": { "width": 1080, "height": 1920 }

// BIEN — 720p máximo
"dimension": { "width": 720, "height": 1280 }
```

### API key vacía en template

Los JSON de ejercicio vienen con `"heygen_api_key": ""`. El alumno DEBE reemplazarla con su key real antes de ejecutar.

### No validar video_id

Si la API key es inválida o el body tiene errores, HeyGen puede responder con `200 OK` pero sin `video_id`. Siempre valida antes de iniciar polling.

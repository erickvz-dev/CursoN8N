# HeyGen API — Endpoints

Configuración exacta de los 2 endpoints de HeyGen usados en el diplomado.

**Nota crítica:** La creación de video usa `/v2` pero el polling de status usa `/v1`. Esto es por diseño de HeyGen, no un error.

---

## Endpoint 1: Crear Video (v2)

Genera un video con avatar que habla un texto dado.

### Configuración del nodo HTTP Request

```json
{
  "method": "POST",
  "url": "https://api.heygen.com/v2/video/generate",
  "sendHeaders": true,
  "headerParameters": {
    "parameters": [
      {
        "name": "X-Api-Key",
        "value": "={{ $json.heygen_api_key }}"
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
  "video_inputs": [
    {
      "character": {
        "type": "avatar",
        "avatar_id": "{{ $json.avatar_id }}",
        "avatar_style": "normal"
      },
      "voice": {
        "type": "text",
        "input_text": "{{ $json.script_video }}",
        "voice_id": "{{ $json.voice_id }}"
      },
      "background": {
        "type": "color",
        "value": "#FFFFFF"
      }
    }
  ],
  "dimension": {
    "width": {{ $json._state.width }},
    "height": {{ $json._state.height }}
  },
  "test": false,
  "caption": false
}
```

### Opciones de voz adicionales (opcionales)

```json
"voice": {
  "type": "text",
  "input_text": "...",
  "voice_id": "...",
  "speed": 1.1,
  "pitch": 50,
  "emotion": "Excited"
}
```

| Parámetro | Tipo | Rango | Default |
|---|---|---|---|
| `speed` | number | 0.5 - 2.0 | 1.0 |
| `pitch` | number | 0 - 100 | 50 |
| `emotion` | string | `"Excited"`, `"Serious"`, `"Friendly"`, `"Soothing"` | ninguno |

### Tabla de dimensiones (Free Tier = 720p máx.)

| Aspect Ratio | Width | Height |
|---|---|---|
| 9:16 (vertical) | 720 | 1280 |
| 1:1 (cuadrado) | 720 | 720 |
| 16:9 (horizontal) | 1280 | 720 |

### Response esperado

```json
{
  "data": {
    "video_id": "abc123-video-id"
  }
}
```

### Validación del response

```javascript
const videoId = $input.first().json.data?.video_id;
if (!videoId) {
  throw new Error('HeyGen no devolvió video_id (revisa credenciales/body).');
}
```

### Nombre del nodo

`HeyGen: Create Video (v2)`

---

## Endpoint 2: Poll Status (v1)

Consulta el estado de generación del video. Se ejecuta en loop hasta que el video esté listo.

### Configuración del nodo HTTP Request

```json
{
  "url": "=https://api.heygen.com/v1/video_status.get?video_id={{ $json.video_id }}",
  "sendHeaders": true,
  "headerParameters": {
    "parameters": [
      {
        "name": "X-Api-Key",
        "value": "={{ $json.heygen_api_key }}"
      }
    ]
  },
  "options": {}
}
```

### Alternativa: video_id como query parameter

```json
{
  "url": "https://api.heygen.com/v1/video_status.get",
  "sendQuery": true,
  "queryParameters": {
    "parameters": [
      {
        "name": "video_id",
        "value": "={{ $json.video_id }}"
      }
    ]
  }
}
```

### Response esperado

```json
{
  "data": {
    "status": "completed",
    "video_url": "https://files.heygen.ai/video/abc123.mp4",
    "thumbnail_url": "https://...",
    "duration": 12.5
  }
}
```

### Valores de status

| Status | Significado | Acción |
|---|---|---|
| `"completed"` | Video listo | Guardar `video_url`, continuar |
| `"processing"` | Aún generando | Esperar y volver a consultar |
| `"failed"` | Generación falló | Reportar error |

### Campos útiles del response

| Campo | Acceso | Uso |
|---|---|---|
| Video URL | `$json.data.video_url` | URL directa al MP4 |
| Status | `$json.data.status` | Control del loop de polling |
| Duration | `$json.data.duration` | Duración del video en segundos |

### Nombre del nodo

`HeyGen: Poll Status (v1)`

---

## Configuración Previa: Set Node con Variables

Antes de los endpoints, configura un nodo Set con las variables necesarias:

```json
{
  "heygen_api_key": "TU_API_KEY",
  "avatar_id": "ID_DEL_AVATAR",
  "voice_id": "ID_DE_LA_VOZ"
}
```

### Cómo obtener IDs

- **avatar_id**: HeyGen Dashboard → Avatars → seleccionar avatar → copiar ID
- **voice_id**: HeyGen Dashboard → Voices → seleccionar voz → copiar ID
- **API key**: HeyGen Dashboard → Settings → API Keys → crear o copiar

### Nombre del nodo

`Set: HeyGen Config (avatar/voice)`

# Canva API — Patrón de Polling Asíncrono

Canva procesa uploads de forma asíncrona. Después de subir una imagen, debes hacer polling hasta que esté lista.

---

## Versión Simple (Sprint 02)

### Diagrama

```
Upload Asset (POST)
    ↓
Wait 2s
    ↓
Poll Status (GET)
    ↓
IF status == "success"?
  ├─ TRUE  → Create Design (POST)
  └─ FALSE → Volver a Wait 2s
```

### Características

- **Wait:** 2 segundos entre polls
- **Sin límite de intentos** — puede generar loop infinito si el upload falla silenciosamente
- **Sin detección de fallo** — si status es `"failed"`, sigue haciendo poll indefinidamente
- **Uso:** demos y pruebas rápidas

### Configuración del IF

```
Value 1: {{ $json.job.status }}
Operation: Equals
Value 2: "success"
```

---

## Versión Robusta (Sprint 03)

### Diagrama

```
Upload Asset (POST)
    ↓
Code: Init State (extraer job_id, attempts=0, maxAttempts=30)
    ↓
Wait 2s
    ↓
Poll Status (GET)
    ↓
Code: Normalize Poll Result
    ↓
IF status == "success"?
  ├─ TRUE  → Create Design → Code: Output Success
  └─ FALSE ↓
      IF status == "failed"?
        ├─ TRUE  → Set: Output Failed
        └─ FALSE ↓
            Code: attempts++
                ↓
            IF attempts < maxAttempts?
              ├─ TRUE  → Volver a Wait 2s
              └─ FALSE → Set: Output Timeout
```

### Características

- **Wait:** 2 segundos entre polls
- **Max intentos:** 30 (configurable)
- **Tiempo máximo:** 30 × 2s = 60 segundos
- **3 estados terminales:** success, failed, timeout
- **Normalización de response** para manejar variaciones del API

### Code: Init State

```javascript
const input = $input.first().json;
const jobId = input?.job?.id;

if (!jobId) {
  throw new Error('Canva upload no devolvió job.id');
}

return [{
  json: {
    ...input,
    canva_job_id: jobId,
    _state: {
      attempts: 0,
      maxAttempts: 30
    }
  }
}];
```

### Code: Normalize Poll Result

```javascript
const prev = $input.first().json;
const job = prev.job ?? prev.data?.job ?? prev.data ?? prev;
const status = job?.status;
const assetId = job?.asset?.id;

return [{
  json: {
    ...prev,
    _poll: {
      status: status,
      asset_id: assetId,
      raw: job
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
const input = $input.first().json;

return [{
  json: {
    success: true,
    status: 'success',
    canva_job_id: input.canva_job_id,
    canva_asset_id: input._poll.asset_id,
    canva_design_id: $('Canva: Create Design').first().json.design?.id,
    canva_edit_url: $('Canva: Create Design').first().json.design?.urls?.edit_url
  }
}];
```

### Output: Failed

```json
{
  "success": false,
  "status": "failed",
  "canva_job_id": "{{ $json.canva_job_id }}",
  "error": "Canva asset upload failed"
}
```

### Output: Timeout

```json
{
  "success": false,
  "status": "timeout",
  "canva_job_id": "{{ $json.canva_job_id }}",
  "error": "Canva upload no completó tras 30 intentos"
}
```

---

## Comparativa

| Aspecto | Simple (S02) | Robusta (S03) |
|---|---|---|
| Max intentos | Sin límite | 30 |
| Manejo de fallo | No | Sí |
| Normalización response | No | Sí |
| Timeout | No | Sí |
| Tiempo máximo | Infinito | 60 segundos |
| Uso recomendado | Demos | Producción |

---

## Trampas Comunes

### El campo binary debe llamarse "data"

```json
// MAL — Canva no recibe la imagen
"inputDataFieldName": "file"

// BIEN — coincide con el output de Gemini
"inputDataFieldName": "data"
```

### Response shape varía

La API de Canva puede devolver respuestas con diferente estructura:

```javascript
// A veces:  { job: { status: "success", asset: {...} } }
// A veces:  { data: { job: { status: "success" } } }

// Siempre normalizar:
const job = response.job ?? response.data?.job ?? response;
```

### Asset-Upload-Metadata debe ser JSON string

```javascript
// MAL — n8n envía [object Object]
"Asset-Upload-Metadata": { name_base64: "abc" }

// BIEN — JSON string válido
"Asset-Upload-Metadata": "={{ JSON.stringify({ name_base64: 'abc' }) }}"
```

### Polling sin límite = loop infinito

Si el upload falla silenciosamente (status nunca cambia), un polling sin `maxAttempts` ejecutará indefinidamente. Siempre agrega un contador.

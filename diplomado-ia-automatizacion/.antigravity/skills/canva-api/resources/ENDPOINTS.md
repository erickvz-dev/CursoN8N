# Canva API — Endpoints

Configuración exacta de los 3 endpoints de Canva usados en el diplomado.

---

## Endpoint 1: Subir Asset (Upload)

Sube una imagen como dato binario a Canva. Retorna un `job.id` para hacer polling.

### Configuración del nodo HTTP Request

```json
{
  "method": "POST",
  "url": "https://api.canva.com/rest/v1/asset-uploads",
  "authentication": "genericCredentialType",
  "genericAuthType": "oAuth2Api",
  "sendHeaders": true,
  "headerParameters": {
    "parameters": [
      {
        "name": "Content-Type",
        "value": "application/octet-stream"
      },
      {
        "name": "Asset-Upload-Metadata",
        "value": "={{ JSON.stringify({ name_base64: $json._state.name_base64 }) }}"
      }
    ]
  },
  "sendBody": true,
  "contentType": "binaryData",
  "inputDataFieldName": "data",
  "options": {}
}
```

### Generar name_base64 dinámicamente

En un Code node previo:

```javascript
const filename = `${$input.first().json.id || 'imagen'}-${Date.now()}.png`;
const name_base64 = Buffer.from(filename).toString('base64');

return [{
  json: {
    ...($input.first().json),
    _state: { name_base64, attempts: 0, maxAttempts: 30 }
  }
}];
```

### Response esperado

```json
{
  "job": {
    "id": "job_abc123"
  }
}
```

### Nombre del nodo

`Canva: Upload Asset Job`

---

## Endpoint 2: Poll Status del Upload

Consulta el estado de un upload asíncrono hasta que esté listo.

### Configuración del nodo HTTP Request

```json
{
  "url": "=https://api.canva.com/rest/v1/asset-uploads/{{ $json.canva_job_id }}",
  "authentication": "genericCredentialType",
  "genericAuthType": "oAuth2Api",
  "options": {}
}
```

Si el `job_id` viene directo del upload:

```
=https://api.canva.com/rest/v1/asset-uploads/{{ $json.job.id }}
```

### Response esperado

```json
{
  "job": {
    "id": "job_abc123",
    "status": "success",
    "asset": {
      "id": "asset_xyz789",
      "name": "imagen-1709349600.png",
      "thumbnail": {
        "url": "https://..."
      }
    }
  }
}
```

### Valores de status

| Status | Significado | Acción |
|---|---|---|
| `"success"` | Upload completado | Continuar a Create Design |
| `"failed"` | Upload falló | Reportar error |
| `"in_progress"` | Procesando | Esperar y volver a consultar |

### Nombre del nodo

`Canva: Poll Upload Job`

---

## Endpoint 3: Crear Diseño

Crea un diseño nuevo en Canva usando un asset subido previamente.

### Configuración del nodo HTTP Request

```json
{
  "method": "POST",
  "url": "https://api.canva.com/rest/v1/designs",
  "authentication": "genericCredentialType",
  "genericAuthType": "oAuth2Api",
  "sendHeaders": true,
  "headerParameters": {
    "parameters": [
      {
        "name": "Content-Type",
        "value": "application/json"
      }
    ]
  },
  "sendBody": true,
  "specifyBody": "json",
  "jsonBody": "={\n  \"design_type\": {\n    \"type\": \"custom\",\n    \"width\": {{ $json.tipo === 'post' ? 1080 : 1080 }},\n    \"height\": {{ $json.tipo === 'post' ? 1080 : 1920 }}\n  },\n  \"title\": \"{{ $json.titulo }}\",\n  \"asset_id\": \"{{ $json.canva_asset_id }}\"\n}",
  "options": {}
}
```

### Tabla de dimensiones

| Tipo | Width | Height | Ratio |
|---|---|---|---|
| post | 1080 | 1080 | 1:1 |
| story | 1080 | 1920 | 9:16 |
| reel | 1080 | 1920 | 9:16 |

### Response esperado

```json
{
  "design": {
    "id": "design_abc123",
    "urls": {
      "edit_url": "https://www.canva.com/design/DAF.../edit"
    },
    "created_at": "2026-03-07T10:00:00Z"
  }
}
```

### Campos útiles del response

| Campo | Acceso | Uso |
|---|---|---|
| Design ID | `$json.design.id` | Referencia para exports futuros |
| Edit URL | `$json.design.urls.edit_url` | Enlace para editar/ver el diseño |

### Nombre del nodo

`Canva: Create Design`

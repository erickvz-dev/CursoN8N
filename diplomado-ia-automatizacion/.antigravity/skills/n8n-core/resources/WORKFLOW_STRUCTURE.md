# Estructura JSON de Workflows n8n

Referencia completa del schema JSON que usa n8n para definir workflows.

---

## Schema Top-Level

Todo workflow n8n es un objeto JSON con estos campos:

```json
{
  "name": "[S1] Asistente Telegram",
  "nodes": [ ],
  "connections": { },
  "active": false,
  "settings": {
    "executionOrder": "v1"
  },
  "tags": [
    { "name": "diplomado" },
    { "name": "sprint-01" }
  ],
  "pinData": { }
}
```

### Campos obligatorios

| Campo | Tipo | Descripción |
|---|---|---|
| `name` | string | Nombre del workflow. Formato: `"[S{n}] Nombre Descriptivo"` |
| `nodes` | array | Lista de todos los nodos del workflow |
| `connections` | object | Mapa de conexiones entre nodos |
| `active` | boolean | `true` activa triggers (webhooks, Telegram, cron) |
| `settings` | object | Configuración del workflow |

### Campos opcionales (los agrega n8n automáticamente)

| Campo | Tipo | Descripción |
|---|---|---|
| `id` | string | ID alfanumérico asignado por n8n |
| `versionId` | string | UUID de versión |
| `createdAt` | string | Fecha ISO de creación |
| `updatedAt` | string | Fecha ISO de última modificación |
| `pinData` | object | Datos de prueba fijados por nodo |
| `meta` | object | Metadatos de instancia |

---

## Schema de un Nodo

```json
{
  "parameters": {
    "updates": ["message"]
  },
  "type": "n8n-nodes-base.telegramTrigger",
  "typeVersion": 1.2,
  "position": [250, 300],
  "id": "a1b2c3d4-uuid",
  "name": "Telegram - Recibir Mensaje",
  "credentials": {
    "telegramApi": {
      "id": "xVHAjlbHy3mILPIX",
      "name": "Telegram account"
    }
  }
}
```

### Campos del nodo

| Campo | Tipo | Requerido | Descripción |
|---|---|---|---|
| `parameters` | object | Sí | Configuración específica del nodo |
| `type` | string | Sí | Formato: `n8n-nodes-base.nombre` o `@n8n/n8n-nodes-langchain.nombre` |
| `typeVersion` | number | Sí | Versión del nodo (ej: 1.2, 4.2) |
| `position` | [x, y] | Sí | Posición en el canvas |
| `id` | string | Sí | UUID v4 único |
| `name` | string | Sí | Nombre descriptivo en español |
| `credentials` | object | No | Credenciales asociadas |
| `webhookId` | string | No | UUID para nodos Webhook/Wait |
| `notes` | string | No | Texto de notas adicionales |
| `disabled` | boolean | No | `true` desactiva el nodo |

### Tipos de nodo comunes

| Paquete | Ejemplos |
|---|---|
| `n8n-nodes-base.*` | `telegram`, `telegramTrigger`, `httpRequest`, `if`, `set`, `code`, `webhook`, `respondToWebhook`, `postgres`, `googleSheets`, `splitInBatches`, `executeWorkflow`, `executeWorkflowTrigger`, `stickyNote` |
| `@n8n/n8n-nodes-langchain.*` | `agent`, `openAi`, `lmChatOpenAi`, `memoryBufferWindow`, `toolWorkflow`, `toolThink` |

---

## Tipos de Conexión

n8n tiene 4 tipos de conexión:

### 1. `main` — Flujo principal de datos

Conecta la salida de un nodo a la entrada de otro:

```json
"Telegram - Recibir Mensaje": {
  "main": [
    [
      { "node": "IF - ¿Tiene Foto?", "type": "main", "index": 0 }
    ]
  ]
}
```

### Branching con IF (dos salidas)

La primera array es TRUE (index 0), la segunda es FALSE (index 1):

```json
"IF - ¿Tiene Foto?": {
  "main": [
    [
      { "node": "Telegram - Descargar Imagen", "type": "main", "index": 0 }
    ],
    [
      { "node": "Telegram - Solo Acepto Fotos", "type": "main", "index": 0 }
    ]
  ]
}
```

### Fan-out (un nodo a múltiples destinos en paralelo)

```json
"Set - Normalizar": {
  "main": [
    [
      { "node": "Responder: Procesando...", "type": "main", "index": 0 },
      { "node": "Generar Plan", "type": "main", "index": 0 }
    ]
  ]
}
```

### Loop (splitInBatches)

```json
"Loop Over Items": {
  "main": [
    [ { "node": "Enviar Resultado", "type": "main", "index": 0 } ],
    [ { "node": "Procesar Item", "type": "main", "index": 0 } ]
  ]
},
"Procesar Item": {
  "main": [
    [ { "node": "Loop Over Items", "type": "main", "index": 0 } ]
  ]
}
```

### 2. `ai_languageModel` — LLM al AI Agent

```json
"OpenAI Chat Model": {
  "ai_languageModel": [
    [
      { "node": "AI Agent", "type": "ai_languageModel", "index": 0 }
    ]
  ]
}
```

### 3. `ai_tool` — Herramienta al AI Agent

```json
"crear_evento": {
  "ai_tool": [
    [
      { "node": "AI Agent", "type": "ai_tool", "index": 0 }
    ]
  ]
}
```

Múltiples tools se conectan al mismo Agent con `index: 0`.

### 4. `ai_memory` — Memoria al AI Agent

```json
"Simple Memory": {
  "ai_memory": [
    [
      { "node": "AI Agent", "type": "ai_memory", "index": 0 }
    ]
  ]
}
```

---

## Patrón Resource Locator (`__rl`)

n8n usa este patrón para referencias a recursos externos (modelos, workflows, documentos):

```json
{
  "__rl": true,
  "value": "gpt-4o-mini",
  "mode": "list",
  "cachedResultName": "gpt-4o-mini"
}
```

Se usa en:
- `model` en nodos OpenAI
- `workflowId` en toolWorkflow
- `calendar` en Google Calendar
- `documentId` y `sheetName` en Google Sheets

---

## Settings del Workflow

### Configuración estándar

```json
"settings": {
  "executionOrder": "v1"
}
```

### Para subflujos (llamados por otro workflow)

```json
"settings": {
  "executionOrder": "v1",
  "callerPolicy": "workflowsFromSameOwner"
}
```

### Para workflows disponibles como herramienta MCP

```json
"settings": {
  "executionOrder": "v1",
  "availableInMCP": true
}
```

---

## Pin Data (Datos de Prueba)

Permite ejecutar un workflow con datos fijados sin necesidad de un trigger real:

```json
"pinData": {
  "Webhook - Entrada": [
    {
      "json": {
        "headers": { "content-type": "application/json" },
        "body": {
          "semana_iso": "2026-W10",
          "cantidad_piezas": 7
        }
      }
    }
  ]
}
```

Útil para:
- Probar workflows con webhook sin enviar una petición real
- Reproducir escenarios específicos durante desarrollo
- Compartir datos de prueba con el equipo

---

## Sticky Notes

```json
{
  "parameters": {
    "content": "1. ENTRADA: Recibe cualquier mensaje del bot.",
    "height": 200,
    "width": 300
  },
  "type": "n8n-nodes-base.stickyNote",
  "typeVersion": 1,
  "position": [200, 180],
  "name": "Nota 1 - Entrada"
}
```

El campo `color` (1-7) es opcional y se usa para notas de resumen o advertencia.

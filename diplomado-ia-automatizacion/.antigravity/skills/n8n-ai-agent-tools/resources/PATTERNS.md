# n8n AI Agent Tools — Patrones de Configuración

Dos patrones de arquitectura para AI Agents en el diplomado. Elegir según la complejidad de cada tool.

---

## Comparativa

| Criterio | Patrón A: Sub-workflow | Patrón B: Direct Node |
|----------|----------------------|----------------------|
| Sprint | Sprint 01 | Sprint 07 |
| Complejidad de la tool | Multi-step (3+ nodos) | Single-step (1 nodo) |
| Debugging | Ejecución propia en el sub-workflow | Visible en el log del agente |
| Reutilización | Tool usable desde múltiples agentes | Acoplada al agente |
| Tipo de nodo | `toolWorkflow` | Cualquier nodo conectado como `ai_tool` |

---

## Patrón A — Sub-workflow Tools (Sprint 1)

### Lado del agente: nodo toolWorkflow

```json
{
  "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
  "typeVersion": 2.2,
  "name": "Tool - Crear Recordatorio",
  "parameters": {
    "name": "crear_recordatorio",
    "description": "Crea un recordatorio en Google Calendar. Usar cuando el usuario pide que le recuerdes algo o cuando menciona una fecha y hora para una actividad.",
    "workflowId": { "__rl": true, "mode": "id", "value": "WORKFLOW_ID_AQUI" },
    "workflowInputs": {
      "mappingMode": "defineBelow",
      "value": {
        "titulo": "=$fromAI('titulo', 'Título descriptivo del recordatorio')",
        "fecha": "=$fromAI('fecha', 'Fecha y hora en formato ISO 8601, ej: 2026-03-15T10:00:00')",
        "descripcion": "=$fromAI('descripcion', 'Descripción opcional del recordatorio')"
      }
    }
  }
}
```

### Lado del sub-workflow: recibir los inputs

El sub-workflow empieza con un nodo trigger de ejecución. Los inputs del `toolWorkflow` llegan en el primer ítem:

```javascript
// En el primer nodo del sub-workflow (después del trigger de ejecución):
const titulo = $json.titulo;       // viene del workflowInputs del toolWorkflow
const fecha = $json.fecha;
const descripcion = $json.descripcion;
```

### Conexión en el workflow padre

```json
"connections": {
  "Tool - Crear Recordatorio": {
    "ai_tool": [[{ "node": "AI Agent", "type": "ai_tool", "index": 0 }]]
  }
}
```

**Nota crítica**: La conexión va FROM el tool node TO el agent node con type `ai_tool`. En el editor visual de n8n, el tool aparece conectado al agente por el puerto inferior del agente.

---

## Patrón B — Direct Node Tools con $fromAI() (Sprint 7)

### Tool: HTTP Request para enviar mensaje WhatsApp

```json
{
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2,
  "name": "Tool C: responder_whatsapp",
  "parameters": {
    "method": "POST",
    "url": "=https://graph.facebook.com/v18.0/{{ $env.PHONE_NUMBER_ID }}/messages",
    "sendHeaders": true,
    "headerParameters": {
      "parameters": [
        { "name": "Authorization", "value": "=Bearer {{ $env.META_TOKEN }}" },
        { "name": "Content-Type", "value": "application/json" }
      ]
    },
    "sendBody": true,
    "specifyBody": "json",
    "jsonBody": "={\n  \"messaging_product\": \"whatsapp\",\n  \"to\": \"{{ $('01 - WhatsApp Webhook').item.json.telefono }}\",\n  \"type\": \"text\",\n  \"text\": { \"body\": \"{{ $fromAI('mensaje', 'Mensaje de respuesta al prospecto. Máximo 3 oraciones, tono cálido y profesional.') }}\" }\n}",
    "options": {}
  }
}
```

### Tool: Set node como base de conocimiento estática

```json
{
  "type": "n8n-nodes-base.set",
  "typeVersion": 3.4,
  "name": "Tool B: consultar_catalogo",
  "parameters": {
    "mode": "manual",
    "duplicateItem": false,
    "assignments": {
      "assignments": [
        {
          "name": "catalogo",
          "value": "PAQUETE BÁSICO: Café de especialidad mensual, 500g, $450 MXN. PAQUETE PREMIUM: 1kg café + accesorios, $890 MXN. SUSCRIPCIÓN ANUAL: 12 meses de café premium, $8,500 MXN (ahorra 20%).",
          "type": "string"
        }
      ]
    }
  }
}
```

### Conexiones en el workflow (fragmento)

```json
"connections": {
  "Tool C: responder_whatsapp": {
    "ai_tool": [[{ "node": "05 - Agente Vendedor", "type": "ai_tool", "index": 0 }]]
  },
  "Tool B: consultar_catalogo": {
    "ai_tool": [[{ "node": "05 - Agente Vendedor", "type": "ai_tool", "index": 0 }]]
  },
  "@n8n/n8n-nodes-langchain.lmChatOpenAi": {
    "ai_languageModel": [[{ "node": "05 - Agente Vendedor", "type": "ai_languageModel", "index": 0 }]]
  },
  "@n8n/n8n-nodes-langchain.memoryBufferWindow": {
    "ai_memory": [[{ "node": "05 - Agente Vendedor", "type": "ai_memory", "index": 0 }]]
  }
}
```

---

## Configuración base del AI Agent (ambos patrones)

```json
{
  "type": "@n8n/n8n-nodes-langchain.agent",
  "typeVersion": 1.7,
  "name": "05 - Agente Vendedor",
  "parameters": {
    "agent": "conversationalAgent",
    "promptType": "define",
    "text": "={{ $json.mensaje }}",
    "hasOutputParser": false,
    "options": {
      "systemMessage": "Eres Nube, asistente de ventas de Cafetería Nube. [INSTRUCCIONES COMPLETAS AQUÍ]",
      "maxIterations": 10,
      "returnIntermediateSteps": false
    }
  }
}
```

---

## Window Buffer Memory — Configuración estándar

```json
{
  "type": "@n8n/n8n-nodes-langchain.memoryBufferWindow",
  "typeVersion": 1.3,
  "parameters": {
    "sessionKey": "=wa_{{ $('01 - WhatsApp Webhook').item.json.telefono }}",
    "contextWindowLength": 10
  }
}
```

**Nota**: El `sessionKey` debe ser único por usuario. Usar el número de teléfono para WhatsApp o el `chatId` para Telegram. Ver SKILL.md § "Window Buffer Memory" para tabla completa de variantes por caso de uso.

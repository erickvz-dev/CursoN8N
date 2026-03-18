---
name: n8n-core
description: Fundamentos estructurales de workflows n8n — JSON schema, convenciones de nombrado, credenciales y configuraciones. Use when construyendo cualquier workflow n8n, definiendo estructura JSON, configurando settings, nombrando nodos, creando sticky notes, configurando credenciales, o preparando un workflow para publicar.
---

# n8n Core

Fundamentos estructurales para construir workflows n8n correctos en el diplomado.

---

## Quick Start

Estructura mínima de un workflow n8n válido:

```json
{
  "name": "[S1] Mi Workflow",
  "nodes": [],
  "connections": {},
  "active": false,
  "settings": {
    "executionOrder": "v1"
  },
  "tags": [
    { "name": "diplomado" },
    { "name": "sprint-01" }
  ]
}
```

Para publicar vía MCP, ver skill **n8n-ssdlc** (pipeline completo).

---

## Reglas Esenciales

1. **Un workflow a la vez.** Construye, publica vía MCP, confirma que funciona, y luego continúa con el siguiente.
2. **`executionOrder` siempre `"v1"`.** Nunca uses `"v0"` — genera comportamiento impredecible.
3. **Expresiones dentro de `{{ }}`** en campos de nodos. NUNCA uses `{{ }}` dentro de nodos Code.
4. **Nodos Code retornan siempre** `return [{ json: { ...datos } }]`.
5. **Datos de webhook** llegan en `$json.body`, NO en `$json` directamente.
6. **Conexiones AI** usan tipos específicos: `ai_languageModel`, `ai_tool`, `ai_memory`.
7. **Formato de nodeType:** `n8n-nodes-base.NombreNodo` o `@n8n/n8n-nodes-langchain.NombreNodo`.
8. **Llama `get_node_essentials`** antes de configurar cualquier nodo nuevo.

---

## Estructura JSON de un Workflow

### Top-level

| Campo | Tipo | Descripción |
|---|---|---|
| `name` | string | `"[S{n}] Nombre Descriptivo"` |
| `nodes` | array | Array de objetos Node |
| `connections` | object | Conexiones entre nodos (keyed por nombre) |
| `active` | boolean | `true` si tiene trigger activo |
| `settings` | object | `{ executionOrder: "v1" }` |
| `tags` | array | `[{ name: "diplomado" }, { name: "sprint-XX" }]` |
| `pinData` | object | Datos de prueba fijados (opcional) |

### Schema de un Nodo

```json
{
  "parameters": { },
  "type": "n8n-nodes-base.telegram",
  "typeVersion": 1.2,
  "position": [250, 300],
  "id": "uuid-v4",
  "name": "Telegram - Recibir Mensaje",
  "credentials": {
    "telegramApi": { "id": "ABC123", "name": "Telegram account" }
  }
}
```

### Tipos de Conexión

```
main              → Flujo principal de datos
ai_languageModel  → LLM al AI Agent
ai_tool           → Herramienta (toolWorkflow) al AI Agent
ai_memory          → Memoria al AI Agent
```

Ejemplo de conexión con branching (IF):

```json
"IF - ¿Tiene Foto?": {
  "main": [
    [ { "node": "Telegram - Descargar", "type": "main", "index": 0 } ],
    [ { "node": "Telegram - Solo Fotos", "type": "main", "index": 0 } ]
  ]
}
```

→ Detalle completo en [WORKFLOW_STRUCTURE.md](resources/WORKFLOW_STRUCTURE.md)

---

## Convenciones de Nombrado

### Nodos — Siempre descriptivos en español

| Tipo | Formato | Ejemplo |
|---|---|---|
| Servicio | `Servicio - Acción` | `Telegram - Recibir Mensaje` |
| IF | `IF - ¿Pregunta?` | `IF - ¿Tiene Foto?` |
| Code | `Code - Acción` | `Code - Parsear Respuesta IA` |
| Tool (AI) | `snake_case` | `crear_evento`, `update_sheet` |

**NUNCA** dejes nombres genéricos: ~~`Code`~~, ~~`HTTP Request`~~, ~~`IF`~~

### Sticky Notes — Una por nodo

Formato: `"N. FUNCIÓN: Explicación breve."`

```
1. ENTRADA: Recibe cualquier mensaje del bot.
2. FILTRO: Solo deja pasar mensajes con foto adjunta.
3. ANÁLISIS IA: Convierte la foto del ticket en datos estructurados.
```

### Tags y Webhooks

```
Flujo:    [S3] Orquestador de Marketing
Tags:     [{ "name": "diplomado" }, { "name": "sprint-03" }]
Webhook:  /diplomado/s5/aprobar-gasto
```

→ Detalle completo en [NAMING_CONVENTIONS.md](resources/NAMING_CONVENTIONS.md)

---

## Patrones de Credenciales

Tres métodos de autenticación en n8n:

| Método | Uso | Ejemplo |
|---|---|---|
| OAuth2 Genérico | Canva, Google | `genericCredentialType` + `oAuth2Api` |
| Header Auth | HeyGen, OpenAI (manual) | Header `X-Api-Key` o `Authorization: Bearer` |
| Credencial Nativa | Telegram, Sheets, Postgres | `telegramApi`, `googleSheetsOAuth2Api` |

**Regla de seguridad:** NUNCA hardcodees API keys en el JSON del flujo. Usa n8n Credentials.

→ Detalle completo en [CREDENTIAL_PATTERNS.md](resources/CREDENTIAL_PATTERNS.md)

---

## Expresiones Clave (Referencia Rápida)

| Expresión | Qué hace |
|---|---|
| `{{ $json.campo }}` | Accede al campo del nodo anterior |
| `{{ $('Nombre Nodo').item.json.campo }}` | Accede a un nodo específico por nombre |
| `{{ $binary.data }}` | Accede a datos binarios (archivos) |
| `{{ $now.toFormat('yyyy-MM-dd') }}` | Fecha actual formateada |
| `{{ $fromAI('campo', '', 'string') }}` | Valor generado por AI Agent |
| `$input.first().json` | Dentro de Code node (sin `{{ }}`) |

→ Detalle completo en el skill **n8n-expression-syntax**

---

## Errores Comunes

### `{{ }}` dentro de Code node

```javascript
// MAL
const nombre = {{ $json.nombre }};

// BIEN
const nombre = $input.first().json.nombre;
```

### Nombre genérico de nodo

```
// MAL
"name": "HTTP Request"

// BIEN
"name": "OpenAI - Leer Ticket"
```

### Sticky Note faltante

```
// MAL
Nodo sin documentación → el siguiente programador no sabe qué hace.

// BIEN
"3. ANÁLISIS IA: Envía la foto como base64 a OpenAI Vision."
```

### Credencial hardcodeada

```json
// MAL
"value": "Bearer sk-abc123..."

// BIEN  — usa credencial de n8n
"authentication": "genericCredentialType"
```

### executionOrder incorrecto

```json
// MAL
"settings": { "executionOrder": "v0" }

// BIEN
"settings": { "executionOrder": "v1" }
```

---

## Mejores Prácticas

**Hacer:**
- Validar que el flujo funciona antes de avanzar al siguiente paso
- Nombrar cada nodo con su función específica
- Agregar Sticky Note a cada nodo
- Usar `executionOrder: "v1"` siempre
- Guardar credenciales en n8n Credentials
- Usar `callerPolicy: "workflowsFromSameOwner"` para subflujos

**No hacer:**
- Hardcodear API keys en el JSON
- Dejar nombres genéricos ("Code", "IF", "HTTP Request")
- Saltar la validación post-publicación
- Usar `{{ }}` dentro de nodos Code
- Olvidar activar el workflow si tiene webhook/trigger

---

## Integración con Otros Skills

| Skill | Relación |
|---|---|
| **n8n-expression-syntax** | Sintaxis detallada de expresiones `{{ }}` |
| **n8n-code-javascript** | Patrones para nodos Code en JavaScript |
| **n8n-node-configuration** | Configuración específica por tipo de nodo |
| **n8n-ssdlc** | Protocolo de desarrollo seguro y pipeline MCP |
| **n8n-workflow-patterns** | Patrones arquitectónicos (webhook, AI agent, etc.) |
| **n8n-validation-expert** | Validación de errores pre-publicación |
| **n8n-mcp-tools-expert** | Uso de herramientas MCP para publicar |
| **canva-api** | Integración con Canva REST API |
| **heygen-api** | Generación de videos con HeyGen |

---

## Checklist Pre-Publicación

- [ ] ¿Todos los nodos tienen nombre descriptivo? (no genéricos)
- [ ] ¿Hay Sticky Note en cada nodo? (formato `"N. FUNCIÓN: ..."`)
- [ ] ¿Las expresiones `{{ $json.campo }}` apuntan al nodo correcto?
- [ ] ¿Hay manejo de error? (al menos un IF que atrape respuestas inesperadas)
- [ ] ¿El workflow está activo? (publicar vía MCP no siempre lo activa)
- [ ] ¿Las credenciales están en n8n Credentials? (no hardcodeadas)
- [ ] ¿Los tags incluyen `diplomado` y `sprint-XX`?

---

## Recursos Adicionales

- [WORKFLOW_STRUCTURE.md](resources/WORKFLOW_STRUCTURE.md) — Schema JSON completo
- [NAMING_CONVENTIONS.md](resources/NAMING_CONVENTIONS.md) — Convenciones de nombrado
- [CREDENTIAL_PATTERNS.md](resources/CREDENTIAL_PATTERNS.md) — Patrones de credenciales

# n8n AI Agent Tools

Patrones de configuración del nodo AI Agent de n8n con tools, memoria y $fromAI().

---

## Purpose

Guía de patrones para construir AI Agents en n8n: sub-workflow tools (Sprint 1) y tools como nodos directos con $fromAI() (Sprint 7). Incluye Window Buffer Memory con sessionKey por usuario y diseño de system prompts para agentes de ventas.

## Activates On

- ai agent
- agente ia
- $fromAI
- tool workflow
- herramienta agente
- memory buffer
- window buffer
- agente vendedor
- react agent
- conversational agent
- langchain agent

## Priority

**HIGH** — Sprint 01 (sub-workflow tools) y Sprint 07 (direct node tools).

## Dependencies

**Required credentials**: `openAiApi` (ID: `SNcq9lmxwYGcZb6e`) para el nodo `lmChatOpenAi`.

**Related skills**:
- meta-whatsapp-api — trigger del agente en Sprint 7
- kommo-crm — tools A y D del agente vendedor en Sprint 7
- diplomado-produccion-gotchas — $fromAI() en tools directas, sessionKey de memoria

## Coverage

### Configuración del nodo AI Agent
1. Parámetros base (agent, promptType, text, systemMessage)
2. Tipo `conversationalAgent` vs `ReAct`
3. Salida del agente en `$json.output` (vs `$json.text` en chainLlm)

### Patrón A: Sub-workflow tools (toolWorkflow node) — Sprint 1
1. Configurar el nodo `toolWorkflow` con nombre, descripción y workflowId
2. Mapear workflowInputs con `$fromAI()`
3. Recibir inputs en el sub-workflow

### Patrón B: Direct node tools con $fromAI() — Sprint 7
1. HTTP Request como tool (responder por WhatsApp)
2. Set node como base de conocimiento estática
3. Nodos Kommo como tools de CRM

### Window Buffer Memory con sessionKey por usuario
1. Configuración del nodo `memoryBufferWindow`
2. sessionKey por número de teléfono (WhatsApp) o chatId (Telegram)
3. Limitaciones: memoria en RAM, no persiste entre reinicios

### Estructura de conexiones
1. `ai_languageModel` — desde lmChatOpenAi hacia el agente
2. `ai_tool` — desde cada tool node hacia el agente
3. `ai_memory` — desde memoryBufferWindow hacia el agente

## Evaluations

1. **eval-001**: Configurar un AI Agent con GPT-4o + Window Buffer Memory con sessionKey basada en el número de teléfono del usuario (`=wa_{{ $json.telefono }}`).
2. **eval-002**: Agregar un nodo HTTP Request como tool directa usando `$fromAI()` para construir el cuerpo del request con el mensaje de respuesta al usuario.
3. **eval-003**: Conectar un sub-workflow como tool: configurar el nodo `toolWorkflow` con nombre, descripción, workflowId y workflowInputs mapeados con `$fromAI()`.

## Files

| Archivo | Contenido |
|---|---|
| SKILL.md | Guía principal — conceptos, gotchas, system prompts, comparativa de patrones |
| PATTERNS.md | JSON concreto de configuración de nodos para ambos patrones |
| FROMAI_REFERENCE.md | Referencia rápida de $fromAI() — sintaxis, reglas, debugging |
| README.md | Este archivo — metadata del skill |

## Last Updated

2026-03-14

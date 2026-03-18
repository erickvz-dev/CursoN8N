# n8n Core

Fundamentos estructurales para construir workflows n8n en el diplomado.

---

## Purpose

Enseña la estructura JSON de workflows n8n, convenciones de nombrado, patrones de credenciales y configuraciones base que aplican a TODOS los sprints del diplomado.

## Activates On

- estructura workflow
- JSON n8n
- nombre de nodo
- sticky note
- credencial
- settings
- tags
- webhook path
- pin data
- conexiones
- pre-publish
- checklist publicar
- construir flujo
- nuevo workflow

## Priority

**HIGH** — Fundamento para todos los demás skills y sprints.

## Dependencies

**Related skills**:
- n8n Expression Syntax — sintaxis detallada de expresiones
- n8n Node Configuration — configuración específica por nodo
- n8n Workflow Patterns — patrones arquitectónicos
- n8n Validation Expert — validación pre-publicación
- n8n MCP Tools Expert — publicación vía MCP

## Coverage

### Estructura JSON de Workflows
1. Schema top-level (name, nodes, connections, settings, tags)
2. Schema de nodos (parameters, type, typeVersion, id, name, position, credentials)
3. Schema de conexiones (main, ai_languageModel, ai_tool, ai_memory)
4. Patrón `__rl` (Resource Locator)
5. Settings (executionOrder, callerPolicy, availableInMCP)
6. Pin Data para testing

### Convenciones de Nombrado
1. Nombres de nodo descriptivos en español
2. Formato de Sticky Notes: `"N. FUNCIÓN: Explicación"`
3. Tags: `[S{número}] Nombre`
4. Webhooks: `/diplomado/s{número}/{acción}`
5. Formato snake_case para tools de AI Agent

### Patrones de Credenciales
1. OAuth2 Genérico (Canva, Google)
2. Header Auth estático (HeyGen, OpenAI manual)
3. Credenciales nativas (Telegram, Sheets, Postgres)
4. Referencia por id + name

## Evaluations

1. **eval-001**: Dado un objetivo de sprint, generar la estructura JSON correcta de un workflow con tags, settings y naming apropiados.
2. **eval-002**: Revisar un workflow existente y aplicar todas las convenciones de nombrado (nodos, sticky notes, tags).
3. **eval-003**: Configurar credenciales correctamente para un workflow que usa Telegram + OpenAI + Supabase.

## Files

| Archivo | Líneas | Contenido |
|---|---|---|
| SKILL.md | ~200 | Guía principal, Quick Start, reglas, checklist |
| WORKFLOW_STRUCTURE.md | ~180 | Schemas JSON completos, conexiones, settings |
| NAMING_CONVENTIONS.md | ~120 | Nombres, sticky notes, tags, webhooks |
| CREDENTIAL_PATTERNS.md | ~120 | Tipos de credenciales, seguridad |
| README.md | este archivo | Metadata del skill |

## Last Updated

2026-03-07

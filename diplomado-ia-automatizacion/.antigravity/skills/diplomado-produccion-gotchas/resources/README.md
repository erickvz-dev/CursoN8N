# Diplomado Producción Gotchas — Resources

Esta skill contiene patrones descubiertos en producción al construir los workflows del diplomado de IA y automatización.

## Origen de los patrones

Cada gotcha fue descubierto durante la construcción real de los sprints:

| Sprint | Gotchas descubiertos |
|--------|---------------------|
| Sprint 1 (Asistente Voz) | Telegram Trigger voice vs text, Whisper binary flow |
| Sprint 2 (Producción Visual) | OpenAI Vision base64, Resource Locator pattern |
| Sprint 4 (RRHH) | Google Calendar attendees as array, Airtable OAuth2, Gmail credential name |
| Sprint 5 (Gastos) | Inline keyboard via HTTP Request, callback pattern, Postgres quoting, systemMessage loss, Webhook responseNode, LLM HTML cleanup |
| Sprint 6 (Finanzas) | OpenAI TTS (format opus), sendVoice via HTTP Request, UNION query, binary multipart form-data |

## Cómo contribuir

Al construir un nuevo sprint, si encuentras un comportamiento inesperado de n8n:

1. Documéntalo en `SKILL.md` bajo la sección correcta
2. Incluye el código/JSON que falla y el que funciona
3. Indica en qué sprint se descubrió

## Relación con otras skills

Esta skill complementa (no reemplaza) las skills genéricas:

- `n8n-core` → Estructura JSON, convenciones, expresiones
- `n8n-node-configuration` → Configuración por operación
- `n8n-workflow-patterns` → Patrones arquitectónicos
- `n8n-code-javascript` → Patrones de Code nodes

Las skills genéricas explican "cómo hacer las cosas bien". Esta skill explica "qué sale mal y cómo lo arreglamos."

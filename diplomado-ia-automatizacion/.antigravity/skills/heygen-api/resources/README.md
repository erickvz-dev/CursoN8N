# HeyGen API

Generación de videos con avatar HeyGen desde n8n.

---

## Purpose

Guía completa para generar videos con avatar, configurar voz y dimensiones, y manejar el patrón asíncrono de polling con la API de HeyGen desde workflows n8n.

## Activates On

- heygen
- video avatar
- generar video
- video ai
- heygen api
- avatar video
- text to video
- video automatizado

## Priority

**HIGH** — Usado en Sprint 02 y Sprint 03.

## Dependencies

**Required credentials**: API key de HeyGen (plan free o superior).

**Related skills**:
- n8n-core — estructura de credenciales Header Auth
- n8n-workflow-patterns — patrón async polling
- n8n-code-javascript — cálculo de dimensiones y normalización en Code node
- canva-api — mismo patrón de polling (referencia cruzada)

## Coverage

### Endpoints
1. POST `/v2/video/generate` — crear video con avatar y voz
2. GET `/v1/video_status.get` — poll status (nota: v1, no v2)

### Configuración de Video
1. Avatar (type, avatar_id, avatar_style)
2. Voz (type, input_text, voice_id, speed, pitch, emotion)
3. Background (type, value)
4. Dimensiones por aspect ratio (720p max en free tier)

### Patrones Async
1. Polling simple (Sprint 02) — Wait 30s, sin límite
2. Polling robusto (Sprint 03) — Wait 5min, maxAttempts=36, 3 estados terminales

## Evaluations

1. **eval-001**: Configurar nodo HTTP Request para crear un video 9:16 con avatar y voz usando X-Api-Key.
2. **eval-002**: Implementar polling robusto con maxAttempts=36, Wait 5min, y 3 estados terminales.
3. **eval-003**: Calcular dimensiones correctas según aspect_ratio respetando límite de 720p.

## Files

| Archivo | Contenido |
|---|---|
| SKILL.md | Guía principal, Quick Start, errores comunes |
| ENDPOINTS.md | Los 2 endpoints con headers/body/response exactos |
| ASYNC_POLLING.md | Patrones de polling simple y robusto |
| README.md | Este archivo — metadata del skill |

## Last Updated

2026-03-07

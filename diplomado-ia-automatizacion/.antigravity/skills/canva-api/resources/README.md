# Canva API

Integración con Canva REST API para automatización de diseños desde n8n.

---

## Purpose

Guía completa para subir imágenes, crear diseños y manejar el patrón asíncrono de polling con la API de Canva desde workflows n8n.

## Activates On

- canva
- diseño
- upload asset
- crear design
- imagen canva
- canva api
- asset upload
- canva oauth
- diseño automatizado

## Priority

**HIGH** — Usado en Sprint 02 y Sprint 03.

## Dependencies

**Required credentials**: OAuth2 de Canva configurado en n8n.

**Related skills**:
- n8n-core — estructura de credenciales OAuth2
- n8n-workflow-patterns — patrón async polling
- n8n-code-javascript — normalización de responses en Code node

## Coverage

### Endpoints
1. POST `/rest/v1/asset-uploads` — subir imagen como binary
2. GET `/rest/v1/asset-uploads/{job_id}` — poll status del upload
3. POST `/rest/v1/designs` — crear diseño desde asset

### Patrones Async
1. Polling simple (Sprint 02) — sin límite de intentos
2. Polling robusto (Sprint 03) — con maxAttempts, normalización, 3 estados terminales

### Configuración
- Autenticación OAuth2 genérica
- Dimensiones por tipo de contenido (post, story)
- Asset-Upload-Metadata con name_base64

## Evaluations

1. **eval-001**: Configurar correctamente el nodo HTTP Request para subir una imagen a Canva con OAuth2 y Asset-Upload-Metadata.
2. **eval-002**: Implementar polling robusto con maxAttempts=30 y 3 estados terminales.
3. **eval-003**: Crear un diseño 1080×1920 a partir de un asset_id existente.

## Files

| Archivo | Contenido |
|---|---|
| SKILL.md | Guía principal, Quick Start, errores comunes |
| ENDPOINTS.md | Los 3 endpoints con headers/body/response exactos |
| ASYNC_POLLING.md | Patrones de polling simple y robusto |
| README.md | Este archivo — metadata del skill |

## Last Updated

2026-03-07

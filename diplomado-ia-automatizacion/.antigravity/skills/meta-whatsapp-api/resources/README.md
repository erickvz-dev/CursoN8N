# Meta WhatsApp Cloud API

Recepción y envío de mensajes de WhatsApp via Meta Cloud API desde n8n.

---

## Purpose

Guía para recibir y enviar mensajes de WhatsApp via Meta Cloud API desde n8n. Sin nodo nativo — todo via HTTP Request con Header Auth.

## Activates On

- whatsapp
- meta api
- facebook graph
- webhook whatsapp
- mensaje whatsapp
- enviar whatsapp
- meta whatsapp
- whatsapp business

## Priority

**HIGH** — Usado en Sprint 07.

## Dependencies

**Required credentials**: Bearer token de Meta (temporal 24h o larga duración).

**Related skills**:
- n8n-core — estructura de credenciales Header Auth
- n8n-workflow-patterns — webhook processing
- diplomado-produccion-gotchas — webhook verification handshake, ventana 24h

## Coverage

### Autenticación
1. Bearer token temporal (24h) — para pruebas en clase
2. Bearer token de larga duración (~60 días) — para staging
3. System User Token (permanente) — para producción

### Recibir mensajes
1. Webhook Trigger configurado para responder al handshake GET de Meta
2. Filtro de delivery receipts con nodo IF (crítico)
3. Extracción de `telefono`, `mensaje`, `nombre` y `tipo` del payload

### Enviar mensajes
1. Mensaje de texto simple
2. Mensaje con botones interactivos (máx 3 botones tipo reply)
3. Template aprobado (para usar fuera de la ventana de 24h)

### Verificación del webhook
1. Handshake hub.challenge — configuración del GET en Webhook Trigger

## Evaluations

1. **eval-001**: Configurar Webhook Trigger de n8n para recibir mensajes de WhatsApp y extraer `telefono`, `mensaje` y `nombre` del payload.
2. **eval-002**: Enviar un mensaje de texto y un mensaje con botones interactivos (máx 3 botones) al número del remitente.
3. **eval-003**: Manejar la ventana de 24h: enviar template cuando el usuario no ha escrito en más de 24h.

## Files

| Archivo | Contenido |
|---|---|
| SKILL.md | Guía principal, autenticación, payload del webhook, gotchas |
| ENDPOINTS.md | Endpoints de envío con headers/body/response exactos y expresiones de extracción |
| WEBHOOK_SETUP.md | Setup en Meta Developer Portal, token lifecycle, troubleshooting |
| README.md | Este archivo — metadata del skill |

## Last Updated

2026-03-14

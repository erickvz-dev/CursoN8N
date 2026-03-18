# Kommo CRM

Guía para crear y actualizar contactos, deals y notas en Kommo CRM desde n8n usando el nodo de comunidad `n8n-nodes-kommo`.

---

## Purpose

Guía para crear y actualizar contactos, deals y notas en Kommo CRM desde n8n usando el nodo de comunidad `n8n-nodes-kommo`.

## Activates On

- kommo
- crm
- deal
- contacto crm
- pipeline ventas
- lead crm
- kommo crm
- trato
- prospecto crm
- etapa pipeline

## Priority

**HIGH** — Usado en Sprint 07.

## Dependencies

**Required**: nodo de comunidad `n8n-nodes-kommo` v0.0.16+, n8n v1.20.0+, Long-Lived Token de Kommo.

**Related skills**:
- meta-whatsapp-api — fuente de leads que se registran en Kommo
- n8n-ai-agent-tools — `$fromAI()` para parámetros de tools en el AI Agent

## Coverage

### Instalación
1. Instalación del nodo de comunidad `n8n-nodes-kommo`

### Autenticación
2. Long-Lived Token + subdomain de la cuenta

### Modelo de datos
3. Contact — campos principales y custom_fields_values (teléfono, email)
4. Deal — campos principales y contactos vinculados
5. Note — tipos de nota y estructura de params.text
6. Task — campos y vencimiento

### Operaciones CRUD por entidad
7. Contacts: Create, Get, Get All, Update
8. Deals: Create, Get, Get All, Update
9. Notes: Create, Get All
10. Tasks: Create, Update

### Patrón de integración
11. WhatsApp → Kommo: crear contacto + deal en secuencia

## Evaluations

1. **eval-001**: Crear un contacto en Kommo con nombre y teléfono provenientes de un webhook de WhatsApp.
2. **eval-002**: Crear un deal vinculado al contacto creado, en el pipeline "Ventas Cafetería Nube", etapa "Nuevo".
3. **eval-003**: Obtener todas las notas de un deal por ID para pasárselas al AI Agent como historial.

## Files

| Archivo | Contenido |
|---|---|
| SKILL.md | Guía principal: instalación, autenticación, operaciones, gotchas |
| ENTITY_MODEL.md | Modelo de datos: campos por entidad, expresiones n8n, obtener IDs de pipeline |
| EXAMPLES.md | 5 ejemplos de configuración de nodo: crear contacto, deal, notas, actualizar etapa, patrón completo |
| README.md | Este archivo — metadata del skill |

## Last Updated

2026-03-14

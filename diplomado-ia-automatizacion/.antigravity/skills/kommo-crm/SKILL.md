# Skill — Kommo CRM (n8n Community Node)

## Cuándo se activa

Cuando el alumno construye flujos que crean o actualizan contactos, deals y notas en Kommo CRM (Sprint 7).

---

## Instalación del nodo de comunidad

El nodo `n8n-nodes-kommo` no viene incluido en n8n. Para instalarlo en self-hosted:

1. En n8n: **Settings → Community Nodes → Install**
2. Buscar: `n8n-nodes-kommo`
3. Instalar y reiniciar n8n cuando lo solicite
4. Después del reinicio, los nodos de Kommo aparecen en el editor

**Versión mínima de n8n requerida:** v1.20.0+
**Versión del paquete:** v0.0.16 (octubre 2024)

---

## Autenticación — Long-Lived Token

Es el método más simple y recomendado para el diplomado.

### Obtener el token en Kommo

1. Kommo → **Settings → Integrations**
2. Crear una nueva integración privada
3. Copiar el **Long-Lived Token** generado
4. Anotar el **subdomain** de tu cuenta (la parte antes de `.kommo.com` en tu URL)

### Configurar en n8n

1. Credentials → New → buscar **Kommo Long-Lived API**
2. Pegar el token y el subdomain

---

## Operaciones disponibles

### Contacts (Contactos)

| Operación | Cuándo usarla                  |
| --------- | ------------------------------ |
| Create    | Registrar un nuevo prospecto   |
| Get       | Buscar contacto por ID         |
| Get All   | Listar contactos (con filtros) |
| Update    | Actualizar datos del contacto  |

### Deals (Tratos/Leads)

| Operación | Cuándo usarla                              |
| --------- | ------------------------------------------ |
| Create    | Abrir un nuevo deal en el pipeline         |
| Get       | Obtener datos de un deal por ID            |
| Get All   | Listar deals (filtrar por etapa, pipeline) |
| Update    | Mover etapa, actualizar monto, responsable |

### Notes (Notas)

| Operación | Cuándo usarla                      |
| --------- | ---------------------------------- |
| Create    | Agregar nota a un deal o contacto  |
| Get All   | Leer historial de notas de un deal |

### Tasks (Tareas)

| Operación | Cuándo usarla                     |
| --------- | --------------------------------- |
| Create    | Crear recordatorio de seguimiento |
| Update    | Marcar tarea como completada      |

---

## Estructura del pipeline (Sprint 7)

Pipeline: **"Ventas Cafetería Nube"**

| Etapa             | ID (obtener del API) | Trigger en n8n                   |
| ----------------- | -------------------- | -------------------------------- |
| Nuevo             | —                    | Al crear el deal                 |
| Calificado        | —                    | Manualmente o por score ≥ 7      |
| Nurturing         | —                    | Dispara secuencia de emails      |
| Propuesta enviada | —                    | Después de Email 3               |
| Cerrado Ganado    | —                    | Señal de cierre detectada por IA |
| Cerrado Perdido   | —                    | Sin respuesta después de 7 días  |

**Para obtener los IDs de etapa:** hacer un GET al deal después de crearlo y ver el campo `status_id`. O usar la API de Kommo directamente para listar las etapas del pipeline.

---

## Webhooks de Kommo → n8n

El nodo `n8n-nodes-kommo` **no incluye trigger**. Para que Kommo dispare un flujo en n8n al mover un deal de etapa:

1. En Kommo: **Settings → Integrations → Webhooks**
2. Agregar webhook con la URL de producción del Webhook Trigger de n8n
3. Suscribir al evento: `leads: status` (cambio de etapa del deal)
4. En n8n: usar un **Webhook Trigger** node (no el nodo de Kommo)

### Estructura del payload de Kommo

```json
{
  "leads": {
    "status": [
      {
        "id": 12345,
        "status_id": 67890,
        "pipeline_id": 11111,
        "responsible_user_id": 22222,
        "old_status_id": 33333
      }
    ]
  }
}
```

---

## Patrón típico: capturar lead desde WhatsApp → Kommo

```
Webhook Trigger (recibe payload de Meta WhatsApp)
    ↓
Code node (extrae: nombre, teléfono, mensaje)
    ↓
Kommo — Create Contact
  name: {{ $json.nombre }}
  phone: {{ $json.telefono }}
    ↓
Kommo — Create Deal
  name: "Lead WhatsApp - {{ $json.nombre }}"
  pipeline_id: ID del pipeline "Ventas Cafetería Nube"
  status_id: ID de etapa "Nuevo"
  contact_id: {{ $('Kommo — Create Contact').item.json.id }}
```

---

## Gotchas de producción

- El nodo de comunidad puede tener diferencias menores con la API oficial de Kommo — si una operación falla, verificar el payload con un HTTP Request directo a `https://{subdomain}.kommo.com/api/v4/`
- El trial de 14 días de Kommo es suficiente para construir y demostrar el sprint; para clientes reales el plan Base ($15/user/mes) cubre todas las funciones usadas
- Los IDs de etapa del pipeline son numéricos y únicos por cuenta — no hardcodearlos en el workflow, usar una variable o un Set node con la configuración del pipeline

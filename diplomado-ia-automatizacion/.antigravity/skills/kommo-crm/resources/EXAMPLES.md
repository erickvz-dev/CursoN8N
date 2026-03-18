# Kommo CRM — Ejemplos de Nodo

Configuración exacta del nodo `n8n-nodes-kommo` para las operaciones más frecuentes del diplomado.

---

## Ejemplo 1: Crear Contacto

Usar cuando llega un nuevo lead (por ejemplo, desde WhatsApp) y se necesita registrarlo como contacto en Kommo.

### Configuración del nodo

```
Tipo:       n8n-nodes-kommo.kommo
Resource:   Contact
Operation:  Create
Credential: Kommo Long-Lived API
```

| Parámetro | Valor |
|---|---|
| `name` | `={{ $json.nombre }}` |
| `custom_fields_values[0].field_code` | `PHONE` |
| `custom_fields_values[0].values[0].value` | `={{ $json.telefono }}` |
| `custom_fields_values[0].values[0].enum_code` | `MOB` |

### Output esperado

```json
{
  "id": 12345,
  "name": "Juan Pérez",
  "created_at": 1710000000,
  "updated_at": 1710000000,
  "custom_fields_values": [
    {
      "field_code": "PHONE",
      "values": [{ "value": "521234567890", "enum_code": "MOB" }]
    }
  ]
}
```

### Nombre del nodo

`Kommo - Create Contact`

---

## Ejemplo 2: Crear Deal vinculado al Contacto

Usar inmediatamente después de crear el contacto para abrir el deal en el pipeline de ventas.

### Configuración del nodo

```
Tipo:       n8n-nodes-kommo.kommo
Resource:   Deal
Operation:  Create
Credential: Kommo Long-Lived API
```

| Parámetro | Valor |
|---|---|
| `name` | `=Lead WhatsApp - {{ $('02 - Code: Parsear Mensaje').item.json.nombre }}` |
| `pipeline_id` | `=[ID del pipeline "Ventas Cafetería Nube"]` |
| `status_id` | `=[ID de etapa "Nuevo"]` |
| `_embedded.contacts` | `=[{ "id": {{ $json.id }} }]` |

**Nota**: `pipeline_id` y `status_id` son numéricos y específicos de cada cuenta de Kommo. Obtenerlos con un GET a `/api/v4/leads/pipelines` (ver ENTITY_MODEL.md) y guardarlos en un Set node al inicio del workflow. El campo `$json.id` en el último parámetro apunta al output del nodo Create Contact ejecutado justo antes.

### Output esperado

```json
{
  "id": 67890,
  "name": "Lead WhatsApp - Juan Pérez",
  "price": 0,
  "status_id": 11111,
  "pipeline_id": 22222,
  "created_at": 1710000000,
  "_embedded": {
    "contacts": [{ "id": 12345, "name": "Juan Pérez" }]
  }
}
```

### Nombre del nodo

`Kommo - Create Deal`

---

## Ejemplo 3: Obtener Notas de un Deal

Usar cuando el AI Agent necesita el historial de conversación de un deal antes de responder.

### Configuración del nodo

```
Tipo:        n8n-nodes-kommo.kommo
Resource:    Note
Operation:   Get All
Credential:  Kommo Long-Lived API
```

| Parámetro | Valor |
|---|---|
| `entity_type` | `leads` |
| `entity_id` | `={{ $json.deal_id }}` |

### Output esperado

Array de notas. Filtrar por `note_type === 'common'` para obtener solo notas de texto (excluir registros de llamadas y eventos del sistema).

```json
[
  {
    "id": 1001,
    "note_type": "common",
    "entity_id": 67890,
    "entity_type": "leads",
    "params": { "text": "El cliente preguntó por el menú del día." },
    "created_at": 1710000000
  }
]
```

Para concatenar las notas como historial, usar el Code node documentado en ENTITY_MODEL.md § Note.

### Nombre del nodo

`Kommo - Get Notes`

---

## Ejemplo 4: Actualizar Etapa del Deal

Usar cuando el AI Agent detecta una señal de cierre o avance en la conversación y debe mover el deal a la siguiente etapa.

### Configuración básica del nodo

```
Tipo:       n8n-nodes-kommo.kommo
Resource:   Deal
Operation:  Update
Credential: Kommo Long-Lived API
```

| Parámetro | Valor |
|---|---|
| `deal_id` | `={{ $json.deal_id }}` |
| `status_id` | `=[ID de etapa destino]` |

### Versión como tool del AI Agent con `$fromAI()`

Cuando el nodo Kommo Update se usa como tool del AI Agent, el `deal_id` lo provee el agente y el `status_id` queda fijo para evitar que el agente mueva el deal a etapas incorrectas:

| Parámetro | Valor |
|---|---|
| `deal_id` | `=$fromAI('deal_id', 'ID numérico del deal a actualizar en Kommo')` |
| `status_id` | `=[ID de etapa "Cerrado Ganado"]` |

**Nota**: el `status_id` siempre va hardcodeado en la tool — el agente decide cuándo llamarla, no a qué etapa mover.

### Nombre del nodo

`Kommo - Update Deal Stage`

---

## Ejemplo 5: Patrón completo WhatsApp → Kommo (4 nodos)

Secuencia estándar para capturar un lead de WhatsApp y registrarlo en Kommo con contacto y deal vinculados.

### Secuencia de nodos

```
01 - Webhook Trigger
     Recibe el payload de Meta WhatsApp Business API
         ↓
02 - Code: Parsear Mensaje
     Extrae nombre, teléfono y mensaje del payload
     Output: { nombre, telefono, mensaje }
         ↓
03 - Kommo: Create Contact
     name:  ={{ $json.nombre }}
     phone: ={{ $json.telefono }}
     Output: { id, name, ... }
         ↓
04 - Kommo: Create Deal
     name:               =Lead WhatsApp - {{ $('02 - Code: Parsear Mensaje').item.json.nombre }}
     pipeline_id:        =[ID del pipeline "Ventas Cafetería Nube"]
     status_id:          =[ID de etapa "Nuevo"]
     _embedded.contacts: =[{ "id": {{ $json.id }} }]
```

### Configuración del Code node (nodo 02)

```javascript
// Adaptar según estructura real del payload de Meta WhatsApp
const entry = $input.first().json.entry[0];
const change = entry.changes[0].value;
const mensaje = change.messages[0];
const perfil = change.contacts[0].profile;

return [{
  json: {
    nombre:   perfil.name,
    telefono: mensaje.from,
    mensaje:  mensaje.text?.body ?? ''
  }
}];
```

### Acceso cross-node en el nodo 04

- `$json.id` apunta al output del nodo 03 (Create Contact) — el ID del contacto recién creado.
- Para acceder a datos del nodo 02 usar `$('02 - Code: Parsear Mensaje').item.json.campo`.

### Nombres de nodos recomendados

| # | Nombre |
|---|---|
| 01 | `01 - Webhook Trigger` |
| 02 | `02 - Code: Parsear Mensaje` |
| 03 | `03 - Kommo: Create Contact` |
| 04 | `04 - Kommo: Create Deal` |

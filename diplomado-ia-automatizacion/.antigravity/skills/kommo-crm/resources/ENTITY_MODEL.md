# Kommo CRM — Modelo de Datos

Referencia de campos por entidad y cómo acceder a ellos en n8n con el nodo `n8n-nodes-kommo`.

---

## Contact (Contacto)

### Campos principales

```
id              — número único del contacto
name            — nombre completo
first_name      — primer nombre (si está separado)
created_at      — timestamp Unix de creación
updated_at      — timestamp Unix de última actualización
_embedded.tags  — array de tags
```

### Campos de teléfono y email — estructura especial

Los datos de contacto (teléfono, email) no son campos directos: viven en `custom_fields_values` como un array de objetos.

```json
{
  "custom_fields_values": [
    {
      "field_code": "PHONE",
      "values": [{ "value": "521234567890", "enum_code": "MOB" }]
    },
    {
      "field_code": "EMAIL",
      "values": [{ "value": "juan@email.com", "enum_code": "WORK" }]
    }
  ]
}
```

### Expresiones n8n para acceder a teléfono y email

```javascript
// Teléfono — del output del nodo Kommo Get Contact
{{ $json.custom_fields_values.find(f => f.field_code === 'PHONE')?.values[0]?.value }}

// Email
{{ $json.custom_fields_values.find(f => f.field_code === 'EMAIL')?.values[0]?.value }}
```

---

## Deal (Trato/Lead)

### Campos principales

```
id                      — número único del deal
name                    — nombre del deal
price                   — monto/valor del deal
status_id               — ID de la etapa actual en el pipeline
pipeline_id             — ID del pipeline al que pertenece
responsible_user_id     — ID del usuario responsable
created_at              — timestamp Unix de creación
_embedded.contacts      — array de contactos vinculados [{id, name}]
```

### Expresión para obtener el ID del primer contacto vinculado

```javascript
{{ $json._embedded.contacts[0].id }}
```

---

## Note (Nota)

### Campos

```
id           — número único de la nota
note_type    — "common" para notas de texto libre, "call_in"/"call_out" para llamadas
entity_id    — ID del deal o contacto al que pertenece la nota
entity_type  — "leads" o "contacts"
params.text  — texto de la nota (solo cuando note_type es "common")
created_by   — ID del usuario que creó la nota
created_at   — timestamp Unix de creación
```

### Expresión para concatenar todas las notas como historial

Usar en un Code node para preparar el historial antes de pasarlo al AI Agent:

```javascript
// Code node: preparar historial para el AI Agent
const notes = $input.all().map(item => item.json);
const historial = notes
  .filter(n => n.note_type === 'common' && n.params?.text)
  .map(n => `[${new Date(n.created_at * 1000).toLocaleDateString('es-MX')}] ${n.params.text}`)
  .join('\n');
return [{ json: { historial } }];
```

---

## Task (Tarea)

### Campos

```
id                   — número único de la tarea
text                 — descripción de la tarea
complete_till        — timestamp Unix del vencimiento
is_completed         — boolean: true si la tarea está completada
responsible_user_id  — ID del usuario responsable
entity_id            — ID del deal o contacto asociado
entity_type          — "leads" o "contacts"
```

---

## Obtener IDs de etapas del pipeline

Los IDs de `status_id` son numéricos y únicos por cuenta de Kommo — no se pueden hardcodear entre cuentas. Para obtenerlos una sola vez:

### Request a la API de Kommo

```
Método:  GET
URL:     https://{subdomain}.kommo.com/api/v4/leads/pipelines
Headers: Authorization: Bearer {token}
```

### Response

Devuelve un array de pipelines. Cada pipeline contiene `_embedded.statuses[]` con las etapas.

```json
{
  "_embedded": {
    "pipelines": [
      {
        "id": 11111,
        "name": "Ventas Cafetería Nube",
        "_embedded": {
          "statuses": [
            { "id": 67890, "name": "Nuevo",          "pipeline_id": 11111 },
            { "id": 67891, "name": "Calificado",     "pipeline_id": 11111 },
            { "id": 67892, "name": "Cerrado Ganado", "pipeline_id": 11111 }
          ]
        }
      }
    ]
  }
}
```

### Code node para construir mapa de etapas

```javascript
const pipelines = $input.first().json._embedded.pipelines;
const etapas = {};
pipelines.forEach(p => {
  p._embedded.statuses.forEach(s => {
    etapas[s.name] = s.id;
  });
});
return [{ json: { etapas } }];
```

**Recomendación**: guardar los IDs resultantes en un Set node al inicio del workflow o en variables de entorno de n8n. No hardcodearlos directamente en los parámetros del nodo Kommo.

---

## Vincular Contact a Deal al crear

Al crear un Deal, incluir en los parámetros del nodo el campo `_embedded` con el array de contactos:

| Campo | Valor |
|---|---|
| `_embedded.contacts` | `[{ "id": {{ $('Kommo - Create Contact').item.json.id }} }]` |

El ID viene del output del nodo Create Contact ejecutado justo antes en el workflow.

# Convenciones de Nombrado

Reglas para nombrar nodos, sticky notes, tags y webhooks en los workflows del diplomado.

---

## Nombres de Nodos

### Regla principal

Todo nodo debe tener un nombre que describa **qué hace** en español. Nunca dejes nombres genéricos.

### Patrones por tipo de nodo

| Tipo de nodo | Formato | Ejemplos |
|---|---|---|
| Servicios externos | `Servicio - Acción` | `Telegram - Recibir Mensaje`, `Supabase - Registrar Gasto`, `OpenAI - Leer Ticket` |
| IF / Condicionales | `IF - ¿Pregunta?` | `IF - ¿Tiene Foto?`, `IF - ¿JSON Válido?`, `IF - ¿Fila Pendiente?` |
| Code | `Code - Acción` | `Code - Parsear Respuesta IA`, `Code - Extraer Acción e ID` |
| Set | `Set - Qué normaliza` | `Set - Normalizar Brief`, `Set - Config Publicación` |
| Tools de AI Agent | `snake_case` | `crear_evento`, `update_sheet`, `generate_image` |
| Webhook | `Webhook - Contexto` | `Webhook - Entrada`, `Recibir Brief Semanal` |
| Respond to Webhook | `Responder - Contexto` | `Responder al Navegador`, `Responder: Procesando...` |
| AI Agent | `AI AGENT: Rol` | `AI AGENT: Asistente`, `AI AGENT: Producer` |
| LLM Model | `LLM: Modelo` | `LLM: GPT-4o-mini` |

### Nombres prohibidos

Nunca uses estos nombres genéricos:

```
MAL:  "Code"
MAL:  "IF"
MAL:  "HTTP Request"
MAL:  "Set"
MAL:  "Telegram"

BIEN: "Code - Parsear Respuesta IA"
BIEN: "IF - ¿Tiene Foto?"
BIEN: "OpenAI - Leer Ticket"
BIEN: "Set - Config HeyGen"
BIEN: "Telegram - Recibir Mensaje"
```

---

## Sticky Notes

### Formato obligatorio

Cada nodo del workflow debe tener una Sticky Note adyacente con este formato:

```
N. FUNCIÓN: Explicación breve.
```

Donde:
- `N` = número secuencial del nodo en el flujo
- `FUNCIÓN` = verbo en mayúsculas que describe la acción
- `Explicación breve` = qué hace y por qué

### Ejemplos reales

```
1. ENTRADA: Recibe cualquier mensaje del bot. El siguiente nodo filtra solo fotos.
2. FILTRO: Solo deja pasar mensajes con foto adjunta. Los demás reciben instrucciones.
3. DESCARGA: Obtiene la foto del ticket como archivo binario. La opción Download DEBE estar activa.
4. VISIÓN IA: Envía la foto como base64 al API de OpenAI. Responde con JSON puro.
5. PARSEO: Limpia y convierte la respuesta de la IA a campos individuales.
6. VALIDACIÓN: Verifica que la IA devolvió JSON parseable. Si falla, pide una mejor foto.
7. BASE DE DATOS: Inserta el gasto con Estado='Pendiente'. Retorna el id para los botones.
8. NOTIFICACIÓN: Envía resumen al gerente con botones de decisión.
```

### Configuración del nodo Sticky Note

```json
{
  "parameters": {
    "content": "1. ENTRADA: Recibe cualquier mensaje del bot.",
    "height": 200,
    "width": 300
  },
  "type": "n8n-nodes-base.stickyNote",
  "typeVersion": 1,
  "position": [x, y],
  "name": "Nota 1 - Entrada"
}
```

- `height` y `width` ajustan el tamaño al contenido
- `color` (1-7) es opcional — usar `7` para notas de resumen general del workflow
- Posicionar la nota **encima o al lado** del nodo que documenta

---

## Tags del Workflow

### Formato del nombre

```
[S{número}] Nombre Descriptivo del Flujo
```

Ejemplos:
```
[S1] Asistente Telegram con Agent
[S3] Orquestador de Marketing
[S5] Captura de Gastos
[S5] Aprobación de Gastos
```

### Tags n8n

Cada workflow debe incluir al menos estos tags:

```json
"tags": [
  { "name": "diplomado" },
  { "name": "sprint-01" }
]
```

Opcionalmente agregar la herramienta principal:

```json
"tags": [
  { "name": "diplomado" },
  { "name": "sprint-05" },
  { "name": "telegram" },
  { "name": "supabase" }
]
```

---

## Paths de Webhooks

### Formato

```
/diplomado/s{número}/{acción}
```

### Ejemplos

| Sprint | Path | Propósito |
|---|---|---|
| S3 | `/diplomado/s3/brief` | Recibir brief semanal |
| S5 | `/diplomado/s5/aprobar-gasto` | Aprobación de gastos |
| S5 | `/diplomado/s5/reporte-gastos` | Reporte financiero on-demand |

### Reglas

- Los paths son **estáticos** — no uses expresiones `{{ }}` en el path
- Usa kebab-case para las acciones: `aprobar-gasto`, no `aprobarGasto`
- El número de sprint identifica de inmediato a qué flujo pertenece

---

## Nombres de Subflujos

### Formato

```
Subflujo: Nombre Descriptivo
```

o en inglés si el contexto lo requiere:

```
Subflow: Image Pipeline
```

### Input/Output en toolWorkflow

Cuando un subflujo se usa como herramienta de AI Agent, la `description` del tool debe incluir:

```
Qué hace esta herramienta.
Input: campo1 (tipo), campo2 (tipo)
Output: resultado esperado
Ejemplo: "genera una imagen para el post NUBE-001"
```

Esto ayuda al AI Agent a decidir cuándo y cómo usar la herramienta.

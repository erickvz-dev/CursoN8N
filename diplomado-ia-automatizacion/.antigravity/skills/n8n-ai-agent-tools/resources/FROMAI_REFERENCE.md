# $fromAI() — Referencia Rápida

Función que le permite al AI Agent pasar valores a un nodo tool en tiempo de ejecución. Esta es la referencia canónica; el SKILL.md cubre los conceptos generales.

---

## Sintaxis

```javascript
$fromAI('nombre_parametro', 'descripción de qué debe poner aquí el agente')
$fromAI('nombre_parametro', 'descripción', 'tipo')  // tipo opcional: 'string' | 'number' | 'boolean'
```

**Ambos argumentos son OBLIGATORIOS**. Sin descripción, el agente no sabe qué valor poner y elegirá algo arbitrario.

---

## Dónde funciona

Solo en campos con modo expresión (`=`) en nodos conectados como `ai_tool`. No funciona en nodos normales del workflow.

Nodos soportados como tools directas: HTTP Request, Set, Code, Kommo, y cualquier otro nodo de n8n conectado al puerto `ai_tool` del agente.

---

## Reglas de naming

| Regla | Ejemplo correcto | Ejemplo incorrecto |
|-------|-----------------|-------------------|
| snake_case | `deal_id` | `dealId`, `Deal ID` |
| Descriptivo | `mensaje_respuesta` | `msg`, `m` |
| Único en la tool | `telefono_destino` | (repetir mismo nombre en 2 campos) |

---

## Calidad de descripciones — buenos vs malos

| Parámetro | Mala descripción | Buena descripción |
|-----------|------------------|-------------------|
| `deal_id` | "ID del deal" | "ID numérico del deal en Kommo. Obtenlo del nodo de búsqueda previo." |
| `mensaje` | "El mensaje" | "Respuesta al prospecto. Máximo 3 oraciones, español, tono cálido." |
| `fecha` | "Fecha" | "Fecha y hora en formato ISO 8601, ej: 2026-03-15T10:00:00. Zona horaria México." |
| `etapa` | "La etapa" | "Nombre exacto de la etapa: 'Calificado', 'Nurturing' o 'Propuesta enviada'." |

---

## Coerción de tipos

```javascript
// Cuando el valor debe ser número:
$fromAI('monto', 'Monto del deal en pesos MXN', 'number')

// Cuando debe ser booleano:
$fromAI('urgente', '¿Es urgente? true o false', 'boolean')

// Default es string — no necesita tercer argumento:
$fromAI('mensaje', 'Texto de respuesta al usuario')
```

---

## El comentario auto-generado

En workflows exportados, `$fromAI` puede aparecer con este comentario:

```javascript
/*n8n-auto-generated-fromAI-override*/
$fromAI('param', 'descripción')
```

Es seguro dejarlo — n8n lo agrega automáticamente cuando detecta el patrón. No eliminar.

---

## Debugging

1. Ejecutar el workflow con un mensaje real.
2. Abrir el nodo del AI Agent → pestaña **Steps**.
3. Expandir cada "Tool call" → ver qué valores pasó el agente a cada parámetro.
4. Si el valor es incorrecto o vacío: mejorar la descripción del `$fromAI()`.

---

## Errores comunes

| Error | Causa | Solución |
|-------|-------|----------|
| Campo vacío (string vacío) | El agente no tenía el dato en contexto | Verificar que el system prompt o una tool previa provea ese dato |
| Valor incorrecto | Descripción ambigua | Reescribir descripción con ejemplos concretos |
| `undefined` | Nombre del parámetro no coincide con lo que el agente pasó | Verificar en Steps el nombre exacto que usó el agente |
| Error de tipo | Agente pasó string donde se espera number | Agregar tercer argumento `'number'` y validar en el prompt |

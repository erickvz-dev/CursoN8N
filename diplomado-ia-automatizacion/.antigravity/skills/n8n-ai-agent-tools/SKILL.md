---
name: n8n-ai-agent-tools
description: Configuración del nodo AI Agent en n8n con tools, memoria y $fromAI(). Usar cuando se construye un agente conversacional con herramientas (Sprint 1 con sub-workflows, Sprint 7 con tools directas), al configurar Window Buffer Memory con sesiones por usuario, al usar $fromAI() para pasar parámetros del agente a tools, o al diseñar system prompts para agentes de ventas/asistencia.
---

# Skill — AI Agent con Tools en n8n

## Cuándo se activa

Cuando el alumno construye un AI Agent que puede llamar herramientas externas, mantener memoria de conversación, o cuando necesita entender la diferencia entre `chainLlm` (lineal) y `agent` (con herramientas y razonamiento).

---

## Diferencia: chainLlm vs AI Agent

| Característica | chainLlm | AI Agent |
|----------------|----------|----------|
| Tipo de nodo | `chainLlm` v1.4 | `agent` v1.7 |
| Razonamiento | Lineal — recibe input, devuelve output | ReAct — decide qué herramienta usar y cuándo |
| Tools | No tiene | Puede llamar 1 a N herramientas |
| Memoria | No tiene nativa | Puede conectar memoryBufferWindow |
| Cuándo usarlo | Extracción de datos, clasificación, generación de contenido | Asistentes, vendedores, orquestadores multi-paso |

**Regla práctica:** Si el flujo solo necesita que la IA *piense*, usa `chainLlm`. Si necesita que la IA *actúe* (llamar APIs, buscar datos, actualizar CRM), usa `agent`.

---

## Tipos de conexión de sub-nodos

El AI Agent acepta tres tipos de sub-nodos. Cada uno se conecta con un tipo de conexión diferente.

| Sub-nodo | Tipo de conexión | Qué aporta |
|----------|-----------------|------------|
| `lmChatOpenAi` | `ai_languageModel` | El cerebro del agente (modelo de lenguaje) |
| Cualquier nodo tool | `ai_tool` | Una herramienta que el agente puede invocar |
| `memoryBufferWindow` | `ai_memory` | Memoria de conversación entre turnos |

**En el JSON, la conexión va DESDE el sub-nodo HACIA el agente:**

```json
"GPT-4o Agente": {
  "ai_languageModel": [
    [{ "node": "05 - Agente Vendedor", "type": "ai_languageModel", "index": 0 }]
  ]
},
"Tool A - Historial": {
  "ai_tool": [
    [{ "node": "05 - Agente Vendedor", "type": "ai_tool", "index": 0 }]
  ]
},
"Window Buffer Memory": {
  "ai_memory": [
    [{ "node": "05 - Agente Vendedor", "type": "ai_memory", "index": 0 }]
  ]
}
```

---

## El patrón ReAct (Reason + Act)

El AI Agent sigue este ciclo en cada mensaje que recibe:

```
1. REASON  → Lee el mensaje + historial de memoria + system prompt
               "El usuario pregunta por precio. Necesito el catálogo para calcular."
2. ACT     → Decide llamar una tool
               → Llama: consultar_catalogo_cafeteria()
3. OBSERVE → Recibe el resultado de la tool
               → Catálogo con precios por persona
4. REASON  → Procesa el resultado + decide si necesita otra tool o ya puede responder
               "Tengo el precio. 50 personas × $180 = $9,000. Puedo responder."
5. RESPOND → Genera la respuesta final al usuario
```

El agente puede repetir pasos 2-4 múltiples veces antes de responder. Si una tool falla, puede intentar otra o informar al usuario.

---

## $fromAI() — Pasar parámetros del agente a tools

`$fromAI()` es la función que le permite al agente pasar valores a un nodo tool en tiempo de ejecución.

### Sintaxis

```javascript
$fromAI('nombre_parametro', 'Descripción de qué es este parámetro')
```

### Ejemplo en HTTP Request (Tool C - Responder WhatsApp)

```json
{
  "messaging_product": "whatsapp",
  "to": "={{ $fromAI('telefono', 'Número de teléfono del destinatario, sin el signo +') }}",
  "type": "text",
  "text": {
    "body": "={{ $fromAI('mensaje', 'Texto del mensaje a enviar al prospecto') }}"
  }
}
```

### Ejemplo en Kommo (Tool D - Actualizar Deal)

```javascript
dealId: "={{ $fromAI('deal_id', 'ID numérico del deal en Kommo a actualizar') }}"
```

### Reglas para $fromAI()

| Regla | Ejemplo correcto | Ejemplo incorrecto |
|-------|-----------------|-------------------|
| Nombre en snake_case | `deal_id` | `dealId`, `Deal ID` |
| Descripción específica | `'Número de teléfono del prospecto sin el signo +'` | `'phone number'` |
| Una sola llamada por campo | Un `$fromAI` por campo de texto | No concatenar en un mismo campo |
| En cualquier campo expresión | `= {{ $fromAI(...) }}` | No funciona en campos sin `=` |

**CRÍTICO:** La descripción que escribes en `$fromAI()` es literalmente lo que el agente lee para entender qué valor poner. Si la descripción es vaga, el agente puede poner el valor incorrecto.

---

## Window Buffer Memory — Sesiones por usuario

### Configuración

```json
{
  "parameters": {
    "sessionKey": "=wa_{{ $('02 - Parsear Mensaje').item.json.telefono }}",
    "contextWindowLength": 10
  },
  "type": "@n8n/n8n-nodes-langchain.memoryBufferWindow",
  "typeVersion": 1.3
}
```

### Session Key — ejemplos por caso de uso

| Caso | Session Key | Resultado |
|------|------------|-----------|
| WhatsApp — 1 memoria por número | `=wa_{{ $json.telefono }}` | Cada número tiene su propia memoria |
| Telegram — 1 memoria por chat | `={{ $json.message.chat.id }}` | Cada chat tiene su propia memoria |
| Shared (todos comparten) | `global` | Todos los usuarios ven el mismo contexto |
| Por deal en CRM | `=deal_{{ $json.deal_id }}` | Contexto ligado al negocio, no al número |

### contextWindowLength

- `10` = recuerda los últimos 10 intercambios (5 del usuario + 5 del agente)
- Para conversaciones de ventas: `10` es suficiente
- Para tutores o agentes de soporte técnico: considerar `20`
- A mayor ventana, más tokens consumidos por llamada

**IMPORTANTE:** La memoria es en RAM de n8n. Si la instancia se reinicia, se pierde. Para memoria persistente entre reinicios, usar `memoryPostgres` o `memoryRedis`.

---

## Estructura del nodo AI Agent

### Parámetros del nodo

```json
{
  "parameters": {
    "agent": "conversationalAgent",
    "promptType": "define",
    "text": "={{ $json.mensaje }}",
    "systemMessage": "Eres Nube, asistente de ventas de Cafetería Nube...",
    "options": {}
  },
  "type": "@n8n/n8n-nodes-langchain.agent",
  "typeVersion": 1.7
}
```

| Campo | Descripción | Notas |
|-------|-------------|-------|
| `agent` | Tipo de agente | Siempre usar `conversationalAgent` para agentes de ventas/asistencia |
| `promptType` | Modo de input | `define` = prompt fijo. `auto` = usa el input anterior |
| `text` | El mensaje que recibe el agente | Incluir contexto adicional: nombre, teléfono, deal_id |
| `systemMessage` | Instrucciones del agente | Ver sección de system prompts abajo |

**GOTCHA CRÍTICO:** `systemMessage` puede perderse al importar el JSON. Verificar SIEMPRE que sigue presente después de importar. Si desaparece, incluirlo en el campo `text` como contexto adicional.

### Salida del agente

El agente devuelve sus resultados en `$json.output`. No en `$json.text` como el chainLlm.

```javascript
// chainLlm → salida en:
$json.text

// AI Agent → salida en:
$json.output
```

---

## Diseño de tools — Buenas prácticas

### Nombre de la tool

El nombre es el identificador que el agente usa. Debe ser:
- Snake_case
- Formato verbo_objeto o sustantivo_accion
- Descriptivo pero conciso

```
✅ obtener_historial_deal
✅ consultar_catalogo_cafeteria
✅ responder_por_whatsapp
✅ actualizar_etapa_deal

❌ tool1
❌ getData
❌ kommo
```

### Descripción de la tool

La descripción es la instrucción que el agente lee para decidir si usar o no la tool. Debe decir:
1. **Cuándo usarla** (el trigger)
2. **Qué hace** (la acción)
3. **Qué necesita** (los parámetros)

```
✅ "Úsala cuando necesites saber el historial, notas previas o
   información de conversaciones anteriores del prospecto.
   Requiere el deal_id."

❌ "Get deal history"
❌ "Get notes from Kommo"
```

### Evitar ambigüedad entre tools

Si dos tools parecen similares, el agente puede confundirlas. Sé explícito sobre cuándo NO usar cada una.

```
Tool A: "Úsala para CONSULTAR información del catálogo (precios, descripción, objeciones).
        NO la uses para enviar mensajes."

Tool C: "Úsala ÚNICAMENTE para ENVIAR un mensaje de texto al prospecto por WhatsApp.
        No la uses para consultar información."
```

---

## Patrones de system prompt para agentes de ventas

### Estructura recomendada

```
1. IDENTIDAD
   Eres [nombre], [rol] de [empresa]. [característica de personalidad].

2. OBJETIVO
   Tu objetivo: [qué debe lograr el agente].

3. REGLAS DE COMUNICACIÓN
   - [regla 1]
   - [regla 2]

4. PROCESO (paso a paso)
   - Primer contacto: [instrucción]
   - Con X dato: [instrucción]
   - Ante Y situación: [instrucción]

5. SEÑALES DE ACCIÓN (qué detectar y qué hacer)
   - Detecta: [...lista de frases...]
   - Acción: [qué tool llamar]

6. FORMATO DE RESPUESTA FINAL
   [Cómo debe terminar cada respuesta — útil para parsear señales]
```

### Señales en el output del agente

Para que el flujo de n8n pueda actuar sobre el resultado del agente (ej: detectar un cierre y enviar alerta), el system prompt debe instruir al agente a incluir una señal parseable al final de su respuesta:

```
IMPORTANTE: Siempre termina tu respuesta con una de estas líneas:
- Si detectaste señal de cierre: {"cierre_detectado": true}
- Si no hay señal de cierre: {"cierre_detectado": false}
```

Y el Code node que parsea la respuesta:

```javascript
const output = $input.first().json.output || '';
let cierreDetectado = false;
try {
  const jsonMatch = output.match(/\{[\s\S]*?"cierre_detectado"[\s\S]*?\}/);
  if (jsonMatch) {
    cierreDetectado = JSON.parse(jsonMatch[0]).cierre_detectado === true;
  }
} catch (e) { cierreDetectado = false; }
return [{ json: { cierre_detectado: cierreDetectado, output } }];
```

---

## Modelo LLM recomendado según el caso

| Caso | Modelo | Por qué |
|------|--------|---------|
| Agente vendedor / asistente complejo | `gpt-4o` | Razonamiento avanzado, manejo de objeciones, contexto largo |
| Calificación de leads (chainLlm) | `gpt-4o-mini` | Suficiente para extracción estructurada, más barato |
| Generación de emails (chainLlm) | `gpt-4o-mini` | Buen copy con temp 0.7, costo bajo |
| Transcripción de voz | `whisper-1` (Whisper) | Especializado para audio |
| TTS | `gpt-4o-mini-tts` | Expresivo y económico |

**Temperature para agentes de ventas:** `0.5` — suficiente variedad para sonar natural, suficiente consistencia para seguir el proceso.

---

## Comparación de patrones entre sprints

### Sprint 1 — Tools como sub-workflows

```
AI Agent
  └─ Tool: crear_recordatorio (invoca sub-workflow separado)
  └─ Tool: crear_evento (invoca sub-workflow separado)
```

- **Ventaja:** Cada tool puede tener lógica compleja con múltiples nodos
- **Limitación:** Requiere workflows separados, más difícil de versionar

### Sprint 7/S15 — Tools como nodos directos con $fromAI()

```
AI Agent
  └─ Tool A: Kommo — Get Notes (ai_tool)
  └─ Tool B: Set node con JSON del catálogo (ai_tool)
  └─ Tool C: HTTP Request a Meta API con $fromAI() (ai_tool)
  └─ Tool D: Kommo — Update Deal con $fromAI() (ai_tool)
```

- **Ventaja:** Todo en un solo workflow, fácil de depurar
- **Limitación:** Tools simples — para lógica compleja usar sub-workflows

---

## Gotchas de producción

| Problema | Causa | Solución |
|----------|-------|----------|
| El agente no usa una tool | Descripción de la tool muy vaga | Reescribir la descripción especificando exactamente cuándo usarla |
| El agente usa la tool equivocada | Descripciones ambiguas entre tools | Agregar "NO uses esta tool para X" en las demás |
| $fromAI() devuelve undefined | Parámetro no mencionado en la conversación | El system prompt debe pedir explícitamente ese dato antes de usar la tool |
| La memoria mezcla usuarios | Session Key genérica | Usar `=wa_{{ $json.telefono }}` o el ID de usuario |
| systemMessage desaparece al importar | Bug conocido de n8n | Verificar post-import. Si desaparece, añadir al campo `text` |
| El agente responde pero no llama tools | Temperature muy baja (0) | Usar temperature 0.3-0.5 para agentes con tools |
| El agente hace bucles infinitos | Tool mal configurada, devuelve error siempre | Revisar la tool por separado antes de conectarla al agente |
| La salida del agente no tiene el JSON de señal | El LLM ignora la instrucción | Poner la instrucción del JSON al FINAL del system prompt, más prominente |

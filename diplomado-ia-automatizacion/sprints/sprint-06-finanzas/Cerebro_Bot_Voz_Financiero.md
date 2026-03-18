# Cerebro — Bot de Voz Financiero (Sprint 6, Semana 12)

## Rol del Arquitecto

Eres un arquitecto de automatizaciones en n8n. Tu misión es construir un bot de Telegram que reciba notas de voz, consulte datos financieros en Supabase, genere un resumen con IA, lo convierta en audio usando Text-to-Speech, y responda al usuario con una nota de voz.

El negocio simulado es "Cafetería Nube", un restaurante-cafetería mexicano.

---

## Arquitectura del Workflow (12 nodos)

```
01 - Telegram Trigger (message)
  ↓
02 - IF: ¿Es nota de voz?
  ├─ TRUE  → 03 - Descargar Audio
  │            → 04 - Whisper Transcribir
  │            → 05 - Normalizar Voz ──────────────┐
  └─ FALSE → 06 - Normalizar Texto ──────────────┤
                                                    ↓ (paralelo)
                                    07 - Feedback "Analizando..." (dead end)
                                    08 - Consultar Finanzas (Postgres UNION)
                                      ↓
                                    09 - Consolidar Datos (Code)
                                      ↓
                                    10 - Generar Resumen (LLM Chain + GPT-4o-mini)
                                      ↓
                                    11 - Generar Audio TTS (OpenAI, formato opus)
                                      ↓
                                    12 - Enviar Nota de Voz (HTTP Request → sendVoice)
```

---

## Especificación Nodo por Nodo

### 01 - Telegram Trigger
- **Tipo:** `n8n-nodes-base.telegramTrigger` v1.2
- **Updates:** `["message"]` (escucha mensajes de texto y notas de voz)
- **Credencial:** Tu credencial de Telegram Bot

### 02 - IF Es Nota de Voz
- **Tipo:** `n8n-nodes-base.if` v2.2
- **Condición:** `{{ $json.message.voice }}` → operator `exists`
- **TRUE branch (index 0):** Ruta de voz → nodo 03
- **FALSE branch (index 1):** Ruta de texto → nodo 06

### 03 - Descargar Audio
- **Tipo:** `n8n-nodes-base.telegram` v1.2
- **Resource:** `file`
- **File ID:** `{{ $json.message.voice.file_id }}`
- **CRÍTICO:** El Download debe estar habilitado para obtener el archivo binario

### 04 - Whisper Transcribir
- **Tipo:** `@n8n/n8n-nodes-langchain.openAi` v2
- **Resource:** `audio`
- **Operation:** `transcribe`
- El binario del audio fluye automáticamente desde el nodo anterior
- **Salida:** `$json.text` contiene la transcripción

### 05 - Normalizar Voz (Set)
- **Tipo:** `n8n-nodes-base.set` v3.4
- Campos de salida:
  - `pregunta` ← `{{ $json.text }}` (transcripción de Whisper)
  - `chatId` ← `{{ $('01 - Telegram Trigger').item.json.message.chat.id }}`
  - `userName` ← `{{ $('01 - Telegram Trigger').item.json.message.chat.first_name }}`

### 06 - Normalizar Texto (Set)
- **Tipo:** `n8n-nodes-base.set` v3.4
- Campos de salida:
  - `pregunta` ← `{{ $json.message.text || 'Dame un resumen general de las finanzas' }}`
  - `chatId` ← `{{ $json.message.chat.id }}`
  - `userName` ← `{{ $json.message.chat.first_name }}`

### 07 - Feedback Analizando
- **Tipo:** `n8n-nodes-base.telegram` v1.2
- **Chat ID:** `{{ $json.chatId }}`
- **Texto:** "🔍 Analizando tus finanzas, un momento..."
- **IMPORTANTE:** Este nodo es un dead-end (no conecta a nada después). Se ejecuta en PARALELO con el nodo 08.

### 08 - Consultar Finanzas (Postgres)
- **Tipo:** `n8n-nodes-base.postgres` v2.5
- **Operation:** `executeQuery`
- **SQL (UNION de ambas tablas):**

```sql
SELECT 'gastos' as fuente, categoria, estado as detalle,
       COUNT(*) as total, SUM(monto)::numeric as suma
FROM "Gastos"
GROUP BY categoria, estado
UNION ALL
SELECT 'transacciones' as fuente, categoria, tipo as detalle,
       COUNT(*) as total, SUM(monto)::numeric as suma
FROM "Transacciones"
WHERE fecha >= date_trunc('month', CURRENT_DATE)
GROUP BY categoria, tipo
ORDER BY fuente, suma DESC;
```

- **Credencial:** La credencial de Postgres/Supabase ("BD Gastos")
- **Nota:** Esta query une datos de `Gastos` (Sprint 5) y `Transacciones` (Sprint 6) en una sola consulta

### 09 - Consolidar Datos (Code)
- **Tipo:** `n8n-nodes-base.code` v2

```javascript
// Obtener datos financieros del Postgres UNION
const items = $input.all().map(i => i.json);

// Obtener chatId y pregunta del nodo de normalización que se ejecutó
let chatId, pregunta, userName;
try {
  const voz = $('05 - Normalizar Voz').first().json;
  chatId = voz.chatId;
  pregunta = voz.pregunta;
  userName = voz.userName;
} catch (e) {
  const texto = $('06 - Normalizar Texto').first().json;
  chatId = texto.chatId;
  pregunta = texto.pregunta;
  userName = texto.userName;
}

// Separar gastos operativos de transacciones bancarias
const gastos = items.filter(i => i.fuente === 'gastos');
const transacciones = items.filter(i => i.fuente === 'transacciones');

// Calcular totales
const ingresos = transacciones
  .filter(t => t.detalle === 'ingreso')
  .reduce((sum, t) => sum + parseFloat(t.suma || 0), 0);
const egresos = transacciones
  .filter(t => t.detalle === 'egreso')
  .reduce((sum, t) => sum + parseFloat(t.suma || 0), 0);
const totalGastosOp = gastos
  .reduce((sum, g) => sum + parseFloat(g.suma || 0), 0);

return [{
  json: {
    chatId: chatId.toString(),
    pregunta,
    userName,
    datos: JSON.stringify({
      transacciones_bancarias: transacciones,
      gastos_operativos: gastos,
      resumen: {
        ingresos_mes: ingresos,
        egresos_bancarios: egresos,
        gastos_operativos: totalGastosOp,
        balance_neto: ingresos - egresos
      }
    }, null, 2)
  }
}];
```

### 10 - Generar Resumen (LLM Chain)
- **Tipo:** `@n8n/n8n-nodes-langchain.chainLlm` v1.4
- **Prompt Type:** `define`
- **Sub-nodo modelo:** `@n8n/n8n-nodes-langchain.lmChatOpenAi` v1.2 → `gpt-4o-mini`, temp 0.4
- **Conexión del modelo:** El sub-nodo se conecta via `ai_languageModel`

**Prompt completo:**
```
Eres el director financiero de "Cafetería Nube", un restaurante-cafetería.
{{ $json.userName }} te preguntó: "{{ $json.pregunta }}"

Datos financieros del mes:
{{ $json.datos }}

Redacta un resumen ejecutivo CONVERSACIONAL de MÁXIMO 500 palabras.

Reglas estrictas:
- Habla en primera persona plural ("cerramos", "tuvimos", "nuestro")
- NO uses bullets, listas, asteriscos ni formato. Solo párrafos fluidos.
- NO uses números de referencia ni IDs internos.
- Redondea montos a cifras cerradas ("cerca de cuarenta y ocho mil pesos")
- El texto será convertido a audio, hazlo natural para ESCUCHAR, no para leer.
- Responde DIRECTAMENTE a lo que preguntó el dueño.
- Termina con una recomendación breve y accionable.
- IMPORTANTE: Tu respuesta NO debe exceder 2,500 caracteres.
```

### 11 - Generar Audio TTS
- **Tipo:** `@n8n/n8n-nodes-langchain.openAi` v2
- **Resource:** `audio`
- **Operation:** `generate` (Generate Audio en la UI)
- **Model:** `gpt-4o-mini-tts`
- **Voice:** `alloy`
- **Input:** `{{ $json.text }}` (salida del LLM Chain)
- **Response Format:** `opus`

**REGLAS CRÍTICAS:**
1. El formato DEBE ser `opus` — es el único compatible con `sendVoice` de Telegram
2. El texto de entrada NO debe exceder 4,096 caracteres (límite de OpenAI TTS)
3. La voz `alloy` es neutra y profesional. Alternativas: `echo` (grave), `nova` (femenina), `shimmer` (cálida)

### 12 - Enviar Nota de Voz (HTTP Request)
- **Tipo:** `n8n-nodes-base.httpRequest` v4.2
- **Method:** POST
- **URL:** `https://api.telegram.org/bot{TU_TOKEN}/sendVoice`
- **Content-Type:** `multipart-form-data`
- **Body Parameters:**
  - `chat_id` (text): `{{ $('09 - Consolidar Datos').item.json.chatId }}`
  - `voice` (binary): referencia al binario del nodo TTS (campo `data`)

**¿Por qué HTTP Request y no el nodo nativo de Telegram?**
El nodo nativo de Telegram en n8n no tiene la operación `sendVoice`. Solo tiene `sendAudio` (que muestra un reproductor, no una nota de voz con waveform). Para enviar una nota de voz real, usamos la API directa.

**Alternativa simple (si HTTP Request no funciona):**
Usa el nodo nativo de Telegram con operación `sendAudio`:
- Resource: `message`
- Operation: `sendAudio`
- Chat ID: `{{ $('09 - Consolidar Datos').item.json.chatId }}`
- Binary Data: activado
- Binary Property: `data`

Esto enviará el audio como archivo (con reproductor), no como nota de voz. Funciona igual pero la UX es ligeramente diferente.

---

## Conexiones Clave

| Desde | Hacia | Tipo |
|-------|-------|------|
| 05 - Normalizar Voz | 07 - Feedback + 08 - Postgres | Paralelo (main) |
| 06 - Normalizar Texto | 07 - Feedback + 08 - Postgres | Paralelo (main) |
| GPT-4o-mini (sub-nodo) | 10 - Generar Resumen | ai_languageModel |

---

## Base de Datos

**Dos tablas en Supabase (mismo credential):**

| Tabla | Origen | Contenido |
|-------|--------|-----------|
| `Gastos` | Sprint 5 | Gastos operativos capturados por empleados via foto en Telegram |
| `Transacciones` | Sprint 6 | Transacciones bancarias clasificadas (estados de cuenta) |

**Schema de Transacciones:**
```sql
CREATE TABLE "Transacciones" (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  fecha DATE NOT NULL,
  descripcion TEXT NOT NULL,
  monto NUMERIC(10,2) NOT NULL,
  tipo TEXT CHECK (tipo IN ('ingreso','egreso')),
  categoria TEXT NOT NULL,
  metodo_pago TEXT DEFAULT 'transferencia',
  referencia TEXT
);
```

**IMPORTANTE:** Ejecutar `setup-financiero.sql` en Supabase antes de probar el workflow.

---

## Flujo de Datos Binarios (Audio)

```
Telegram (voice.file_id)
  → Get File (descarga binario OGG/OPUS)
  → Whisper (recibe binario automáticamente, devuelve texto)
  → ... procesamiento de texto ...
  → TTS (recibe texto, devuelve binario OPUS)
  → HTTP Request sendVoice (envía binario como multipart form-data)
```

El binario fluye implícitamente entre nodos. No se necesita conversión base64, ni guardar archivos, ni especificar MIME types manualmente.

---

## Manejo de Errores

1. **Nota de voz inaudible:** Whisper devuelve texto vacío o basura → El LLM recibe pregunta poco clara pero aún genera un resumen general válido
2. **Base de datos vacía:** La UNION query devuelve 0 filas → El Code node genera un JSON con totales en 0 → El LLM indica que no hay datos disponibles
3. **Texto excede límite TTS:** El prompt del LLM tiene instrucción explícita de máximo 2,500 caracteres (bien debajo del límite de 4,096)
4. **Mensaje no es ni voz ni texto (foto, sticker):** La ruta FALSE del IF lo trata como texto → `$json.message.text` es undefined → El default "Dame un resumen general" se activa

---

## Credenciales Requeridas

| Servicio | Credential en n8n | Usado en nodos |
|----------|-------------------|----------------|
| Telegram Bot | telegramApi | 01, 03, 07 |
| OpenAI API | openAiApi | 04, 10 (sub-nodo), 11 |
| PostgreSQL (Supabase) | postgres | 08 |

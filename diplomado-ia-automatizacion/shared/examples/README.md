# Ejemplos Reutilizables

Fragmentos de n8n extraídos de workflows reales del diplomado. Usa estos ejemplos como referencia o punto de partida al construir tus flujos.

> Todos los ejemplos usan credenciales placeholder (`TU_CREDENTIAL_ID`). Reemplázalas con las tuyas antes de usar.

---

## nodos/ — Nodos individuales (8 archivos JSON)

Configuraciones de nodos listos para copiar a tu workflow.

| Archivo | Descripción |
|---|---|
| `telegram-trigger-message.json` | Telegram Trigger para mensajes de texto/voz/foto |
| `telegram-trigger-callback.json` | Telegram Trigger para respuestas de botones inline |
| `telegram-send-inline-buttons.json` | Enviar mensaje con botones Aprobar/Rechazar |
| `openai-vision-http-request.json` | HTTP Request a OpenAI Vision con imagen en base64 |
| `openai-chat-json-output.json` | OpenAI Chat con formato de salida JSON |
| `postgres-insert-returning.json` | Postgres INSERT con RETURNING id |
| `postgres-select-query.json` | Postgres SELECT query |
| `webhook-get-respond-html.json` | Webhook GET + Respond to Webhook con text/html |

## patrones/ — Combinaciones multi-nodo (4 archivos JSON)

Pipelines de 3-4 nodos con sus conexiones, listos para integrar en un workflow.

| Archivo | Nodos incluidos |
|---|---|
| `canva-upload-poll-create.json` | Upload Asset → Poll Status → Create Design |
| `heygen-create-poll.json` | Create Video → Wait 5min → Poll Status |
| `telegram-photo-to-vision.json` | IF tiene foto → Get File → OpenAI Vision |
| `webhook-to-html-report.json` | Webhook GET → Postgres → LLM → Respond HTML |

## code-snippets/ — Scripts para nodos Code (4 archivos JS)

Código JavaScript completo para nodos Code, con documentación de entrada/salida.

| Archivo | Función |
|---|---|
| `parsear-respuesta-openai.js` | Parsear JSON de OpenAI, limpiar backticks de markdown |
| `extraer-callback-data.js` | Extraer acción e ID de un callback_data de Telegram |
| `validar-campos-requeridos.js` | Validar que campos requeridos existen y no estén vacíos |
| `formatear-fecha-iso.js` | Convertir fecha/hora en texto a formato ISO para Google Calendar |

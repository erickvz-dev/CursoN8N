# Sprint 1 — Asistente Personal por Voz

## Objetivo
Conectar Telegram con n8n para recibir mensajes de voz, transcribirlos con Whisper y ejecutar acciones (agendar en Google Calendar o guardar recordatorios).

## Entregables
- [ ] Flujo: Recepción de audio por Telegram
- [ ] Flujo: Transcripción con Whisper (OpenAI Audio)
- [ ] Flujo: Clasificador de intención (agendar / recordatorio / otro)
- [ ] Flujo: Creación de evento en Google Calendar
- [ ] Flujo: Respuesta de confirmación por Telegram

## Herramientas
- Telegram Bot API
- OpenAI Whisper (`audio/transcriptions`)
- OpenAI GPT (clasificación de intención)
- Google Calendar API (OAuth2)

## Variables de entorno requeridas
```env
TELEGRAM_BOT_TOKEN=
OPENAI_API_KEY=
GOOGLE_CALENDAR_CREDENTIALS=
```

## Arquitectura del flujo
```
Telegram Trigger → Download Audio → Whisper Transcribe → 
GPT Classify Intent → IF agendar → Google Calendar → 
Telegram Response
                 → IF recordatorio → Set Node → Telegram Response
```

## Archivos incluidos

### flujos/ (6 workflows)
- `Asistente Telegram con Agent.json` — Asistente completo usando AI Agent con tools
- `Asistente Telegram Sin Agente.json` — Versión sin agente, lógica manual con IF/Switch
- `Tool - Consultar Agenda.json` — Subworkflow: consultar eventos de Google Calendar
- `Tool - Crear Evento.json` — Subworkflow: crear evento en Google Calendar
- `Tool - Crear Recordatorio.json` — Subworkflow: guardar recordatorio en Google Sheets
- `Tool - Guardar Nota.json` — Subworkflow: guardar nota en Google Sheets

### ejercicios/ (7 ejercicios progresivos)
- `WF-01-HolaMundo_v1.json` — Hola Mundo: primer workflow en n8n
- `WF-02-Telegram.json` — Conectar Telegram Trigger
- `WF-03-Whisper.json` — Transcribir audio con Whisper
- `WF-04-Http+JSON+Branching.json` — HTTP Request, JSON y branching
- `WF-05-API-Postman.json` — Integración con APIs externas
- `WF-06-API-Google Calendar.json` — Google Calendar API
- `WF-07-Whisper comandos inteligentes.json` — Comandos de voz inteligentes

> Los workflows usan credenciales placeholder (`TU_CREDENTIAL_ID`). Configura las tuyas en n8n antes de importar.

## Prompt de inicio sugerido
```
Estoy en el Sprint 1. Quiero construir el asistente de voz en Telegram
que transcribe audios con Whisper y agenda eventos en Google Calendar.
Tengo el bot de Telegram y la API key de OpenAI configurados.
```

# Sprint 5 — Operaciones y Control de Gastos

## Objetivo
Dos flujos complementarios: (1) Aprobación de gastos en tiempo real vía Telegram con botones interactivos y registro en Supabase. (2) Sistema de consulta bajo demanda mediante Webhook que genera un reporte financiero HTML en el navegador.

## Entregables
### Parte 1 — Flujo de Aprobación
- [ ] Empleado envía recibo (foto/PDF) por Telegram
- [ ] IA extrae monto, descripción y categoría del recibo
- [ ] Mensaje al gerente con botones: ✅ Aprobar / ❌ Rechazar
- [ ] Según respuesta: actualizar Supabase + notificar al empleado

### Parte 2 — Reporte Bajo Demanda
- [ ] Webhook recibe solicitud con parámetros (fecha, departamento)
- [ ] Query a Supabase con filtros
- [ ] Generación de HTML con tabla y totales
- [ ] Respuesta directa al navegador (Respond to Webhook)

## Variables de entorno requeridas
```env
TELEGRAM_BOT_TOKEN=
OPENAI_API_KEY=
SUPABASE_URL=
SUPABASE_SERVICE_KEY=
```

## Estructura de Supabase recomendada
**Tabla: gastos**
```sql
CREATE TABLE gastos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  empleado_nombre TEXT,
  empleado_telegram_id TEXT,
  monto DECIMAL(10,2),
  descripcion TEXT,
  categoria TEXT,
  estado TEXT DEFAULT 'pendiente', -- pendiente | aprobado | rechazado
  gerente_id TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

## Concepto clave: Botones en Telegram
Los botones interactivos en Telegram usan `callback_query`, no mensajes normales. El flujo necesita:
1. Enviar mensaje con `inline_keyboard`
2. Separar el trigger: un webhook para mensajes, otro para callbacks
3. Responder al callback con `answerCallbackQuery` para quitar el "loading"

## Archivos incluidos

### flujos/ (1 workflow)
- `Sprint5 - Captura de Gastos.json` — Flujo de captura: recibo por Telegram, extracción con IA, registro en Supabase

### Documentos técnicos (Cerebros)
- `Cerebro_Maestro_n8n.md` — Conocimiento permanente de n8n: expresiones, Telegram, OpenAI Vision, Postgres, webhooks
- `Cerebro_Telegram_Gastos.md` — Especificación nodo-por-nodo de los 2 workflows (Captura + Aprobación)
- `Cerebro_Reportes_Tiempo_Real.md` — Patrón Webhook GET → Postgres → LLM → HTML report

> El workflow usa credenciales placeholder (`TU_CREDENTIAL_ID`). Configura las tuyas en n8n antes de importar.

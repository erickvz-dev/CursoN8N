# Sprint 6 — Finanzas

## Objetivo
Construir dos sistemas: (1) Clasificador de transacciones bancarias desde un archivo CSV (Semana 11). (2) Bot de voz en Telegram que usa Text-to-Speech para responder con un resumen de audio de las finanzas (Semana 12).

Negocio simulado: **Cafetería Nube** (restaurante/cafetería mexicano).

---

## Conexión con Sprint 5

Este sprint reutiliza la tabla `Gastos` creada en el Sprint 5 (Operaciones/Gastos). El bot de voz consulta **ambas tablas** para dar un panorama financiero completo:

| Tabla | Sprint | Contenido |
|-------|--------|-----------|
| `Gastos` | Sprint 5 | Gastos operativos capturados por empleados via foto en Telegram |
| `Transacciones` | Sprint 6 | Transacciones bancarias clasificadas (estados de cuenta) |

---

## Setup inicial

### 1. Ejecutar SQL en Supabase

Abrir el SQL Editor de Supabase y ejecutar el archivo:

```
setup-financiero.sql
```

Esto crea:
- Tabla `Transacciones` con schema completo
- ~30 transacciones bancarias de prueba (febrero 2025)
- ~15 gastos operativos de prueba en tabla `Gastos`

### 2. Verificar tablas

```sql
SELECT COUNT(*) FROM "Transacciones";  -- Debe dar ~30
SELECT COUNT(*) FROM "Gastos";          -- Debe dar >= 15
```

### 3. Importar workflow en n8n

Importar `flujos/Sprint6 - Bot Voz Financiero.json` y verificar que las credenciales estén asignadas.

---

## Entregables

### Parte 1 — Clasificador Bancario (Semana 11)
- [ ] Recepción de archivo bancario (CSV)
- [ ] Parsing con nodo Spreadsheet File
- [ ] Clasificación de cada transacción con IA (categoría + tipo)
- [ ] Generación de reporte con totales por categoría
- [ ] Exportación a Supabase (tabla `Transacciones`)

### Parte 2 — Bot de Voz Financiero (Semana 12)
- [x] Trigger de Telegram que escucha notas de voz Y texto
- [x] Whisper para transcribir la pregunta del usuario
- [x] Query UNION a Postgres (Gastos + Transacciones)
- [x] LLM Chain genera resumen ejecutivo conversacional
- [x] OpenAI TTS (gpt-4o-mini-tts) convierte a audio formato opus
- [x] Envío como nota de voz via Telegram sendVoice
- [x] Mensaje de feedback "Analizando tus finanzas..."
- [x] Manejo de input texto como fallback (no solo voz)

---

## Arquitectura — Bot de Voz (Semana 12)

```
01 - Telegram Trigger
  ↓
02 - IF: ¿Es nota de voz?
  ├─ SÍ → 03 - Descargar Audio → 04 - Whisper → 05 - Normalizar Voz ──┐
  └─ NO → 06 - Normalizar Texto ───────────────────────────────────────┤
                                                                        ↓ (paralelo)
                                          07 - Feedback "Analizando..." (dead end)
                                          08 - Consultar Finanzas (Postgres UNION)
                                            ↓
                                          09 - Consolidar Datos (Code)
                                            ↓
                                          10 - Generar Resumen (LLM Chain + GPT-4o-mini)
                                            ↓
                                          11 - Generar Audio TTS (gpt-4o-mini-tts, opus)
                                            ↓
                                          12 - Enviar Nota de Voz (HTTP → sendVoice)
```

---

## Base de datos: Tabla Transacciones

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

**Categorías de egresos:** nomina, renta, servicios, proveedores, impuestos, mantenimiento, plataformas, insumos
**Categorías de ingresos:** ventas_local, ventas_delivery, catering, otro
**Métodos de pago:** transferencia, tarjeta, efectivo, cheque

---

## Credenciales requeridas en n8n

| Servicio | Tipo de credencial | Usado en |
|----------|-------------------|----------|
| Telegram Bot | telegramApi | Trigger, Get File, Feedback |
| OpenAI API | openAiApi | Whisper, LLM Chain (sub-nodo), TTS |
| PostgreSQL (Supabase) | postgres | Consulta UNION |

---

## Notas técnicas

- **Modelo TTS:** `gpt-4o-mini-tts` con voz `alloy` — voces expresivas con control de tono
- **Formato audio:** `opus` — obligatorio para que Telegram lo muestre como nota de voz
- **Límite TTS:** 4,096 caracteres máximo. El prompt del LLM impone 2,500 chars como safety margin
- **sendVoice:** El nodo nativo de Telegram no tiene esta operación, se usa HTTP Request con multipart/form-data
- **Query:** UNION ALL entre `Gastos` y `Transacciones` en una sola consulta para simplicidad

---

## Flujos en esta carpeta

- `flujos/Sprint6 - Bot Voz Financiero.json` — Workflow completo de la Semana 12
- `setup-financiero.sql` — Script SQL para crear tabla y datos de prueba
- `Cerebro_Bot_Voz_Financiero.md` — Instrucciones para Antigravity

# Estructura del Proyecto

## Sprints

| Sprint | Tema                     | Semanas | Tecnologías clave                                                                     |
| ------ | ------------------------ | ------- | ------------------------------------------------------------------------------------- |
| 01     | Asistente de voz         | 1-2     | Telegram, Whisper, OpenAI Chat, Memory Buffer                                         |
| 02     | Producción visual        | 3-4     | Airtable, OpenAI Vision/DALL-E, HeyGen                                                |
| 03     | Marketing y orquestación | 5-6     | Airtable, Google Sheets, flujos multi-etapa                                           |
| 04     | Recursos Humanos         | 7       | Airtable, Gmail, Google Calendar                                                      |
| 05     | Operaciones / Gastos     | 8       | Telegram, Postgres/Supabase, Webhook HTML                                             |
| 06     | Finanzas                 | 9-10    | Postgres/Supabase, OpenAI TTS, Telegram sendVoice                                     |
| 07     | Ventas (Capstone)        | 11-16   | Meta WhatsApp Cloud API, Kommo CRM (community node), OpenAI AI Agent, Gmail, Telegram |

## Bases de datos externas

### Airtable

| Base       | ID               | Sprint | Tablas                          |
| ---------- | ---------------- | ------ | ------------------------------- |
| Sistema RH | `TU_BASE_ID`    | 4      | Candidatos (`TU_TABLE_ID`)      |

**Tabla Candidatos:**

- Columnas: Nombre, Email, CV_Texto, Score, Estado
- Estados: Nuevo, Entrevista, Rechazado, Aceptado

> **¿Dónde consigo mi Base ID?** En Airtable → abre tu base → la URL incluye `app...` — ese es tu Base ID.

### Supabase (PostgreSQL)

| Tabla           | Sprint | Columnas                                                                            | Notas                                   |
| --------------- | ------ | ----------------------------------------------------------------------------------- | --------------------------------------- |
| `Gastos`        | 5, 6   | id, created_at, empleado, monto, categoria, estado                                  | Estados: Pendiente, Aprobado, Rechazado |
| `Transacciones` | 6      | id, created_at, fecha, descripcion, monto, tipo, categoria, metodo_pago, referencia | Tipos: ingreso, egreso                  |

**Notas sobre Supabase:**

- Columnas siempre lowercase (sin comillas dobles al crear)
- Nombres de tabla con mayúscula requieren comillas dobles en queries: `"Gastos"`, `"Transacciones"`
- `created_at` es auto-generado (TIMESTAMPTZ DEFAULT NOW())
- Credential: `TU_CREDENTIAL_ID` ("BD Gastos")

## Conexiones entre sprints

```
Sprint 1 (Whisper STT)
    ↓ patrón reutilizado en Sprint 6
Sprint 5 (Telegram + Postgres + LLM)
    ↓ tabla Gastos reutilizada en Sprint 6
Sprint 6 (TTS + Gastos + Transacciones)
```

- Sprint 6 reutiliza la tabla `Gastos` del Sprint 5 y agrega `Transacciones`
- Sprint 6 reutiliza el patrón Telegram Trigger → Whisper del Sprint 1
- Sprint 6 reutiliza el patrón chainLlm + Code consolidation del Sprint 5

## Nomenclatura de archivos

### Workflows JSON

- Nombre: `Sprint{N} - {Nombre Descriptivo}.json`
- Ejemplos: `Sprint5 - Captura de Gastos.json`, `Sprint6 - Bot Voz Financiero.json`

### Cerebros

- Nombre: `Cerebro_{Nombre_Workflow}.md`
- Ejemplos: `Cerebro_Bot_Voz_Financiero.md`, `Cerebro_Telegram_Gastos.md`

### Guiones

- Nombre: `guiones-semana-{NN}.md`
- Contiene los 3 videos de la semana en un solo archivo

### SQL

- Nombre: `setup-{tema}.sql`
- Ejemplos: `setup-gastos.sql`, `setup-financiero.sql`

## Negocio simulado (Sprint 5-6)

**Cafetería Nube** — restaurante/cafetería mexicano

- Datos de prueba en MXN
- 12 empleados (meseros, cocineros, baristas, gerente)
- Categorías de gasto: comida, transporte, materiales, otro
- Categorías bancarias: nomina, renta, servicios, proveedores, impuestos, mantenimiento, plataformas, insumos, ventas_local, ventas_delivery, catering

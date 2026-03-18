# Sprint 5 - Guía de Configuración Paso a Paso

## Resumen de Workflows

| # | Workflow | Función |
|---|----------|---------|
| 1 | Sprint5 - Captura de Gastos | Bot de Telegram recibe foto de ticket → IA extrae datos → guarda en Supabase → notifica al gerente con botones |
| 2 | Sprint5 - Aprobación de Gastos | Gerente pulsa Aprobar/Rechazar → actualiza estado en Supabase → confirma decisión |
| 3 | Sprint5 - Reporte de Gastos en Tiempo Real | Alguien abre un enlace → consulta Supabase → IA genera reporte HTML → lo muestra en el navegador |

---

## Paso 0 — Configurar Supabase

### 0.1 Crear proyecto en Supabase
1. Ve a [supabase.com](https://supabase.com) y crea un proyecto (o usa uno existente).
2. Anota estos datos de **Project Settings → Database**:
   - **Host**: `db.[TU-PROJECT-REF].supabase.co`
   - **Port**: `5432`
   - **Database**: `postgres`
   - **User**: `postgres`
   - **Password**: la contraseña que elegiste al crear el proyecto

### 0.2 Crear la tabla Gastos
1. En Supabase, ve a **SQL Editor**.
2. Copia y pega el contenido de `setup-gastos.sql`.
3. Haz clic en **Run**.
4. Verifica que aparezcan 10 filas en la tabla.

> Si prefieres crear la tabla desde el **Table Editor**:
> - Nombre: `Gastos`
> - Columnas: `id` (int8, primary key), `Fecha` (text), `Empleado` (text), `Monto` (numeric), `Categoria` (text), `Estado` (text, default: 'Pendiente')

### 0.3 Verificar datos de prueba
Después de ejecutar el SQL, deberías ver estos registros:

| id | Fecha | Empleado | Monto | Categoria | Estado |
|----|-------|----------|-------|-----------|--------|
| 1 | 10/02/2025 | María García | 245.50 | comida | Aprobado |
| 2 | 12/02/2025 | Carlos López | 1850.00 | transporte | Aprobado |
| 3 | 14/02/2025 | Ana Martínez | 520.00 | materiales | Pendiente |
| 4 | 15/02/2025 | Roberto Sánchez | 180.75 | comida | Rechazado |
| 5 | 18/02/2025 | María García | 3200.00 | materiales | Aprobado |
| 6 | 20/02/2025 | Carlos López | 95.00 | comida | Pendiente |
| 7 | 22/02/2025 | Laura Hernández | 750.00 | transporte | Aprobado |
| 8 | 25/02/2025 | Ana Martínez | 340.00 | comida | Pendiente |
| 9 | 27/02/2025 | Roberto Sánchez | 1100.00 | otro | Aprobado |
| 10 | 01/03/2025 | Laura Hernández | 425.50 | materiales | Pendiente |

---

## Paso 1 — Configurar credenciales en n8n

### 1.1 Credencial de Postgres (Supabase)
1. En n8n, ve a **Credentials → Add Credential → Postgres**.
2. Configura:
   - **Host**: `db.[TU-PROJECT-REF].supabase.co`
   - **Port**: `5432`
   - **Database**: `postgres`
   - **User**: `postgres`
   - **Password**: tu contraseña de Supabase
   - **SSL**: Activado (obligatorio para Supabase)
3. Haz clic en **Save**.
4. Anota el **ID** de la credencial (aparece en la URL o al inspeccionar).

### 1.2 Credencial de Telegram Bot
1. En Telegram, busca **@BotFather** y envía `/newbot`.
2. Sigue las instrucciones para nombrar tu bot.
3. BotFather te dará un **token** (ej: `8278455763:AAHn8...`).
4. En n8n, ve a **Credentials → Add Credential → Telegram API**.
5. Pega el token y guarda.

### 1.3 Credencial de OpenAI
1. Ya la tienes configurada con ID: `SNcq9lmxwYGcZb6e`.
2. Si necesitas crear una nueva: **Credentials → Add Credential → OpenAI API**.

### 1.4 Obtener tu Chat ID de gerente
1. Desde la cuenta que será "el gerente", envía cualquier mensaje al bot.
2. En n8n, revisa el log del Telegram Trigger → busca `message.chat.id`.
3. Ese número es tu Chat ID de gerente.
4. Alternativa: escríbele a **@userinfobot** en Telegram.

---

## Paso 2 — Workflow 1: Captura de Gastos

### 2.1 Importar
1. En n8n → **Import from File** → selecciona `Sprint5 - Captura de Gastos.json`.

### 2.2 Configurar credenciales
Después de importar, abre cada nodo y asigna las credenciales correctas:

| Nodo | Credencial |
|------|-----------|
| 01 - Telegram Trigger | Tu credencial de Telegram Bot |
| 03 - Notify Unsupported | Tu credencial de Telegram Bot |
| 04 - Telegram Get File | Tu credencial de Telegram Bot |
| 05 - OpenAI Vision | Tu credencial de OpenAI |
| 08 - Notify Error | Tu credencial de Telegram Bot |
| 09 - Postgres Insert Gastos | Tu credencial de Postgres (Supabase) |
| 12 - Confirm to User | Tu credencial de Telegram Bot |

### 2.3 Configurar Chat ID del gerente
El nodo **11 - Notify Manager** usa un HTTP Request con `$env.TELEGRAM_MANAGER_CHAT_ID`.

Opción A — Variable de entorno:
1. En n8n → **Settings → Variables** (o archivo `.env`).
2. Agrega: `TELEGRAM_MANAGER_CHAT_ID = TU_CHAT_ID`.

Opción B — Hardcodear el Chat ID:
1. Abre el nodo **11 - Notify Manager**.
2. En el JSON Body, reemplaza `{{ $env.TELEGRAM_MANAGER_CHAT_ID }}` por tu Chat ID numérico.

### 2.4 Activar el workflow
1. Haz clic en el toggle **Active** en la esquina superior derecha.
2. El Telegram Trigger empezará a escuchar mensajes.

### 2.5 Probar
| Prueba | Enviar | Resultado esperado |
|--------|--------|-------------------|
| 1 | Texto sin foto al bot | Bot responde: "Solo puedo procesar fotos del ticket" |
| 2 | Foto borrosa/irrelevante | Bot responde con mensaje de error de lectura |
| 3 | Foto clara de un ticket | Supabase crea fila con Estado=Pendiente + gerente recibe mensaje con botones |

---

## Paso 3 — Workflow 2: Aprobación de Gastos

### 3.1 Importar
1. En n8n → **Import from File** → selecciona `Sprint5 - Aprobación de Gastos.json`.

### 3.2 Configurar credenciales

| Nodo | Credencial |
|------|-----------|
| 01 - Telegram Callback Trigger | Tu credencial de Telegram Bot |
| 03 - Postgres Update Estado | Tu credencial de Postgres (Supabase) |
| 05 - Telegram Notificar Resultado | Tu credencial de Telegram Bot |

### 3.3 Configurar nodo 04 - Answer Callback
El nodo **04 - Telegram Answer Callback** usa HTTP Request con el token del bot en la URL.
- Verifica que la URL contiene tu token de bot correcto.
- Si cambiaste de bot, actualiza el token en la URL: `https://api.telegram.org/bot{TU_TOKEN}/answerCallbackQuery`

### 3.4 Activar el workflow
1. Activa el toggle. **Ambos workflows deben estar activos simultáneamente.**

### 3.5 Probar
1. Desde el chat del gerente, pulsa **Aprobar** en un gasto de prueba.
2. Verifica en Supabase que el Estado cambió a **Aprobado**.
3. Verifica que Telegram muestra la confirmación.
4. Repite con **Rechazar** en otro gasto.

---

## Paso 4 — Workflow 3: Reporte en Tiempo Real

### 4.1 Importar
1. En n8n → **Import from File** → selecciona `Sprint5 - Reporte de Gastos en Tiempo Real.json`.

### 4.2 Configurar credenciales

| Nodo | Credencial |
|------|-----------|
| Supabase - Leer Gastos | Tu credencial de Postgres (Supabase) |
| GPT-4o-mini (sub-nodo) | Tu credencial de OpenAI |

### 4.3 Verificar configuración del Webhook
1. Abre el nodo **Webhook - Entrada**.
2. Confirma que:
   - **Method**: GET
   - **Respond**: "Using 'Respond to Webhook' Node"
   - **Path**: `reporte-gastos` (o el que prefieras)

### 4.4 Verificar Respond to Webhook
1. Abre el nodo **Responder al Navegador**.
2. Confirma que tiene el header **Content-Type: text/html**.
3. Sin este header, el navegador muestra código HTML en texto plano.

### 4.5 Nodo "Consolidar Datos"
Este nodo Code agrupa todas las filas de Postgres en un solo JSON antes de enviarlo al LLM. Sin este paso, el modelo se ejecutaría una vez por cada fila de la tabla (caro e incorrecto).

### 4.6 Activar y probar
1. Activa el workflow.
2. Copia la **URL del Webhook** (aparece en el nodo Webhook - Entrada).
3. Ábrela en tu navegador.
4. Deberías ver una página HTML con el reporte financiero.

---

## Paso 5 — Prueba de punta a punta

### Pipeline completo
1. Desde tu celular, envía una foto de un ticket al bot de Telegram.
2. Verifica en Supabase que el gasto aparece con Estado = **Pendiente**.
3. Desde la cuenta del gerente, pulsa **Aprobar**.
4. Verifica que el estado cambió a **Aprobado** en Supabase.
5. Abre el enlace del reporte en el navegador → el nuevo gasto debe aparecer.
6. Envía otro ticket y esta vez **Rechaza** → verifica el estado en Supabase.

---

## Troubleshooting

| Problema | Causa probable | Solución |
|----------|---------------|----------|
| Bot no responde | Workflow 1 no está activo | Activa el workflow en n8n |
| OpenAI error 400 | Imagen no enviada como base64 | Verifica que Telegram Get File tiene Download activado |
| Code node: "JSON parse error" | OpenAI envolvió JSON en backticks | El código ya lo maneja; si persiste, refuerza el prompt |
| Botón no hace nada | Workflow 2 no activo o trigger escucha `message` en vez de `callback_query` | Verifica que Workflow 2 está activo y trigger dice `callback_query` |
| Supabase no devuelve ID | Tabla no existe o credenciales incorrectas | Ejecuta el SQL de setup y verifica credenciales |
| Navegador muestra código HTML | Falta header Content-Type: text/html | Agrégalo en el nodo Responder al Navegador |
| Webhook responde {} vacío | Webhook no está en modo "Using Respond to Webhook Node" | Cambia la opción Respond en el nodo Webhook |
| Reporte sale vacío | No hay datos en la tabla Gastos | Ejecuta `setup-gastos.sql` para insertar datos de prueba |
| URL del Webhook cambió | n8n genera nueva URL al reactivar | Copia la URL actualizada del nodo Webhook |

---

## Checklist Final

- [ ] Tabla "Gastos" creada en Supabase con datos de prueba
- [ ] Credenciales configuradas: Telegram, Postgres, OpenAI
- [ ] Variable TELEGRAM_MANAGER_CHAT_ID configurada (o hardcodeada)
- [ ] **Workflow 1**: Texto sin foto → responde con instrucciones
- [ ] **Workflow 1**: Foto borrosa → pide mejor imagen
- [ ] **Workflow 1**: Foto clara → Supabase registra gasto Pendiente
- [ ] **Workflow 1**: Gerente recibe mensaje con botones
- [ ] **Workflow 2**: Aprobar → Supabase cambia a Aprobado + confirmación
- [ ] **Workflow 2**: Rechazar → Supabase cambia a Rechazado + confirmación
- [ ] **Workflow 3**: Abrir enlace → navegador muestra reporte HTML
- [ ] Pipeline punta a punta funciona sin intervención manual

# Cerebro Experto: Finanzas y Análisis Financiero
> Diplomado IA & Automatización — Sprint 6
> Vertical: Finanzas / Contabilidad / Análisis

---

## ¿Qué es el área de Finanzas?

Finanzas es el área responsable de gestionar el dinero de la empresa: de dónde viene (ingresos), a dónde va (egresos), cuánto queda (utilidad), cómo se invierte y cómo se planea el futuro económico.

Mientras contabilidad registra lo que ya pasó (hechos históricos), finanzas analiza esos datos para tomar decisiones sobre el futuro. En la práctica, en empresas pequeñas ambas funciones las realiza la misma persona o el mismo departamento.

En México, muchas PyMEs llevan sus finanzas de forma reactiva — saben cómo les fue hasta que el contador cierra el mes, semanas después. La automatización permite pasar a un modelo **proactivo**: saber cómo estás financieramente en tiempo real.

---

## ¿Qué hace esta área en una empresa?

### Contabilidad y registro
- Registrar todas las transacciones financieras (ingresos y egresos)
- Clasificar cada transacción por categoría (nómina, renta, servicios, etc.)
- Mantener los libros contables actualizados
- Preparar los estados financieros básicos (Balance, Estado de Resultados)

### Tesorería y flujo de caja
- Controlar el saldo disponible en cuentas bancarias
- Proyectar el flujo de efectivo (cuánto entra y cuánto sale) para las próximas semanas o meses
- Gestionar pagos a proveedores y fechas de vencimiento
- Asegurar que siempre haya liquidez para las operaciones

### Análisis financiero
- Calcular indicadores de rentabilidad (margen de utilidad, ROI)
- Comparar resultados vs. períodos anteriores
- Identificar áreas o productos más y menos rentables
- Generar insights accionables para la dirección

### Obligaciones fiscales
- Calcular y pagar impuestos (ISR, IVA en México)
- Preparar declaraciones mensuales y anuales
- Gestionar la relación con el SAT
- Mantener respaldo de comprobantes fiscales

---

## Procesos repetitivos típicos (candidatos a automatizar)

### 1. Clasificación de transacciones bancarias
El estado de cuenta bancario llega con cientos de movimientos descritos en lenguaje críptico ("TRNS SPEI 2306 CORP XYZ"). Clasificar cada uno por categoría (nómina, renta, servicios, marketing, etc.) es trabajo manual tedioso.

**Automatizable:** Cargar el archivo del banco (CSV o PDF), procesar cada transacción con IA, clasificarla en la categoría correcta basándose en el concepto, el monto y el historial de transacciones similares.

### 2. Generación del resumen financiero diario
Cada mañana, el director financiero o el dueño debería saber: ¿cuánto hay en las cuentas? ¿Qué pagos vencen hoy? ¿Cómo vamos vs. el mes pasado?

**Automatizable:** Un bot de Telegram responde con un audio (Text-to-Speech) cuando le preguntas por el resumen del día — como tener un asesor financiero personal que te explica el estado de las finanzas en 60 segundos.

### 3. Conciliación de cuentas por cobrar
Identificar qué facturas ya fueron pagadas por los clientes y cuáles siguen pendientes es un proceso manual de cruce entre el estado de cuenta y el registro de facturas.

**Automatizable:** El sistema descarga los movimientos bancarios, los cruza con la base de datos de facturas emitidas y actualiza automáticamente el estado de cada una (pagada / pendiente / vencida).

### 4. Alertas de flujo de caja crítico
Cuando el saldo está por debajo de un umbral mínimo operativo, o cuando hay una semana con muchos pagos fijos (nómina, renta, proveedores), el director debería saberlo con anticipación.

**Automatizable:** Un análisis diario proyecta los próximos 7-30 días de flujo de caja. Si detecta una fecha crítica (saldo proyectado negativo o muy bajo), envía una alerta al responsable.

### 5. Reportes comparativos mensuales
Al cierre de mes, comparar los resultados vs. el mes anterior y vs. el mismo mes del año pasado para identificar tendencias.

**Automatizable:** Al primer día de cada mes, el sistema genera automáticamente el reporte comparativo con los datos del mes cerrado, incluyendo análisis de variaciones relevantes.

---

## ¿Qué datos maneja esta área?

### Datos de entrada (inputs)
- Estados de cuenta bancarios (CSV, PDF, Excel)
- Facturas emitidas y recibidas (CFDI / XML)
- Tickets y comprobantes de gastos
- Contratos con condiciones de pago
- Presupuestos aprobados

### Datos de salida (outputs)
- Estado de resultados (ingresos - egresos = utilidad)
- Balance general (activos, pasivos, capital)
- Reporte de flujo de caja
- Análisis de rentabilidad por producto/servicio/área
- Declaraciones fiscales

### Sistemas donde vive esta información
- **Archivos del banco**: Exportaciones en CSV o XLSX con movimientos
- **SAT (sat.gob.mx)**: Portal de facturas electrónicas en México
- **CONTPAQi / Aspel NOI / Contpaqi**: Software contable popular en México
- **Quickbooks / Xero**: Software contable internacional
- **Google Sheets**: Para análisis y reportes personalizados
- **Supabase / Airtable**: Bases de datos de transacciones y facturas

---

## Los estados financieros básicos que todo empresario debe entender

### Estado de Resultados (P&L)
Muestra si la empresa ganó o perdió dinero en un período:
```
Ingresos (ventas)          $500,000
- Costo de ventas          $200,000
= Utilidad bruta           $300,000
- Gastos operativos        $150,000
= Utilidad operativa       $150,000
- Impuestos (~30%)          $45,000
= Utilidad neta            $105,000
```

### Flujo de Caja
Muestra el movimiento real de efectivo:
```
Saldo inicial              $80,000
+ Cobros del mes          $420,000
- Pagos del mes           $380,000
= Saldo final             $120,000
```
**Diferencia clave**: Una empresa puede tener utilidad en el Estado de Resultados pero quedarse sin efectivo si sus clientes no pagan a tiempo.

### Balance General
Fotografía de lo que tiene y lo que debe la empresa:
```
ACTIVOS (lo que tenemos)   = PASIVOS (lo que debemos) + CAPITAL (lo que es nuestro)
$500,000                   = $200,000 + $300,000
```

---

## Conexión con otras áreas de la organización

- **Con Operaciones**: Recibe los comprobantes de gastos operativos
- **Con Ventas**: Registra las facturas emitidas y hace seguimiento a cobros
- **Con RRHH**: Procesa la nómina y las obligaciones patronales
- **Con Dirección**: Reporta el estado financiero y da insumos para decisiones estratégicas
- **Con Contabilidad externa**: Colabora con el contador o despacho contable para las declaraciones fiscales

---

## Text-to-Speech en Finanzas — El Asesor Financiero de Voz

Una aplicación especialmente poderosa para el área financiera es combinar el análisis de datos con síntesis de voz. El concepto:

1. El dueño pregunta por Telegram: "¿Cómo van las finanzas de esta semana?"
2. El sistema consulta la base de datos de transacciones
3. GPT genera un resumen narrativo en lenguaje natural: "Esta semana tuviste ingresos por $85,000 y gastos de $62,000. Tu utilidad neta fue de $23,000, un 15% más que la semana pasada. Los gastos más altos fueron en nómina ($35,000) y marketing ($12,000). Tienes 3 facturas por cobrar que vencen esta semana..."
4. El texto se convierte a audio (TTS)
5. El dueño recibe un mensaje de voz de 60 segundos con todo el contexto financiero

Esto es especialmente útil para dueños que están en movimiento y no pueden revisar dashboards en pantalla.

---

## Casos reales de automatización en este contexto

### Caso 1: Clasificador automático de estado de cuenta bancario
**Situación:** Una empresa de consultoría tenía 300-400 movimientos bancarios al mes. El contador tardaba 6 horas en clasificarlos manualmente para el cierre contable.

**Solución automatizada:**
1. El contador sube el CSV del banco a un formulario web
2. Un flujo en n8n lee cada fila del archivo
3. GPT analiza cada transacción: concepto, monto, contraparte
4. Clasifica en categorías: Nómina / Renta / Marketing / Servicios / Impuestos / Ingresos / Otros
5. Genera un nuevo Excel con la columna "Categoría" llena
6. Si la confianza es baja en alguna transacción, la marca para revisión manual

**Resultado:** El proceso bajó de 6 horas a 30 minutos (solo revisando las marcadas).

### Caso 2: Bot financiero de voz en Telegram
**Situación:** Un empresario con 3 negocios necesitaba revisar el estado financiero de cada uno constantemente, pero no tenía tiempo de abrir hojas de cálculo.

**Solución automatizada:**
1. Mensaje al bot: "Resumen de [nombre del negocio] de esta semana"
2. El flujo consulta la base de datos del negocio con el filtro de fechas
3. GPT genera un resumen narrativo con los puntos clave
4. El resumen se convierte a audio con OpenAI TTS o ElevenLabs
5. El empresario recibe un audio de 45-90 segundos

**Resultado:** 5 minutos de "revisión financiera" cada mañana mientras maneja.

### Caso 3: Alerta automática de facturas vencidas
**Situación:** Una agencia de publicidad tenía clientes que se tardaban en pagar. El equipo administrativo se enteraba del retraso hasta que revisaba el sistema manualmente.

**Solución automatizada:**
1. Cada día a las 8 AM, un flujo revisa todas las facturas pendientes
2. Identifica las que vencen hoy y las que ya están vencidas
3. Para las que vencen hoy: envía un recordatorio amable al cliente por correo
4. Para las vencidas más de 7 días: notifica al responsable de cobranza por Telegram
5. Para las vencidas más de 30 días: genera un reporte especial para dirección

**Resultado:** Días de cobranza promedio (DSO) redujo de 45 a 28 días.

---

## Obligaciones fiscales en México — Contexto básico

| Obligación | Frecuencia | Qué es |
|---|---|---|
| Declaración de IVA | Mensual | Impuesto al valor agregado (16% en ventas) |
| Declaración de ISR provisional | Mensual | Impuesto sobre la renta mensual |
| Declaración anual | Anual (abril) | Declaración definitiva del ISR del año |
| IMSS / INFONAVIT | Bimestral | Cuotas de seguridad social de empleados |
| Declaración informativa | Anual | Reporte de operaciones con terceros |

Las automatizaciones en finanzas deben respetar estos ciclos y generar la información en los formatos que requiere el SAT o el contador.

---

## Métricas clave de esta área

- **Margen de utilidad neta**: Utilidad neta / Ingresos × 100 (cuánto queda de cada peso que entra)
- **Días de cuentas por cobrar (DSO)**: Tiempo promedio que tardan los clientes en pagar
- **Índice de liquidez**: Activos circulantes / Pasivos circulantes (capacidad de pagar deudas a corto plazo)
- **Burn rate**: Cuánto efectivo gasta la empresa por mes (importante para startups)
- **Runway**: Con el efectivo actual, cuántos meses puede operar la empresa sin nuevos ingresos

---

## Vocabulario clave del área

| Término | Significado |
|---|---|
| Liquidez | Capacidad de convertir activos en efectivo rápidamente |
| Solvencia | Capacidad de pagar todas las deudas con los activos disponibles |
| Activo | Lo que posee la empresa (dinero, equipos, inventario, derechos) |
| Pasivo | Lo que debe la empresa (préstamos, cuentas por pagar) |
| Capital / Patrimonio | La diferencia entre activos y pasivos — lo que "vale" la empresa |
| Depreciación | Reducción del valor de un activo a lo largo del tiempo |
| Flujo de caja | Movimiento real de entrada y salida de efectivo |
| Conciliar | Verificar que dos registros financieros coincidan |
| CFDI | Comprobante Fiscal Digital por Internet (factura electrónica mexicana) |
| SAT | Servicio de Administración Tributaria — autoridad fiscal en México |
| ISR | Impuesto Sobre la Renta |
| IVA | Impuesto al Valor Agregado (16% en México) |

---

## Prompts sugeridos para estudiar con este cerebro

- "¿Cuál es la diferencia entre utilidad y flujo de caja, y por qué una empresa puede tener utilidad pero quedarse sin dinero?"
- "¿Cómo debería estructurar un sistema que clasifique automáticamente las transacciones de un estado de cuenta bancario?"
- "¿Qué información mínima debería incluir un resumen financiero diario para un dueño de PyME?"
- "¿Cómo funciona el IVA en México y qué datos necesita un sistema automático para calcularlo correctamente?"
- "Dame 5 alertas financieras automáticas que serían valiosas para un empresario mexicano"

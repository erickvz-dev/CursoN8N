# Cerebro Experto: Operaciones y Control de Gastos
> Diplomado IA & Automatización — Sprint 5
> Vertical: Operaciones / Administración / Control Interno

---

## ¿Qué es el área de Operaciones?

Operaciones es el área responsable de que la empresa funcione día a día. Mientras que dirección decide hacia dónde va la empresa y ventas trae los ingresos, operaciones se asegura de que todo lo que se prometió se entregue: los productos se fabriquen, los servicios se presten, los recursos se usen eficientemente.

En una empresa de servicios o tecnología, operaciones gestiona los procesos internos, los proveedores, los recursos y — crucialmente — el control de lo que se gasta para producir esos resultados.

---

## ¿Qué hace esta área en una empresa?

### Gestión de procesos internos
- Diseñar y documentar los procesos de la empresa
- Identificar cuellos de botella y oportunidades de mejora
- Supervisar que los procesos se ejecuten correctamente
- Medir la eficiencia operativa

### Control de gastos y presupuesto
- Gestionar el presupuesto operativo
- Aprobar o rechazar gastos según políticas internas
- Controlar que los gastos estén dentro del presupuesto autorizado
- Reconciliar los gastos reales vs. los planificados

### Gestión de proveedores
- Evaluar y seleccionar proveedores
- Negociar contratos y condiciones de compra
- Gestionar el pago a proveedores
- Monitorear el desempeño de proveedores

### Reportes operativos
- Generar reportes de desempeño para dirección
- Monitorear KPIs operativos en tiempo real
- Identificar desviaciones del plan y proponer correcciones
- Comunicar el estado operativo a los stakeholders

---

## Procesos repetitivos típicos (candidatos a automatizar)

### 1. Aprobación de gastos de empleados
Los empleados tienen gastos en campo: transporte, comidas con clientes, materiales, servicios. El proceso manual: el empleado guarda el recibo, lo lleva a la oficina, llena un formulario, lo entrega a su jefe, el jefe lo revisa y aprueba (o no), se procesa el reembolso. Días de proceso.

**Automatizable:** El empleado fotografía el recibo y lo envía por Telegram. La IA extrae el monto y la descripción. El gerente recibe un mensaje con botones "Aprobar / Rechazar". La decisión se registra automáticamente y se notifica al empleado.

### 2. Reporte de gastos consolidado
Cada fin de mes, alguien tiene que recopilar todos los comprobantes, ingresarlos a una hoja de cálculo, categorizar por área y generar el reporte para contabilidad.

**Automatizable:** Todos los gastos aprobados durante el mes se registran automáticamente en la base de datos. Al cierre del mes, un reporte se genera automáticamente con totales por categoría, área y período.

### 3. Consulta de estado financiero bajo demanda
El director quiere saber en este momento: ¿cuánto hemos gastado en transporte este mes? ¿Estamos dentro del presupuesto? Actualmente implica abrir el sistema contable, filtrar, exportar y calcular.

**Automatizable:** Un endpoint web (Webhook) recibe la consulta, consulta la base de datos con los filtros deseados y devuelve un reporte HTML en tiempo real directamente en el navegador — sin abrir ningún sistema contable.

### 4. Alertas de presupuesto
Cuando un área está a punto de agotar su presupuesto mensual, nadie lo sabe hasta que ya lo sobrepasó.

**Automatizable:** Un flujo programado revisa diariamente el gasto acumulado por área vs. el presupuesto asignado. Si alguna área supera el 80% del presupuesto, envía una alerta automática al responsable del área y al gerente de operaciones.

### 5. Conciliación de gastos con tarjeta corporativa
Los gastos realizados con tarjeta corporativa llegan en el estado de cuenta bancario. Cruzarlos con los recibos correspondientes es un trabajo tedioso.

**Automatizable:** El sistema compara los movimientos del banco con los recibos registrados, identifica matches automáticamente y señala los gastos sin comprobante para revisión.

---

## ¿Qué datos maneja esta área?

### Datos de entrada (inputs)
- Recibos y facturas (PDF, imágenes, XMLs del SAT)
- Solicitudes de compra o gasto
- Estados de cuenta bancarios
- Presupuestos aprobados por área
- Políticas de gastos de la empresa

### Datos de salida (outputs)
- Gastos aprobados o rechazados con justificación
- Reportes de gasto por período, área o categoría
- Alertas de desviación presupuestal
- Conciliaciones bancarias
- Dashboards de KPIs operativos

### Sistemas donde vive esta información
- **Supabase / PostgreSQL**: Base de datos de gastos y transacciones
- **Telegram**: Canal de comunicación para aprobaciones rápidas
- **SAT / Facturación electrónica**: Comprobantes fiscales en México
- **Quickbooks / CONTPAQi / Aspel**: Software contable en México
- **Google Sheets**: Presupuestos y seguimiento manual
- **Slack / Teams**: Comunicación interna del equipo

---

## Conexión con otras áreas de la organización

- **Con Finanzas/Contabilidad**: Le entrega los comprobantes de gastos categorizados para cierre contable
- **Con todas las áreas**: Cada área genera gastos que operaciones debe controlar
- **Con Dirección**: Reporta el estado de gastos vs. presupuesto
- **Con Proveedores**: Gestiona pagos y contratos
- **Con RRHH**: Coordina reembolsos y viáticos de empleados

---

## El flujo de aprobación de gastos — Anatomía del proceso

Entender este flujo es fundamental para automatizarlo correctamente:

```
EMPLEADO
  ↓ "Tuve un gasto de $350 en taxi para visita a cliente"
SISTEMA
  ↓ Recibe el recibo (imagen/PDF)
  ↓ IA extrae: monto, descripción, fecha, proveedor
  ↓ Verifica: ¿Está dentro de la política de gastos?
GERENTE
  ↓ Recibe: "Luis tuvo un gasto de $350 en transporte. ¿Apruebas?"
  ↓ Presiona: [✅ Aprobar] o [❌ Rechazar]
SISTEMA
  ↓ Registra decisión con timestamp
  ↓ Notifica al empleado el resultado
  ↓ Si aprobado: suma al reporte de gastos del área
```

Los puntos críticos de automatización son: la extracción de datos del recibo (IA), la notificación con botones interactivos (Telegram callback), y el registro automático (base de datos).

---

## El reporte bajo demanda — Nuevo modelo de reportería

El modelo tradicional de reportes tiene un problema: el reporte es estático (se genera una vez) y se vuelve obsoleto inmediatamente. Si el director quiere saber el gasto de hoy, tiene que esperar al próximo reporte.

El modelo de **reporte bajo demanda** funciona diferente:
- No hay un reporte programado
- En cualquier momento, el director accede a una URL
- El sistema consulta la base de datos en tiempo real
- Genera y muestra el reporte con datos al segundo

Esto es posible gracias a webhooks que devuelven HTML directamente al navegador — sin aplicaciones adicionales, sin logins, solo una URL.

---

## Casos reales de automatización en este contexto

### Caso 1: Sistema de aprobación de gastos por Telegram
**Situación:** Una empresa constructora tenía 12 empleados en campo que generaban gastos diarios (combustible, materiales, comidas). El proceso de reembolso tardaba 2-3 semanas porque los comprobantes llegaban en papel al final del mes.

**Solución automatizada:**
1. El empleado fotografía el recibo y lo manda al bot de Telegram con una descripción
2. La IA extrae: monto, tipo de gasto, proveedor
3. El supervisor recibe un mensaje: "Juan Pérez reporta gasto de $450 en gasolina en Pemex Aeropuerto el 15/06. ¿Apruebas?" + botones
4. El supervisor aprueba con un tap desde su celular
5. El gasto queda registrado en Supabase con: empleado, monto, categoría, aprobador, timestamp

**Resultado:** De 3 semanas a 24 horas en el ciclo de aprobación. El cierre mensual bajó de 2 días a 2 horas.

### Caso 2: Dashboard financiero en tiempo real
**Situación:** El director financiero de una empresa de servicios de TI necesitaba revisar el gasto operativo cada semana para tomar decisiones de contratación. El proceso requería que alguien del equipo preparara el reporte.

**Solución automatizada:**
1. Se crea un Webhook en n8n con una URL segura
2. Al acceder a la URL (con parámetros opcionales de fecha o área), el webhook se activa
3. El flujo consulta Supabase con los filtros recibidos
4. Genera un HTML con: tabla de gastos por categoría, gráfica de barras por área, total del período y % de presupuesto utilizado
5. Devuelve el HTML directamente al navegador como respuesta del webhook

**Resultado:** El director accede al reporte en 3 segundos desde cualquier dispositivo, sin depender de nadie.

---

## Comprobantes fiscales en México — CFDI

En México, los comprobantes de gasto formales son los **CFDI (Comprobantes Fiscales Digitales por Internet)** — las facturas electrónicas. Para gastos deducibles de impuestos, el recibo debe ser un CFDI válido.

Una automatización sofisticada puede:
1. Recibir el XML del CFDI (que el proveedor emite)
2. Validar su autenticidad en el SAT
3. Extraer los datos automáticamente (no necesita IA — el XML ya tiene estructura)
4. Categorizar el gasto según el concepto del CFDI
5. Registrarlo listo para el cierre contable

Esto elimina la captura manual de facturas — uno de los trabajos más tediosos en administración.

---

## Métricas clave de esta área

- **Tiempo del ciclo de aprobación**: Desde que se genera el gasto hasta que se aprueba
- **Gasto vs. presupuesto por área**: % de utilización del presupuesto en tiempo real
- **Gastos sin comprobante**: Número de transacciones sin respaldo fiscal
- **Tiempo de cierre mensual**: Horas que tarda el equipo en cerrar el mes contable
- **Gasto promedio por empleado**: Benchmark de eficiencia operativa

---

## Vocabulario clave del área

| Término | Significado |
|---|---|
| Reembolso | Devolución al empleado de gastos que realizó con dinero propio |
| Viáticos | Presupuesto asignado a un empleado para gastos de viaje o representación |
| Conciliación | Proceso de verificar que dos registros coincidan (ej. banco vs. sistema interno) |
| Presupuesto | Plan de gastos aprobado para un período determinado |
| Desviación | Diferencia entre lo presupuestado y lo gastado realmente |
| CFDI | Comprobante Fiscal Digital por Internet — factura electrónica en México |
| Webhook | URL que activa un proceso automático cuando recibe una solicitud |
| Callback | En Telegram, la acción que ocurre cuando el usuario presiona un botón interactivo |
| Supabase | Base de datos PostgreSQL en la nube con API REST automática |

---

## Prompts sugeridos para estudiar con este cerebro

- "¿Cuáles son los puntos de dolor más comunes en el control de gastos de una PyME mexicana?"
- "¿Cómo funciona el sistema de aprobaciones con botones interactivos en Telegram?"
- "¿Qué diferencia hay entre un reporte programado y un reporte bajo demanda mediante webhook?"
- "¿Qué datos mínimos necesita registrar un sistema de control de gastos para ser útil contablemente?"
- "¿Cómo debería diseñar la estructura de una base de datos para registrar gastos empresariales?"

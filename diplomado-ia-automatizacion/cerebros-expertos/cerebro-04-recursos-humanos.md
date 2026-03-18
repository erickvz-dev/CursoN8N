# Cerebro Experto: Recursos Humanos y Gestión del Talento
> Diplomado IA & Automatización — Sprint 4
> Vertical: Recursos Humanos / Reclutamiento / Evaluación

---

## ¿Qué es el área de Recursos Humanos?

Recursos Humanos (RRHH) es el área responsable de gestionar el activo más importante de cualquier organización: las personas. Su trabajo abarca desde encontrar y contratar talento, hasta desarrollarlo, retenerlo y — cuando es necesario — gestionarlo hacia la salida.

En México, las PyMEs frecuentemente no tienen un área de RRHH formal. El reclutamiento y la gestión del personal la hace directamente el dueño, el gerente o alguien del equipo administrativo de forma improvisada. Esto genera ineficiencias costosas: contrataciones equivocadas, procesos lentos, candidatos que se pierden por falta de seguimiento.

---

## ¿Qué hace esta área en una empresa?

### Reclutamiento y selección
- Publicar vacantes en bolsas de trabajo (LinkedIn, OCCMundial, Indeed)
- Recibir y filtrar currículums
- Coordinar entrevistas telefónicas, presenciales y técnicas
- Evaluar candidatos y tomar decisiones de contratación
- Comunicar resultados (aceptación o rechazo) a los candidatos

### Onboarding (incorporación)
- Preparar el espacio y herramientas del nuevo empleado
- Gestionar la documentación de ingreso (contrato, alta en nómina, IMSS)
- Hacer la inducción a la empresa: cultura, procesos, equipo
- Asignar el plan de capacitación inicial

### Gestión del desempeño
- Establecer objetivos y métricas de desempeño
- Hacer evaluaciones periódicas (trimestrales, semestrales, anuales)
- Gestionar conversaciones de retroalimentación
- Identificar empleados de alto potencial y planes de desarrollo

### Administración de personal
- Controlar asistencia, vacaciones y permisos
- Gestionar nómina y compensaciones
- Actualizar expedientes de empleados
- Garantizar el cumplimiento de obligaciones laborales (Ley Federal del Trabajo)

### Cultura organizacional
- Diseñar programas de reconocimiento
- Organizar eventos de integración
- Gestionar el clima laboral
- Comunicar internamente los valores y objetivos de la empresa

---

## Procesos repetitivos típicos (candidatos a automatizar)

### 1. Filtrado inicial de currículums
En una vacante popular, pueden llegar 200-500 CVs en la primera semana. Revisar cada uno manualmente para decidir si cumple el perfil básico toma horas de trabajo.

**Automatizable:** El sistema recibe el CV (PDF), extrae el texto con IA, evalúa contra los criterios del puesto y asigna un puntaje de compatibilidad. Solo los candidatos que superan el umbral llegan a revisión humana.

### 2. Coordinación de entrevistas
Una vez que se seleccionan candidatos, coordinar las entrevistas implica múltiples intercambios de mensajes para encontrar un horario que funcione para todos.

**Automatizable:** El sistema envía al candidato aceptado un formulario con los horarios disponibles. El candidato elige, el sistema crea el evento en el calendario y envía las confirmaciones automáticamente.

### 3. Comunicaciones masivas a candidatos
En procesos con muchos candidatos, es común que los rechazados nunca reciban respuesta. Esto daña la reputación de la empresa y cierra la puerta a futuros candidatos.

**Automatizable:** Cuando un candidato es rechazado en cualquier etapa, el sistema envía automáticamente un correo personalizado de agradecimiento y rechazo respetuoso.

### 4. Evaluación post-entrevista
Después de entrevistar candidatos, el entrevistador necesita registrar su evaluación antes de que se olviden los detalles. Frecuentemente esto no se hace o se hace inconsistentemente.

**Automatizable:** Inmediatamente después de una entrevista, el sistema envía al entrevistador un formulario de evaluación. Las respuestas se procesan con IA para generar una calificación estructurada y una recomendación.

### 5. Reportes de status del proceso de reclutamiento
El director o dueño quiere saber: ¿cuántos candidatos van en el proceso? ¿En qué etapa están? ¿Cuánto tiempo lleva la vacante abierta?

**Automatizable:** Un reporte automático semanal consolida el estado de todos los procesos activos de reclutamiento y lo envía al responsable.

---

## ¿Qué datos maneja esta área?

### Datos de entrada (inputs)
- CVs y currículums de candidatos (PDF, Word)
- Descripción del puesto y perfil requerido
- Formularios de solicitud de empleo
- Evaluaciones de entrevistadores
- Documentos de empleados (IDs, contratos, certificados)

### Datos de salida (outputs)
- Evaluaciones y puntajes de candidatos
- Correos de aceptación o rechazo
- Reportes de status del proceso de reclutamiento
- Expedientes de empleados actualizados
- Reportes de nómina y asistencia

### Sistemas donde vive esta información
- **LinkedIn / OCCMundial / Indeed**: Bolsas de trabajo
- **Airtable / Notion**: Bases de datos de candidatos y empleados
- **Gmail / Outlook**: Comunicación con candidatos
- **Google Forms / Typeform**: Formularios de solicitud y evaluación
- **Google Calendar**: Coordinación de entrevistas
- **BambooHR / Factorial**: Software especializado de RRHH (en empresas más grandes)

---

## Conexión con otras áreas de la organización

- **Con Dirección**: Necesita aprobación para abrir vacantes y presupuesto para nómina
- **Con Finanzas**: Coordina el procesamiento de nómina y compensaciones
- **Con Operaciones**: Recibe el perfil del candidato ideal definido por el área solicitante
- **Con Legal**: Valida contratos laborales y cumplimiento regulatorio
- **Con todas las áreas**: Cada área es "cliente interno" de RRHH cuando necesita contratar

---

## El ciclo de vida de un candidato

Para automatizar reclutamiento, es fundamental entender las etapas y transiciones:

```
APLICACIÓN → FILTRO INICIAL → ENTREVISTA TELEFÓNICA → 
ENTREVISTA TÉCNICA → ENTREVISTA CULTURAL → OFERTA → 
CONTRATACIÓN → ONBOARDING
```

En cada transición hay una comunicación al candidato (avanza o no avanza) y un registro interno del resultado. Estas comunicaciones y registros son exactamente lo que se puede automatizar.

---

## Casos reales de automatización en este contexto

### Caso 1: Sistema de reclutamiento con evaluación automática de CVs
**Situación:** Una empresa de 50 empleados necesitaba contratar 5 personas en 2 meses. La dueña dedicaba 3 horas diarias solo a revisar CVs recibidos por correo.

**Solución automatizada:**
1. Los candidatos llenan un formulario (Typeform) que incluye datos básicos y sube su CV en PDF
2. Al enviar el formulario, n8n extrae el texto del PDF
3. GPT evalúa el CV contra el perfil del puesto y asigna un puntaje del 1 al 10 con justificación
4. Si el puntaje es 7 o más: el candidato recibe un correo citándolo a entrevista
5. Si el puntaje es menor: recibe un correo de agradecimiento respetuoso
6. Todos los candidatos se registran en Airtable con su puntaje y estado

**Resultado:** La dueña solo atiende a los candidatos que ya pasaron el filtro automático — máximo 15-20% del total recibido.

### Caso 2: Sistema de feedback post-entrevista con decisión IA
**Situación:** Un gerente entrevistaba candidatos pero sus notas eran inconsistentes. A veces contrataba por "feeling" y luego tenía problemas.

**Solución automatizada:**
1. Después de cada entrevista, el sistema envía al gerente un formulario de 5 preguntas estructuradas por Telegram
2. El gerente responde con sus observaciones en texto libre
3. GPT analiza el feedback y genera una evaluación estructurada
4. Si múltiples entrevistadores participaron, consolida todas las evaluaciones
5. El sistema presenta una recomendación final: Contratar / Rechazar / Segunda entrevista
6. La decisión y el razonamiento se guardan en el expediente del candidato

**Resultado:** Proceso de decisión más consistente y documentado. Tiempo de decisión reducido de días a horas.

### Caso 3: Onboarding automatizado para empleados nuevos
**Situación:** Cada vez que entraba un empleado nuevo, alguien tenía que recordar mandarle los accesos, presentárselo al equipo y asegurarse de que firmara los documentos — y siempre se olvidaba algo.

**Solución automatizada:**
1. Al registrar al nuevo empleado en el sistema, un flujo se activa
2. Día -1 (antes de entrar): recibe un email de bienvenida con qué traer el primer día
3. Día 0 (primer día): recibe las credenciales de acceso, el manual de bienvenida y el calendario de inducción
4. Semana 1: recibe recordatorios de los documentos que debe firmar
5. Mes 1: recibe automáticamente el formulario de evaluación de la experiencia de onboarding

---

## Marco legal básico en México (contexto para automatizaciones)

Al automatizar procesos de RRHH en México, considerar:

- **Ley Federal del Trabajo**: Regula contratos, jornadas, vacaciones, liquidaciones
- **IMSS**: Todo empleado formal debe registrarse en el Instituto Mexicano del Seguro Social
- **INFONAVIT**: Aportaciones obligatorias al fondo de vivienda
- **NOM-035**: Norma de factores de riesgo psicosocial en el trabajo — implica evaluaciones periódicas
- **Protección de datos (LFPDPPP)**: Los datos de candidatos y empleados son datos personales protegidos por ley

Los sistemas automatizados deben manejar esta información con seguridad y solo almacenar lo estrictamente necesario.

---

## Métricas clave de esta área

- **Tiempo de cobertura de vacante**: Días desde que se abre la vacante hasta que se contrata
- **Costo por contratación**: Inversión total (publicidad, tiempo, herramientas) / contrataciones
- **Tasa de rotación**: Empleados que salen en primeros 6 meses / total contratado × 100
- **Ratio de filtrado**: CVs recibidos / candidatos entrevistados (eficiencia del filtro)
- **NPS del candidato**: Qué tan probable es que el candidato (contratado o no) recomiende el proceso

---

## Vocabulario clave del área

| Término | Significado |
|---|---|
| Vacante | Puesto disponible en la empresa que se necesita cubrir |
| Perfil del puesto | Descripción de las características, habilidades y experiencia requerida |
| CV / Currículum | Documento que resume la experiencia y formación de un candidato |
| Headhunting | Búsqueda activa de candidatos específicos, sin esperar que apliquen |
| Onboarding | Proceso de incorporación y adaptación de un nuevo empleado |
| Rotación | Índice de empleados que dejan la empresa en un período determinado |
| Nómina | Lista de empleados y el pago que corresponde a cada uno |
| Expediente | Carpeta (física o digital) con todos los documentos de un empleado |
| Brecha de habilidades | Diferencia entre las habilidades que tiene un empleado y las que necesita |

---

## Prompts sugeridos para estudiar con este cerebro

- "¿Cuáles son las etapas de un proceso de reclutamiento y en cuáles se puede aplicar automatización?"
- "¿Cómo debería evaluar un sistema de IA a un candidato basándose en su CV?"
- "¿Qué información legal debo considerar al automatizar el manejo de datos de candidatos en México?"
- "Dame un ejemplo de los criterios de evaluación que usaría para un puesto de desarrollador junior"
- "¿Cuál es la diferencia entre filtrar CVs con automatización y usar un ATS tradicional?"

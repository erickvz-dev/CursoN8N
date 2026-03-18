# Sprint 4 — Recursos Humanos (El Reclutador IA)

## Objetivo
Automatizar el proceso de reclutamiento con dos workflows conectados:
1. **Screening automático** — un formulario recibe CVs en PDF, la IA los evalúa con puntaje (0-100), y el sistema decide si envía invitación a entrevista o correo de rechazo.
2. **Decisión final con intervención humana** — el entrevistador registra feedback y decisión; el sistema ejecuta la ruta de contratación u onboarding.

La meta: el pipeline corre de punta a punta y Airtable refleja el estado real del candidato.

## Entregables
- [x] Flujo A: Recepción de CV (formulario → PDF → n8n)
- [x] Flujo A: Extracción de texto del PDF (nodo Extract from File)
- [x] Flujo A: Evaluación con OpenAI gpt-4o-mini (puntaje 0-100)
- [x] Flujo A: Registro en Airtable (candidato + score + estado "Nuevo")
- [x] Flujo A: Decisión automática (Score >= 75 → invitación / < 75 → rechazo)
- [x] Flujo A: Google Calendar con attendee + Gmail (invitación) o Gmail (rechazo)
- [x] Flujo B: Formulario de feedback del entrevistador (email, feedback, decisión)
- [x] Flujo B: Búsqueda del candidato en Airtable por email
- [x] Flujo B: Actualización de estado a "Entrevistado"
- [x] Flujo B: Rama CONTRATAR → Gmail oferta + estado "Oferta Enviada"
- [x] Flujo B: Rama RECHAZAR → OpenAI redacta rechazo empático + Gmail + estado "Rechazado"

## Estructura de Airtable
**Base:** Sistema RH
**Tabla:** Candidatos

| Campo | Tipo | Descripción |
|---|---|---|
| Nombre | Single line text | Nombre completo del candidato |
| Email | Email | Correo electrónico |
| CV_Texto | Long text | Texto extraído del PDF |
| Score | Number | Puntaje IA (0-100) |
| Estado | Single select | Nuevo, Entrevista, Rechazado, Aceptado |

### Estados posibles del candidato
```
Nuevo → Entrevista → Aceptado
     ↘ Rechazado  ↘ Rechazado
```

## Archivos incluidos

### flujos/ (2 workflows)
- `Sprint4 - Analista de Candidatos.json` — Workflow 1: screening automático (formulario → Extract PDF → OpenAI → Airtable → IF Score >= 75 → Calendar/Gmail)
- `Sprint4 - Decisión y Onboarding.json` — Workflow 2: decisión final (formulario entrevistador → Airtable búsqueda → IF Decisión → Gmail oferta/rechazo)

## Configuración antes de importar
1. **Airtable**: La base "Sistema RH" ya tiene la tabla `Candidatos` con las 5 columnas
2. **Credenciales en n8n**: OpenAI, Airtable OAuth2, Gmail OAuth2 y Google Calendar OAuth2 ya están configuradas
3. **Importar**: Importa ambos workflows en n8n y actívalos

## Checklist de validación
- [ ] Airtable refleja el estado real del candidato
- [ ] No hay pasos manuales innecesarios
- [ ] Los emails suenan humanos y profesionales
- [ ] El flujo 2 normaliza correctamente la decisión final (no falla por mayúsculas ni espacios)
- [ ] Pipeline completo funciona de punta a punta

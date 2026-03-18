# Sprint 2 — Producción Visual Automatizada

## Objetivo
Automatizar la creación de contenido visual: generación de ideas con IA, diseño automático en Canva y videos con avatares en HeyGen. Dominio de peticiones asíncronas (Jobs).

## Entregables
- [ ] Flujo: Generación de ideas y prompts con OpenAI desde Google Sheets
- [ ] Flujo: Creación automática de diseño en Canva (Autofill)
- [ ] Flujo: Envío de Job a HeyGen y polling hasta completar
- [ ] Flujo: Descarga del video generado y notificación

## Herramientas
- Google Sheets (fuente de datos)
- OpenAI GPT (generación de ideas/prompts)
- Canva API (Autofill/diseño)
- HeyGen API (generación de video — Job asíncrono)

## Concepto clave: Jobs Asíncronos
HeyGen y Canva no responden inmediatamente. El flujo debe:
1. Enviar la petición → obtener un `job_id`
2. Esperar (Wait node) un tiempo estimado
3. Consultar el estado con el `job_id`
4. Si no está listo → volver a esperar (loop)
5. Si está listo → descargar y continuar

## Variables de entorno requeridas
```env
OPENAI_API_KEY=
CANVA_API_KEY=
HEYGEN_API_KEY=
GOOGLE_SHEETS_CREDENTIALS=
```

## Archivos incluidos

### flujos/ (4 workflows)
- `Planner de Contenido - Cafetería.json` — Planner con OpenAI + Google Sheets
- `cafeteria-nube-a-planner-ideas-prompts.json` — Generación de ideas y prompts con IA
- `cafeteria-nube-b-factory-imagen-ia-canva-export.json` — Pipeline: IA genera imagen + Canva diseño
- `WF_Fabrica_HeyGen_CafeteriaNube.json` — Fábrica de videos con HeyGen (polling asíncrono)

### Archivos de apoyo
- `Cafeteria_Nube_v2.xlsx` — Datos de ejemplo para el planner de contenido

> Los workflows usan credenciales placeholder (`TU_CREDENTIAL_ID`). Configura las tuyas en n8n antes de importar.

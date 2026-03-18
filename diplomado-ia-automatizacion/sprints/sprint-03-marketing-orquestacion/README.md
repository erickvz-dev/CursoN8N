# Sprint 3 — Marketing y Orquestación

## Objetivo
Construir una máquina de contenido completa. Un Agente Orquestador dirige subagentes especializados: generación de copy, diseño, publicación en Instagram, análisis de engagement y captura de leads.

## Entregables
- [ ] Flujo: Agente Orquestador (AI Agent con tools)
- [ ] Subagente: Generador de copy con tono de marca
- [ ] Subagente: Diseñador (Canva)
- [ ] Subagente: Publicador de Instagram (Graph API)
- [ ] Subagente: Analizador de métricas (engagement rate, alcance)
- [ ] Flujo: Captura de leads desde comentarios/DMs

## Concepto clave: Agente Orquestador
El orquestador NO ejecuta acciones directamente. Decide qué herramienta (subagente) llamar según el objetivo. Cada herramienta es un subworkflow en n8n.

```
Usuario → Orquestador → Tool: copy_generator → resultado
                      → Tool: canva_designer → resultado  
                      → Tool: instagram_publisher → resultado
```

## Variables de entorno requeridas
```env
OPENAI_API_KEY=
CANVA_API_KEY=
INSTAGRAM_ACCESS_TOKEN=
INSTAGRAM_BUSINESS_ACCOUNT_ID=
FACEBOOK_PAGE_ID=
```

## Archivos incluidos

### flujos/ (11 workflows)

**Fábrica unificada:**
- `Cafeteria_Nube_Fabrica_Unificada_v2.json` — Orquestador principal que coordina todos los subflujos

**Subflujos especializados (6):**
- `Subflujo_Generate_Content_Plan.json` — Genera plan de contenido con OpenAI
- `Subflow_Image_Pipeline_(Gemini_→_Canva).json` — Pipeline: Gemini genera imagen + Canva diseño
- `Subflujo_HeyGen_Generate_video.json` — Genera video con HeyGen (polling asíncrono)
- `Subflujo_Upload_to_Drive.json` — Sube archivos a Google Drive
- `Subflujo_Update_Sheet.json` — Actualiza Google Sheets con resultados
- `Subflujo_Publish_Instagram.json` — Publica en Instagram via Graph API

**Workflows auxiliares (3):**
- `Subflujo_File_Proxy.json` — Proxy de archivos para servir imágenes públicamente
- `Workflow_Instagram_Post_Manual.json` — Publicación manual en Instagram
- `Workflow_Instagram_Token_Helper.json` — Helper para obtener tokens de Instagram

**Análisis:**
- `Workflow_Instagram_Analytics.json` — Consulta métricas de engagement de Instagram

### assets/
- `landing-inadaptados.html` — Landing page del proyecto Cafetería Nube

> Los workflows usan credenciales placeholder (`TU_CREDENTIAL_ID`). Configura las tuyas en n8n antes de importar.

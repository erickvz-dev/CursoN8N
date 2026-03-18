# Diplomado IA & Automatización — Repositorio Oficial

Bienvenido al repositorio de código del diplomado. Aquí encuentras **todo lo que necesitas para construir cada entregable de sprint usando vibe coding con Antigravity**.

---

## ¿Qué hay en este repositorio?

| Carpeta/Archivo | Qué contiene |
|---|---|
| `AGENTS.md` | Las reglas que sigue el agente de IA. Léelo si quieres entender cómo piensa. |
| `.antigravity/skills/` | 14 skills precargados — le dicen al agente cómo trabajar con n8n, Canva, HeyGen, WhatsApp y Kommo |
| `cerebros-expertos/` | Documentos de dominio de negocio por sprint, para usar con NotebookLM |
| `sprints/sprint-XX-nombre/` | Material por sprint: flujos JSON, ejercicios y checklist |
| `shared/prompts/` | Prompts de sistema reutilizables (evaluador CV, extractor recibo) |
| `shared/examples/` | Ejemplos de nodos, patrones multi-nodo y code snippets para n8n |

> **Importante:** Los workflows incluidos usan credenciales placeholder (`TU_CREDENTIAL_ID`, `TU_API_KEY`, etc.). Antes de importarlos, configura tus propias credenciales en tu instancia n8n.

---

## Setup inicial (hazlo una sola vez)

### 1. Clona el repositorio

```bash
git clone https://github.com/institutoinadaptados/diplomado-ia-automatizacion.git
cd diplomado-ia-automatizacion
```

### 2. Abre la carpeta en Antigravity

Arrastra la carpeta `diplomado-ia-automatizacion` a Antigravity o ábrela con:

```
File → Open Folder → diplomado-ia-automatizacion
```

Antigravity detectará automáticamente la carpeta `.antigravity/skills/` y cargará los 14 skills.

### 3. Configura tus conexiones MCP

Edita tu archivo de configuración MCP en Antigravity (**Settings → MCP**) y agrega:

```json
{
  "mcpServers": {
    "n8n": {
      "command": "npx",
      "args": ["-y", "n8n-mcp"],
      "env": {
        "N8N_API_URL": "https://TU_INSTANCIA.n8n.cloud",
        "N8N_API_KEY": "TU_API_KEY_AQUI"
      }
    }
  }
}
```

> **¿Dónde consigo mi N8N_API_KEY?**
> En tu instancia n8n → Settings → API → Create API Key

### 4. Verifica que todo funciona

Escribe esto en Antigravity:

```
Lista todos mis flujos n8n actuales
```

Si ves la lista de tus flujos, el MCP está conectado correctamente.

---

## Cómo trabajar en cada sprint

### Prompt de inicio recomendado

Al empezar un sprint nuevo, usa este prompt:

```
Estoy en el Sprint [NÚMERO] — [NOMBRE DEL SPRINT].
Mi objetivo es [describe con tus palabras lo que quieres construir].
Tengo estas credenciales configuradas en n8n: [lista las que ya tienes].
Guíame paso a paso.
```

### Ejemplo real (Sprint 4):

```
Estoy en el Sprint 4 — Recursos Humanos.
Quiero construir el flujo que recibe un CV en PDF por formulario,
la IA lo evalúa y envía un correo de aceptación o rechazo.
Tengo OpenAI y Airtable configurados en n8n.
Guíame paso a paso.
```

---

## Sprints del Diplomado

| # | Sprint | Estado | Herramientas clave |
|---|---|---|---|
| 1 | Asistente Personal por Voz | ✅ Cerrado | Telegram, Whisper, Google Calendar |
| 2 | Producción Visual Automatizada | ✅ Cerrado | OpenAI, Canva, HeyGen |
| 3 | Marketing y Orquestación | ✅ Cerrado | AI Agent, Instagram Graph API |
| 4 | Recursos Humanos | ✅ Cerrado | PDF extractor, OpenAI, Airtable |
| 5 | Operaciones y Control de Gastos | ✅ Cerrado | Telegram, Supabase, Webhook |
| 6 | Finanzas | ✅ Cerrado | Clasificador CSV, TTS, Telegram |
| 7 | Ventas y Capstone | 🔄 En curso | Meta WhatsApp Cloud API, Kommo CRM, AI Agent |

---

## Reglas de oro del vibe coding

1. **No copies y pegues sin entender.** Pídele al agente que te explique antes de ejecutar.
2. **Un flujo a la vez.** Termina y valida antes de avanzar al siguiente.
3. **Si falla, comparte el error exacto.** "No funciona" no ayuda. El mensaje de error sí.
4. **Guarda tus API keys en n8n Credentials**, nunca dentro del JSON del flujo.
5. **Activa el flujo antes de probar webhooks.** Sin activar, el webhook no responde.

---

## ¿Algo no funciona?

1. Revisa `AGENTS.md` → sección **7. Diagnóstico de Errores Frecuentes**
2. Pregunta en el canal de Slack del diplomado `#soporte-tecnico`
3. Si el error es de n8n MCP, verifica que tu API key siga activa

---

> Instituto Inadaptados · Diplomado IA & Automatización

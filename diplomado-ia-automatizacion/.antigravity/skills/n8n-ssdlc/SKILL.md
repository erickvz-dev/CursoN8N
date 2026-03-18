---
name: n8n-ssdlc
description: Protocolo de desarrollo seguro para workflows n8n con agentes IA. Use when building, validating, or publishing workflows via MCP. Includes security checklist, MCP pipeline, AI agent threat model, credential management, and failure documentation standard.
---

# SSDLC para Workflows n8n con Agentes IA

Protocolo operativo para construir, validar y publicar workflows de n8n de forma segura. Adaptado de OWASP LLM Top 10 y NIST AI RMF al contexto específico de automatizaciones con IA.

---

## Principios de Seguridad para Agentes IA

Cinco principios obligatorios para todo workflow que incluya un LLM o agente:

| Principio | Qué significa | Ejemplo en el diplomado |
|-----------|---------------|------------------------|
| **Human in the Loop** | Toda acción irreversible requiere confirmación humana | Sprint 5: gerente aprueba gasto antes de registrarlo |
| **Least Capability** | El agente solo recibe las herramientas que necesita | Sprint 6: chain sin tools, solo resume datos ya consultados |
| **Prompt Injection Defense** | Datos externos nunca van directo al system prompt | Sanitizar input de Telegram antes de pasarlo al LLM |
| **Cost Awareness** | Límites de tokens, rate limits y alertas de costo definidos | Sprint 6: max 2500 chars para TTS (~$0.04/respuesta) |
| **Graceful Degradation** | Si algo falla, el workflow falla de forma controlada | Sprint 6: si TTS falla, enviar texto plano como fallback |

---

## Pipeline MCP — Flujo Estándar de Publicación

Todo workflow se construye localmente y se publica via MCP. El JSON local en git es el **source of truth**.

```
FASE 1 — CONSTRUIR
├── Generar JSON del workflow (local, en sprints/sprint-XX/flujos/)
├── Usar credential IDs del registry (shared/credenciales.md)
└── Verificar contra el checklist de seguridad (ver abajo)

FASE 2 — VALIDAR
├── validate_workflow → verificar estructura y conexiones
├── Si hay errores → corregir JSON local → re-validar
└── Máximo 3 ciclos de corrección

FASE 3 — PUBLICAR
├── create_workflow(json) → obtener workflow_id
├── O update_workflow(id, json) → si ya existe
└── Guardar workflow_id en el README del sprint

FASE 4 — ACTIVAR Y PROBAR
├── activate_workflow(id) → solo si tiene trigger activo
├── test_workflow(id) → ejecutar con datos controlados
├── get_executions(id) → verificar resultado
└── Si error → diagnosticar → patch local → update_workflow → repetir

FASE 5 — SINCRONIZAR
├── get_workflow(id) → exportar JSON validado desde n8n
├── Comparar con JSON local → merge si hay diferencias
└── Commit al repo (JSON local = source of truth)
```

### Herramientas MCP por fase

| Fase | Tool MCP | Cuándo |
|------|----------|--------|
| Validar | `validate_workflow` | Siempre, antes de publicar |
| Publicar | `create_workflow` | Workflow nuevo |
| Actualizar | `update_partial_workflow` | Workflow existente |
| Activar | `update_partial_workflow` + `activateWorkflow` | Después de publicar |
| Probar | `test_workflow` | Después de activar |
| Diagnosticar | `executions` | Si falla la prueba |
| Exportar | `get_workflow` | Para sincronizar con local |
| Rollback | `workflow_versions` | Si algo sale mal |

---

## Gestión de Credenciales

### Flujo para mapear credenciales al workflow

```
1. Consultar registry local: shared/credenciales.md
   → Contiene los IDs de credenciales por servicio y sprint

2. Si el ID existe en el registry → usarlo directamente en el JSON

3. Si NO existe → opción A o B:
   A. Crear credencial vacía via n8n API:
      POST /api/v1/credentials
      {
        "name": "NombreServicio_Entorno",
        "type": "tipoCredencial",
        "data": {}
      }
      → El usuario llena los valores secretos en la UI de n8n

   B. Usar placeholder en el JSON y documentar en el README:
      "credentials": { "telegramApi": { "id": "TU_CREDENTIAL_ID", "name": "Telegram" } }
      → El usuario reemplaza antes de importar
```

### Reglas de credenciales

- **Nunca** hardcodear API keys, tokens o passwords en nodos del workflow
- **Siempre** usar el sistema de credenciales de n8n (IDs, no valores)
- **Nunca** exponer tokens de bot o API keys en documentación versionada
- Credential IDs son específicos de cada instancia de n8n
- El registry (`shared/credenciales.md`) documenta los IDs del instructor, no del alumno

---

## Checklist de Seguridad Pre-Publicación

**Obligatorio antes de `create_workflow` o `update_workflow`:**

- [ ] **No hay secrets en el JSON** — sin API keys, tokens o passwords hardcodeados en nodos
- [ ] **Credenciales usan el sistema de n8n** — IDs del credential store, no valores inline
- [ ] **Error handling existe** — al menos un fallback o notificación de error
- [ ] **LLM tiene límites** — max tokens o max caracteres definidos en el prompt
- [ ] **Inputs sanitizados** — datos del usuario no van directo al system prompt sin contexto
- [ ] **Acciones irreversibles controladas** — confirmación humana antes de DELETE, envío de emails, pagos
- [ ] **Sin loops infinitos** — el workflow tiene condiciones de salida claras
- [ ] **Nomenclatura correcta** — nodos siguen convención `NN - Descripción`

---

## Modelado de Amenazas para Agentes IA

Evaluar **antes** de construir cualquier workflow con LLM o agente:

| Amenaza | Pregunta a responder | Control |
|---------|---------------------|---------|
| **Prompt Injection** | ¿El agente recibe inputs de fuentes no confiables (Telegram, webhook)? | Separar datos de instrucciones; etiquetar inputs como "datos del usuario" |
| **Credential Exposure** | ¿Pueden filtrarse credenciales en outputs o logs? | Usar sistema de credenciales de n8n; nunca pasar secrets como texto |
| **Acción Irreversible** | ¿El workflow puede eliminar datos, enviar emails o ejecutar pagos? | Nodo de confirmación humana antes de la acción |
| **Unbounded Execution** | ¿Puede el agente entrar en loop infinito o generar costos descontrolados? | Definir maxIterations, timeout, límite de caracteres |
| **Data Leakage** | ¿Pasan datos sensibles (PII, datos de negocio) por nodos que no deberían tenerlos? | Limpiar campos sensibles antes de logs/outputs |
| **Third-Party Trust** | ¿Qué pasa si una API externa devuelve datos maliciosos o inesperados? | Validar respuestas; no confiar en formato |
| **Scope Creep** | ¿Las herramientas del agente son las mínimas necesarias? | Listar explícitamente tools permitidas y justificarlas |
| **Rate Limit & Cost** | ¿Hay límites de llamadas a LLMs y APIs externas? | Definir presupuesto por ejecución; alertar si se supera |

---

## Documentación de Fallos — Plantilla para Cerebros

Cada `Cerebro_*.md` debe incluir esta sección al final:

```markdown
## Comportamiento en Fallos

| Si falla... | Entonces... | Notificar |
|-------------|-------------|-----------|
| API de OpenAI no responde | Enviar mensaje de disculpa al usuario via Telegram | Log en ejecución |
| Postgres timeout | Reintentar 1 vez; si falla, mensaje de error al usuario | Log en ejecución |
| TTS excede 4096 caracteres | Truncar texto y enviar como texto plano (fallback) | — |
| Telegram sendVoice falla | Enviar audio via sendAudio del nodo nativo (sin waveform) | — |
| Input del usuario vacío | Responder con mensaje predeterminado de ayuda | — |
```

**Regla:** Un workflow nunca debe quedar en estado silencioso. Si algo falla, el usuario recibe feedback.

---

## Señales de Alerta en Diseño de Agentes

Si ves alguna de estas señales, **detener y rediseñar:**

- El agente necesita acceso a "todas" las herramientas disponibles
- No hay límite de iteraciones ni timeout definido
- Los datos del usuario se interpolan directamente en el system prompt
- El workflow no tiene ningún nodo de manejo de errores
- No hay forma de pausar o detener el agente externamente
- El agente puede enviar emails, hacer pagos o borrar datos sin confirmación
- No hay estimación de costo por ejecución

---

## Cuándo aplicar cada nivel de seguridad

| Tipo de workflow | Nivel | Qué verificar |
|-----------------|-------|---------------|
| Solo lectura (consulta datos) | Básico | Checklist pre-publicación |
| Con LLM (genera texto) | Medio | + Límites de tokens/costo + sanitización de inputs |
| Con agente + tools | Alto | + Modelado de amenazas completo + human-in-loop |
| Con acciones irreversibles | Máximo | + Confirmación explícita + rollback documentado |

---

## Recursos

- [README.md](resources/README.md) — Origen del protocolo y adaptación al diplomado
- Skill relacionado: `n8n-mcp-tools-expert` — Herramientas MCP para publicación
- Skill relacionado: `diplomado-produccion-gotchas` — Errores reales y soluciones
- Registry de credenciales: `shared/credenciales.md`

# n8n SSDLC — Resources

## Origen del Protocolo

Este skill adapta principios de seguridad industriales al contexto específico de automatizaciones con n8n y agentes de IA:

| Framework | Qué tomamos |
|-----------|-------------|
| OWASP Top 10 for LLM Applications | Amenazas de prompt injection, data leakage, unbounded execution |
| NIST AI RMF (Risk Management Framework) | Principios de gobernanza: human-in-loop, auditabilidad, least capability |
| Secure Agentic AI Design | Controles para agentes con acceso a APIs: scope creep, blast radius |
| OWASP SSDLC | Ciclo de desarrollo seguro: checklist pre-deploy, validación, documentación |

## Adaptación al Diplomado

El protocolo original (508 líneas) está diseñado para equipos enterprise con CI/CD, feature branches, y PRs formales. Para el contexto educativo del diplomado, adaptamos:

| Original (Enterprise) | Adaptado (Diplomado) |
|-----------------------|---------------------|
| Git Flow con feature branches | JSON local como source of truth, publicación via MCP |
| STRIDE threat modeling completo | Tabla simplificada de 8 amenazas específicas para IA |
| Specs formales por workflow | Cerebros como documentación técnica |
| CI/CD pipeline | Pipeline MCP manual (validate → publish → test) |
| PR templates | Checklist de 8 puntos pre-publicación |
| Runbooks de producción | Tabla de fallos en cada Cerebro |

## Qué NO incluimos (y por qué)

- **Conventional Commits** — los alumnos no usan git directamente
- **SAST / análisis estático** — no hay código tradicional, son workflows visuales
- **Tests unitarios** — los workflows se validan via MCP y pruebas funcionales
- **Rollback via git** — se usa `workflow_versions` del MCP

## Relación con otras skills

| Skill | Relación |
|-------|----------|
| `n8n-mcp-tools-expert` | Herramientas técnicas que ejecutan el pipeline MCP |
| `diplomado-produccion-gotchas` | Errores reales; este skill previene los errores antes de que ocurran |
| `n8n-workflow-patterns` | Patrones arquitectónicos; este skill agrega la capa de seguridad |
| `n8n-validation-expert` | Validación técnica; este skill agrega validación de seguridad |

## Cómo contribuir

Al descubrir un nuevo patrón de seguridad durante la construcción de un sprint:

1. Documentarlo en `SKILL.md` bajo la sección correcta
2. Si es una amenaza nueva, agregarla a la tabla de modelado
3. Si es un control nuevo, agregarlo al checklist pre-publicación
4. Incluir el sprint donde se descubrió

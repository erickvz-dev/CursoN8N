# Guía de Setup: Tu Cerebro Experto en NotebookLM
> Diplomado IA & Automatización — Instrucciones para el alumno

---

## ¿Qué vas a construir?

Un **notebook personalizado en NotebookLM** con el material de dominio de negocio de cada sprint. Este notebook se conecta a Antigravity vía MCP para que puedas consultarlo directamente desde tu entorno de trabajo — sin cambiar de aplicación.

El resultado: cuando construyas un flujo de automatización, puedes preguntarle a tu cerebro experto "¿qué proceso de RRHH estoy intentando resolver?" y recibir contexto real del área de negocio.

---

## Paso 1 — Crea tu cuenta y notebook en NotebookLM

1. Ve a [notebooklm.google.com](https://notebooklm.google.com) e inicia sesión con tu cuenta de Google
2. Haz clic en **"Nuevo notebook"**
3. Nómbralo: `Diplomado IA - [Nombre del Sprint]`
   - Ejemplo: `Diplomado IA - Sprint 4 Recursos Humanos`

**Recomendación:** Crea un notebook por sprint. Mantener el contexto separado da mejores respuestas que mezclar todo en uno.

---

## Paso 2 — Sube los documentos de dominio

Cada sprint tiene un archivo Markdown de cerebro experto que el instructor te comparte. Para subirlo:

1. En tu notebook, haz clic en **"+"** o **"Agregar fuente"**
2. Selecciona **"Subir archivo"**
3. Sube el archivo `cerebro-0X-nombre-del-area.md` del sprint correspondiente

### Fuentes adicionales recomendadas por sprint

Además del cerebro experto, enriquece tu notebook con estas fuentes:

**Sprint 1 — Asistente de Voz:**
- [Documentación de Google Calendar API](https://developers.google.com/calendar/api/guides/overview)
- [OpenAI Whisper docs](https://platform.openai.com/docs/guides/speech-to-text)

**Sprint 2 — Producción Visual:**
- [Canva API docs](https://www.canva.com/developers/)
- [HeyGen API reference](https://docs.heygen.com)

**Sprint 3 — Marketing:**
- [Facebook Graph API - Instagram](https://developers.facebook.com/docs/instagram-api)
- Exporta y sube los guiones de los videos del sprint

**Sprint 4 — RRHH:**
- [Airtable API docs](https://airtable.com/developers/web/api/introduction)
- Cualquier descripción de puesto real que quieras usar como ejemplo

**Sprint 5 — Operaciones:**
- [Supabase docs](https://supabase.com/docs)
- [Telegram Bot API](https://core.telegram.org/bots/api)

**Sprint 6 — Finanzas:**
- Descarga un estado de cuenta de ejemplo de tu banco (elimina datos reales)
- [OpenAI TTS docs](https://platform.openai.com/docs/guides/text-to-speech)

**Sprint 7 — Ventas:**
- [HubSpot API docs](https://developers.hubspot.com/docs/api/overview)
- [Kommo API docs](https://developers.kommo.com)
- [ManyChat API](https://api.manychat.com)

---

## Paso 3 — Instala el MCP de NotebookLM

El MCP te permite consultar tu notebook directamente desde Antigravity sin cambiar de pestaña.

### Requisitos previos
- Node.js 18 o superior instalado
- Antigravity con soporte MCP configurado

### Instalación

Agrega esto a tu archivo de configuración MCP (normalmente `mcp-config.json` o dentro de la configuración de Antigravity):

```json
{
  "mcpServers": {
    "notebooklm": {
      "command": "npx",
      "args": ["-y", "notebooklm-mcp@latest"],
      "env": {
        "NOTEBOOKLM_PROFILE": "minimal"
      }
    }
  }
}
```

> El perfil `minimal` carga solo 5 herramientas esenciales. Es más rápido y consume menos tokens.

### Autenticación (una sola vez)

1. Reinicia Antigravity después de guardar la configuración
2. Escribe en el chat: `"Autentica NotebookLM"`
3. Se abrirá una ventana de Chrome — inicia sesión con la misma cuenta de Google donde creaste los notebooks
4. Listo. La sesión persiste entre reinicios.

---

## Paso 4 — Agrega tu notebook a la biblioteca del MCP

Una vez autenticado, dile a Antigravity:

```
Agrega este notebook a mi biblioteca: [pega aquí el link de tu notebook]
Etiquétalo como: sprint-04, rrhh, reclutamiento
```

Para obtener el link de tu notebook:
1. En NotebookLM, abre el notebook
2. Haz clic en el ícono de compartir (⚙️ o los tres puntos)
3. Activa "Cualquier persona con el link puede ver"
4. Copia el link

---

## Paso 5 — Verifica que funciona

Escribe esto en Antigravity:

```
¿Qué notebooks tengo disponibles en NotebookLM?
```

Deberías ver tu notebook en la lista. Luego prueba una consulta real:

```
Consulta el notebook de RRHH y dime cuáles son los procesos de reclutamiento 
más candidatos para automatizar
```

Si recibe respuesta del notebook, está funcionando correctamente.

---

## Cómo usar tu cerebro experto durante el sprint

### Para entender el contexto de negocio
```
Antes de construir el flujo, pregunta al notebook de [área]:
"¿Qué problema de negocio estoy resolviendo en este sprint?"
```

### Para diseñar el flujo
```
"Según el notebook de RRHH, ¿qué datos necesita extraer 
el sistema al recibir un CV para evaluarlo correctamente?"
```

### Para estudiar conceptos
```
"Explícame como si fuera nuevo en el área: ¿qué es el pipeline 
de ventas y cómo se relaciona con el flujo que voy a construir?"
```

### Para generar casos de uso propios
```
"Basándote en el notebook de Finanzas, dame 3 ideas de automatización 
para una empresa de [tu industria de interés]"
```

### Para preparar el Demo Day
```
"Ayúdame a estructurar la presentación de mi proyecto de [sprint]. 
Usa el notebook para contextualizar el problema de negocio que resuelvo."
```

---

## Solución de problemas frecuentes

**El MCP no se instala:**
- Verifica que tienes Node.js 18+: `node --version`
- Prueba instalando manualmente: `npm install -g notebooklm-mcp`

**Chrome no abre para autenticación:**
- Verifica que Chrome esté instalado
- En Mac: puede requerir permisos de accesibilidad en Configuración del Sistema

**El notebook no tiene los documentos:**
- NotebookLM tarda 1-3 minutos en procesar los documentos subidos
- Espera a que aparezca el indicador de "Procesado" antes de consultar

**Las respuestas son genéricas y no usan el notebook:**
- Asegúrate de seleccionar el notebook correcto antes de preguntar
- Usa el comando `select_notebook` explícitamente si Antigravity no lo detecta automáticamente

**El MCP pide re-autenticación frecuentemente:**
- Usa una cuenta de Google dedicada para el diplomado (no tu cuenta principal)
- No cierres sesión en esa cuenta en Chrome

---

## Estructura de notebooks recomendada

```
📚 Mis Notebooks del Diplomado
├── Diplomado IA - Sprint 1 Asistente de Voz
├── Diplomado IA - Sprint 2 Producción Visual  
├── Diplomado IA - Sprint 3 Marketing
├── Diplomado IA - Sprint 4 RRHH
├── Diplomado IA - Sprint 5 Operaciones
├── Diplomado IA - Sprint 6 Finanzas
└── Diplomado IA - Sprint 7 Ventas
```

Conforme avances en el diplomado, ve creando y nutriendo cada notebook.

---

## Créditos

Esta integración usa [notebooklm-mcp](https://github.com/PleasePrompto/notebooklm-mcp) — proyecto open source de terceros, no oficial de Google.

> ⚠️ Usa una cuenta de Google dedicada al diplomado. El MCP automatiza el browser de NotebookLM — aunque funciona correctamente, es recomendable no usar tu cuenta personal principal.

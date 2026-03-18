# Guiones — Semana 12: Dándole Voz a tus Finanzas

---

## Video 1: Tu director financiero a una llamada de distancia

**Duración estimada:** 4 minutos
**Formato:** Instructor a cámara + slides/visuals intercalados
**Objetivo:** Que el alumno entienda qué es Text-to-Speech, por qué importa, y cómo cierra el ciclo que abrimos en el Sprint 1.

---

**[TOMA: Instructor a cámara, fondo limpio]**

¿Te acuerdas del Sprint 1? Construimos un asistente que escuchaba. Le mandabas una nota de voz y él entendía lo que decías. Voz a texto. Whisper. Ese fue el primer superpoder que le dimos a nuestras automatizaciones.

Hoy le vamos a dar el segundo: hablar de vuelta.

**[VISUAL: Diagrama simple — micrófono → texto (Sprint 1) vs texto → bocina (Sprint 6)]**

En el Sprint 1 fuimos en esta dirección: de voz a texto. Hoy vamos en la dirección contraria: de texto a voz. Y con eso cerramos un ciclo completo. Tu sistema ahora puede escuchar una pregunta y responder hablando.

Esto se llama Text-to-Speech, o TTS. Y la versión de OpenAI suena tan natural que si yo no te digo que es una máquina, probablemente no lo notas.

**[TOMA: Instructor a cámara]**

Pero antes de entrar a la parte técnica, quiero que pienses en algo. ¿Cuántos reportes en PDF te han mandado este mes que no has abierto? Sé honesto. Probablemente varios. Y no es porque no te importen, es porque abrir un PDF requiere sentarte, leerlo, interpretarlo. Es fricción.

**[VISUAL: Collage de PDFs acumulados en una bandeja de correo vs. un teléfono con una nota de voz reproduciéndose]**

Ahora imagina esto: vas manejando, llegas a un semáforo, y le mandas un audio a tu bot de Telegram. Le dices: "¿Cómo cerramos el mes?". Y antes de que cambie la luz, tu teléfono te responde con una nota de voz. "Mira, cerramos el mes con ingresos cerca de los doscientos ochenta mil. Los proveedores nos comieron cuarenta por ciento del gasto. Te recomiendo revisar las comisiones de las plataformas de delivery porque se fueron al doble."

Eso no es ciencia ficción. Eso es lo que vamos a construir hoy.

**[TOMA: Instructor a cámara, cambio de ángulo]**

El concepto clave de esta semana es: la interfaz más natural del mundo es la voz. Un dashboard requiere que abras una app, inicies sesión, navegues. Una nota de voz requiere que escuches. Ya. Eso es todo.

Y lo que hace esto posible son tres piezas que ya conoces y una nueva:

**[VISUAL: Cuatro bloques apilados, aparecen uno por uno]**

Uno: Whisper transcribe tu pregunta. Eso ya lo dominamos.
Dos: Postgres tiene tus datos financieros. Eso lo conectamos en los sprints anteriores.
Tres: El LLM analiza los números y redacta un resumen. Eso ya lo hicimos con el reporte del Sprint 5.

Y cuatro, lo nuevo: OpenAI TTS toma ese resumen de texto y lo convierte en un archivo de audio con una voz que suena humana.

**[TOMA: Instructor a cámara, cierre]**

Lo más elegante de esta semana es que no estamos inventando nada desde cero. Estamos conectando piezas que ya construimos y agregando una capacidad nueva. Eso es automatización de verdad: cada sprint que construyes se convierte en un bloque para el siguiente.

En el próximo video te voy a mostrar la plataforma de OpenAI, las voces disponibles, y cómo asegurarte de que tengas saldo para usar el modelo de audio. Nos vemos ahí.

---
---

## Video 2: Las cuerdas vocales de la máquina

**Duración estimada:** 5 minutos
**Formato:** Screencast de la plataforma de OpenAI + voz del instructor en off
**Objetivo:** Que el alumno conozca la interfaz de TTS en OpenAI, escuche las voces, entienda costos, y pierda el miedo a generar audio.

---

**[PANTALLA: Navegador abierto en platform.openai.com]**

Muy bien, vamos a conocer la herramienta que le va a dar voz a nuestro bot. Estoy aquí en la plataforma de OpenAI, y lo primero que vamos a hacer es asegurarnos de que tengas saldo disponible.

**[PANTALLA: Navegando a Settings → Billing]**

Entra a Settings, luego a Billing. Aquí puedes ver tu crédito disponible. Para esta semana vas a necesitar muy poco. Un resumen financiero típico tiene alrededor de dos mil caracteres. El costo de Text-to-Speech es de un centavo y medio de dólar por cada mil caracteres. Entonces, cada vez que el bot te responda con una nota de voz, estás gastando unos tres centavos. Si haces veinte pruebas durante la clase, son sesenta centavos. Estamos hablando de menos de un dólar para toda la semana.

**[PANTALLA: Navegando al Playground → Audio]**

Ahora vamos a lo divertido. Entra al Playground y selecciona la sección de Audio. Aquí es donde puedes probar Text-to-Speech directamente.

Arriba vas a ver un campo de texto donde escribes lo que quieres que la máquina diga. Voy a escribir algo como:

"Cerramos el mes con ingresos de doscientos ochenta mil pesos. Los tres rubros más fuertes fueron ventas en local, delivery, y un evento de catering que nos dejó treinta y cuatro mil."

**[PANTALLA: Seleccionando modelo]**

Ahora, el modelo. Vas a ver varias opciones. Para nuestro proyecto vamos a usar gpt-4o-mini-tts. Este es el modelo más reciente y tiene algo especial: las voces suenan más expresivas, con entonación natural, como si alguien de verdad te estuviera platicando los resultados del mes.

Las otras opciones que vas a ver son tts-1 y tts-1-hd. El tts-1 es más rápido pero la voz suena un poco más robótica. El tts-1-hd mejora la calidad. Pero gpt-4o-mini-tts supera a ambos en naturalidad y cuesta lo mismo. Así que la decisión es fácil.

**[PANTALLA: Mostrando selector de voces]**

Abajo del modelo está el selector de voces. OpenAI te da trece voces. Voy a reproducir las que más nos interesan para el contexto financiero.

**[PANTALLA: Seleccionando "alloy" y reproduciendo]**

Esta es Alloy. Es neutra, profesional, versátil. Es la que vamos a usar por default en nuestro bot.

**[PANTALLA: Seleccionando "echo" y reproduciendo]**

Esta es Echo. Más grave, más seria. Si tu bot fuera el director de finanzas de un corporativo, usarías esta.

**[PANTALLA: Seleccionando "nova" y reproduciendo]**

Y esta es Nova. Más cálida, amigable. Si tu bot fuera más como un asistente personal que te cuenta las cosas con buena vibra, esta es tu opción.

Cualquiera funciona. En la clase vamos a usar Alloy, pero cuando construyas el tuyo puedes cambiarla y ver cuál se siente mejor para tu negocio.

**[PANTALLA: Mostrando el botón de generar y la descarga]**

Le doy a generar... y en unos dos o tres segundos tenemos el audio listo. Puedo reproducirlo aquí mismo o descargarlo. Nota que puedes elegir el formato: MP3, OPUS, WAV, y otros.

**[PANTALLA: Resaltando la opción de formato]**

Este detalle es importante. Para nuestro bot de Telegram vamos a necesitar formato OPUS. ¿Por qué? Porque Telegram trata los archivos de audio de forma diferente según el formato. Si le mandas un MP3, lo muestra como un archivo adjunto con un reproductor. Pero si le mandas OPUS, lo puede mostrar como una nota de voz, con la barrita de audio que ya conoces. Esa diferencia es clave para que la experiencia se sienta natural.

**[PANTALLA: Mostrando la documentación de la API brevemente]**

Y una última cosa. Todo lo que acabamos de hacer aquí en el Playground, n8n lo puede hacer con un solo nodo. El nodo de OpenAI tiene una operación que se llama Generate Audio. Tú le pasas el texto, seleccionas el modelo, la voz, el formato, y listo. El nodo te devuelve el archivo de audio como dato binario que puedes pasar directamente a Telegram.

No necesitas escribir código, no necesitas llamar APIs a mano. n8n se encarga.

**[PANTALLA: Volviendo al Playground con el audio generado]**

Eso es todo por este video. Ya sabes cómo funciona TTS, cuánto cuesta, qué voces hay, y por qué el formato importa. En el siguiente video vamos a cargar el manual de instrucciones en Antigravity para que la IA construya el flujo completo. Nos vemos.

---
---

## Video 3: El Manual del CFO

**Duración estimada:** 3-4 minutos
**Formato:** Screencast de Antigravity + voz del instructor en off
**Objetivo:** Que el alumno entienda qué hace el Cerebro de esta semana y cómo cargarlo en Antigravity antes de la clase.

---

**[PANTALLA: Antigravity abierto, interfaz limpia]**

Este es el momento donde le cargamos el cerebro a la IA para que sepa exactamente qué construir en la clase. Como en semanas anteriores, vamos a subir un documento que funciona como manual de instrucciones. Pero hoy el manual tiene algo diferente.

**[PANTALLA: Abriendo el archivo Cerebro_Bot_Voz_Financiero.md]**

El Cerebro de esta semana se llama "Bot de Voz Financiero" y lo que hace es decirle al arquitecto de Antigravity: "Oye, ya sabes leer bases de datos. Ya sabes generar texto con IA. Ya sabes conectar Telegram. Hoy te toca aprender a pronunciar."

Ese es el insight clave de hoy: el arquitecto ya sabe leer números, hoy le enseñamos a decirlos en voz alta.

**[PANTALLA: Scrolleando por el documento, mostrando la sección de arquitectura]**

Si ven la estructura del documento, tiene doce nodos organizados en tres bloques. Primer bloque: recepción del mensaje. El bot recibe una nota de voz o un texto, y lo normaliza. Esto ya lo conocen del Sprint 1.

**[PANTALLA: Señalando la sección de procesamiento financiero]**

Segundo bloque: procesamiento financiero. Aquí es donde se pone interesante. El bot hace una sola consulta a la base de datos que jala información de DOS tablas al mismo tiempo. La tabla de Gastos que construimos en el Sprint 5, y una tabla nueva de Transacciones bancarias que representa los estados de cuenta. Es un solo query, no dos flujos separados.

Eso le da al LLM un panorama financiero completo: sabe cuánto entró, cuánto salió, en qué se gastó, y qué gastos están aprobados o pendientes.

**[PANTALLA: Señalando la sección del LLM y TTS]**

Tercer bloque: generación de audio. El LLM redacta un resumen ejecutivo, pero ojo, no un resumen para leer. Un resumen para escuchar. El prompt le dice explícitamente: "Nada de bullets, nada de listas, nada de asteriscos. Solo párrafos fluidos. Redondea los montos para que suenen naturales al oído." Porque no es lo mismo leer cuarenta y ocho mil quinientos pesos que escucharlo. Para audio, dices "cerca de cuarenta y ocho mil."

Y después ese texto pasa al nodo de TTS, que lo convierte en audio formato OPUS, y sale directo como nota de voz en Telegram.

**[PANTALLA: Señalando las reglas críticas del documento]**

Tres cosas que quiero que noten en el documento:

**[PANTALLA: Resaltando "formato opus"]**

Uno: el formato de audio DEBE ser OPUS. Si es MP3, Telegram no lo muestra como nota de voz. Esta es la regla más importante de la semana.

**[PANTALLA: Resaltando "máximo 2500 caracteres"]**

Dos: el resumen no puede pasar de dos mil quinientos caracteres. OpenAI TTS tiene un límite de cuatro mil noventa y seis, pero nosotros le ponemos un colchón para no arriesgarnos.

**[PANTALLA: Resaltando "HTTP Request para sendVoice"]**

Y tres: para enviar la nota de voz usamos un HTTP Request directo a la API de Telegram, no el nodo nativo. ¿Por qué? Porque el nodo de Telegram en n8n no tiene la opción de enviar notas de voz. Tiene enviar audio, enviar documento, enviar foto, pero no nota de voz. Así que hacemos la llamada nosotros. El documento explica exactamente cómo.

**[PANTALLA: Subiendo el documento a Antigravity]**

Muy bien, ahora vamos a cargarlo. Tomo el archivo, lo arrastro aquí... y listo. Antigravity ya tiene todo el contexto que necesita.

**[PANTALLA: Mostrando el campo de prompt vacío]**

En la clase, lo que van a hacer es pegar el prompt maestro aquí, y el arquitecto va a construir el flujo completo: desde el trigger de Telegram hasta la nota de voz de salida. Doce nodos, tres bloques, un solo workflow.

**[TOMA: Instructor a cámara si hay cambio, o voz en off sobre Antigravity]**

Una cosa más. Antes de la clase, necesitan ejecutar un script de SQL en Supabase que crea la tabla de Transacciones y mete datos de prueba. Es un archivo que se llama setup-financiero.sql y está en la carpeta del sprint. Sin esos datos, el bot no tiene números que reportar. Así que no se salten ese paso.

Nos vemos en la clase. Van a construir algo que parece magia: le hablas a tu teléfono y tu negocio te contesta. Pero ya saben que detrás no hay magia, hay nodos bien conectados.

---
---

## Notas de producción

### Recursos visuales necesarios

**Video 1:**
- Diagrama "micrófono → texto" (Sprint 1) vs "texto → bocina" (Sprint 6)
- Collage: PDFs sin abrir en bandeja vs. nota de voz reproduciéndose
- Cuatro bloques apilados: Whisper / Postgres / LLM / TTS

**Video 2:**
- Screencast de platform.openai.com (Billing + Playground Audio)
- Grabación de las voces: alloy, echo, nova con el mismo texto financiero
- Formato de descarga resaltado (OPUS)

**Video 3:**
- Screencast de Antigravity con el Cerebro cargado
- El archivo Cerebro_Bot_Voz_Financiero.md abierto y scrolleable
- Señalamientos visuales (flechas, recuadros) en las tres reglas críticas

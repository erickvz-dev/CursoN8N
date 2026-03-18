# Meta WhatsApp Cloud API — Webhook Setup

Guía paso a paso para conectar n8n con Meta Developer Portal y recibir mensajes de WhatsApp.

---

## 1. Configuración en Meta Developer Portal

1. Ir a [developers.facebook.com](https://developers.facebook.com) e iniciar sesión con la cuenta de Facebook del alumno.
2. Crear una App nueva → tipo **Business**.
3. En el dashboard de la app, agregar el producto **WhatsApp** (botón "Set up").
4. Navegar a **WhatsApp → Configuration → Webhook**.
5. Hacer clic en **Edit** e ingresar:
   - **Callback URL**: URL de producción del Webhook Trigger de n8n (NO la URL de test — Meta necesita alcanzar el endpoint desde internet).
   - **Verify Token**: cualquier string arbitrario (ej: `diplomado2024`). Debe coincidir exactamente con el que se configure en n8n.
6. Hacer clic en **Verify and Save** — Meta hará una petición GET al webhook para verificarlo.
7. Una vez verificado, suscribir al campo: **`messages`** (hacer clic en "Subscribe" junto al campo).
8. Anotar el **Phone Number ID**: visible en **WhatsApp → API Setup**, debajo del número de teléfono. Es un número largo (ej: `102938475647382`). Es diferente al número de teléfono real y es el que se usa en la URL del endpoint de envío.

---

## 2. Configuración del Webhook Trigger en n8n (hub.challenge)

Meta verifica el webhook con una petición GET que incluye `hub.challenge`. n8n debe responder con ese valor para completar el registro.

### Configuración del nodo Webhook Trigger

```
HTTP Method: GET
Path: whatsapp-webhook
Respond: Immediately
Response Code: 200
Response Body: ={{ $json.query['hub.challenge'] }}
```

**Nota:** Esta configuración GET solo aplica durante el momento de registro. Los mensajes reales del usuario llegan como POST al mismo path. En producción, el nodo debe estar activo (no en modo test) para que Meta pueda alcanzarlo.

### Verificar que el handshake funciona

Antes de registrar en Meta, activar el workflow en n8n (no en modo test) y confirmar que la URL de producción responde. Si el workflow está en modo test durante el registro, Meta no podrá verificarlo.

---

## 3. Token Lifecycle

| Tipo | Duración | Cómo obtenerlo | Cuándo usar |
|---|---|---|---|
| Temporal | 24h | Dashboard de Meta Developer → WhatsApp → API Setup | Testing y desarrollo en clase |
| Larga duración | ~60 días | Intercambio via Graph API `/oauth/access_token` con App Secret | Staging |
| System User Token | Permanente | Meta Business Manager → System Users → Generate Token | Producción |

**Para el diplomado:** el token temporal (24h) es suficiente. Renovarlo al inicio de cada clase desde Meta Developer Portal → WhatsApp → API Setup → copiar el token del campo "Temporary access token".

---

## 4. Número de Prueba de Meta

El Developer Portal provee un número de prueba gratuito para development. Restricciones:

- Solo puede enviar mensajes a **hasta 5 números registrados manualmente** en la sección "To".
- El número destinatario debe **enviar primero un mensaje** al número de prueba para habilitarlo (Meta requiere opt-in).
- Para agregar un número receptor: **WhatsApp → API Setup → "To" → Manage Phone Number List** → agregar número con código de país → verificar con el código que llega por WhatsApp.

---

## 5. Troubleshooting

| Problema | Causa probable | Solución |
|---|---|---|
| Webhook no se verifica al registrar | URL incorrecta o n8n no está activo | Usar URL de producción (no de test), asegurarse de que el workflow esté activado (no en modo test) |
| Meta no entrega mensajes al webhook | No está suscrito al campo `messages` | Revisar Webhook Fields en Developer Portal → suscribir a `messages` |
| Delivery receipts disparan el flujo múltiples veces | Falta el nodo IF de filtro | Agregar `IF: ¿Es mensaje real?` con condición `messages exists` inmediatamente después del Webhook Trigger |
| "Request unauthorized" al enviar mensajes | Token expirado (el temporal dura 24h) | Renovar token en Meta Developer Portal → WhatsApp → API Setup |
| El número destinatario no recibe mensajes | No está en la whitelist del número de prueba | Agregar el número en WhatsApp → API Setup → To → Manage Phone Number List |
| Error 400 al enviar template | Template no aprobado o nombre incorrecto | Verificar estado del template en Meta Business Manager → debe ser `APPROVED` |
| `hub.challenge` devuelve undefined | El workflow está en modo test, no activo | Activar el workflow (botón "Active" en n8n, no "Test workflow") |

// Extraer acción e ID de un callback_data de Telegram.
//
// Entrada: $input con callback_query.data (ej: "aprobar_42")
// Salida:  { accion, registroId, nuevoEstado, emoji, callbackQueryId, chatIdGerente }
//
// Uso: Después de un Telegram Trigger con updates=["callback_query"].
// Sprint: 05 (Aprobación de Gastos)

const callbackData = $input.first().json.callback_query.data;
const partes = callbackData.split('_');

const accion = partes[0]; // "aprobar" o "rechazar"
const registroId = parseInt(partes[1]); // 42

const nuevoEstado = accion === 'aprobar' ? 'Aprobado' : 'Rechazado';
const emoji = accion === 'aprobar' ? '✅' : '❌';

return [{
  json: {
    accion: accion,
    registroId: registroId,
    nuevoEstado: nuevoEstado,
    emoji: emoji,
    callbackQueryId: $input.first().json.callback_query.id,
    chatIdGerente: $input.first().json.callback_query.message.chat.id
  }
}];

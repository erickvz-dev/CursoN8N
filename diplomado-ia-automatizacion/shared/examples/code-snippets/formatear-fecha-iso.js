// Convertir fecha en texto a formato ISO para Google Calendar.
//
// Entrada: $input con fecha (string, ej: "2026-03-07"), hora (string, ej: "09:00"),
//          duracion (number, minutos, default 60)
// Salida:  { fechaInicio: ISO string, fechaFin: ISO string }
//
// Uso: Antes de crear un evento en Google Calendar.
// Sprint: 01 (Asistente de Voz - Tool Crear Evento)

const datos = $input.first().json;

// Obtener fecha y hora, con defaults
const fecha = datos.fecha || $now.toFormat('yyyy-MM-dd');
const hora = datos.hora || '09:00';
const duracion = parseInt(datos.duracion) || 60;

// Construir fecha ISO de inicio
const fechaHora = `${fecha}T${hora}:00`;
const inicio = new Date(fechaHora);

// Calcular fecha de fin
const fin = new Date(inicio.getTime() + duracion * 60 * 1000);

return [{
  json: {
    fechaInicio: inicio.toISOString(),
    fechaFin: fin.toISOString(),
    fecha: fecha,
    hora: hora,
    duracion: duracion
  }
}];

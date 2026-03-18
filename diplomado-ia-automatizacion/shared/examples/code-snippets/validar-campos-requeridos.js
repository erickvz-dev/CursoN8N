// Validar que campos requeridos existan y no estén vacíos.
//
// Entrada: $input.first().json con cualquier objeto
// Salida:  { valido: boolean, camposFaltantes: string[] }
//
// Uso: Antes de INSERT a base de datos o envío de notificaciones.
// Patrón reutilizable en cualquier sprint.

const datos = $input.first().json;

// Definir los campos requeridos para este flujo
const camposRequeridos = ['fecha', 'empleado', 'monto', 'categoria'];

const camposFaltantes = camposRequeridos.filter(campo => {
  const valor = datos[campo];
  return valor === undefined || valor === null || valor === '';
});

const valido = camposFaltantes.length === 0;

return [{
  json: {
    ...datos,
    valido: valido,
    camposFaltantes: camposFaltantes
  }
}];

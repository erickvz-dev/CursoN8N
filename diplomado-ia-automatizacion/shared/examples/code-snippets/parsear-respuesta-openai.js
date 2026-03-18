// Parsear respuesta JSON de OpenAI, limpiando backticks de markdown.
//
// Entrada: $input con choices[0].message.content (string JSON)
// Salida:  Objeto con los campos parseados + json_valido (boolean)
//
// Uso: Después de un HTTP Request a OpenAI Vision o Chat que devuelve JSON como texto.
// Sprint: 05 (Captura de Gastos)

const respuesta = $input.first().json.choices[0].message.content;

// Limpiar backticks de markdown si OpenAI los agrega
const limpio = respuesta.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();

try {
  const datos = JSON.parse(limpio);

  return [{
    json: {
      ...datos,
      json_valido: true
    }
  }];
} catch (error) {
  return [{
    json: {
      json_valido: false,
      error: error.message,
      respuesta_cruda: limpio
    }
  }];
}

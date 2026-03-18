# Prompt: Extractor de Recibo (Sprint 5)

```
Extrae la información del siguiente recibo o comprobante de gasto.
Responde ÚNICAMENTE en JSON con este formato exacto:

{
  "monto": número (solo el número, sin símbolo de moneda),
  "moneda": "MXN" | "USD" | "EUR",
  "descripcion": "descripción breve del gasto",
  "categoria": "Alimentación" | "Transporte" | "Hospedaje" | "Material" | "Servicios" | "Otro",
  "fecha": "YYYY-MM-DD o null si no se puede determinar",
  "proveedor": "nombre del establecimiento o null",
  "confianza": "alta" | "media" | "baja"
}

Si no puedes extraer algún campo, usa null.
Texto/imagen del recibo: {recibo_contenido}
```

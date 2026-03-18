-- =============================================
-- Sprint 5 - Setup tabla Gastos en Supabase
-- Ejecutar en: Supabase → SQL Editor
-- =============================================
-- Nota: Supabase crea columnas lowercase por defecto.
-- La columna created_at se genera automáticamente.

-- 1. Crear la tabla Gastos
CREATE TABLE IF NOT EXISTS "Gastos" (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  empleado TEXT NOT NULL,
  monto NUMERIC(10,2) NOT NULL,
  categoria TEXT NOT NULL,
  estado TEXT DEFAULT 'Pendiente'
);

-- 2. Insertar 10 gastos de prueba (variedad de empleados, categorías y estados)
INSERT INTO "Gastos" (empleado, monto, categoria, estado) VALUES
('María García',     245.50,  'comida',      'Aprobado'),
('Carlos López',    1850.00,  'transporte',  'Aprobado'),
('Ana Martínez',     520.00,  'materiales',  'Pendiente'),
('Roberto Sánchez',  180.75,  'comida',      'Rechazado'),
('María García',    3200.00,  'materiales',  'Aprobado'),
('Carlos López',      95.00,  'comida',      'Pendiente'),
('Laura Hernández',  750.00,  'transporte',  'Aprobado'),
('Ana Martínez',     340.00,  'comida',      'Pendiente'),
('Roberto Sánchez', 1100.00,  'otro',        'Aprobado'),
('Laura Hernández',  425.50,  'materiales',  'Pendiente');

-- 3. Verificar que los datos se insertaron
SELECT * FROM "Gastos" ORDER BY id;

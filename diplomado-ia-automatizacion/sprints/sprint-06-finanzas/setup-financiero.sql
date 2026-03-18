-- =============================================================================
-- Sprint 6 — Finanzas: Setup de Base de Datos
-- Negocio simulado: "Cafetería Nube" (restaurante/cafetería mexicana)
-- Ejecutar en Supabase SQL Editor
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Crear tabla Transacciones (estados de cuenta bancarios)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "Transacciones" (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  fecha DATE NOT NULL,
  descripcion TEXT NOT NULL,
  monto NUMERIC(10,2) NOT NULL,
  tipo TEXT NOT NULL CHECK (tipo IN ('ingreso','egreso')),
  categoria TEXT NOT NULL,
  metodo_pago TEXT DEFAULT 'transferencia',
  referencia TEXT
);

-- -----------------------------------------------------------------------------
-- 2. Datos de prueba: Transacciones bancarias (febrero 2025)
-- -----------------------------------------------------------------------------

-- === INGRESOS ===

INSERT INTO "Transacciones" (fecha, descripcion, monto, tipo, categoria, metodo_pago, referencia) VALUES
-- Ventas en local (depósitos semanales consolidados)
('2025-02-03', 'Ventas en local semana 1 (27 ene - 2 feb)', 42500.00, 'ingreso', 'ventas_local', 'efectivo', 'DEP-2025-0201'),
('2025-02-10', 'Ventas en local semana 2 (3-9 feb)', 38750.00, 'ingreso', 'ventas_local', 'efectivo', 'DEP-2025-0202'),
('2025-02-17', 'Ventas en local semana 3 (10-16 feb) - incluye San Valentín', 67200.00, 'ingreso', 'ventas_local', 'efectivo', 'DEP-2025-0203'),
('2025-02-24', 'Ventas en local semana 4 (17-23 feb)', 41300.00, 'ingreso', 'ventas_local', 'efectivo', 'DEP-2025-0204'),

-- Ventas delivery (liquidaciones quincenales de plataformas)
('2025-02-07', 'Liquidación Uber Eats 2da quincena enero', 12840.00, 'ingreso', 'ventas_delivery', 'transferencia', 'UE-LIQ-2025-0201'),
('2025-02-14', 'Liquidación Rappi 1ra quincena febrero', 9650.00, 'ingreso', 'ventas_delivery', 'transferencia', 'RAP-LIQ-2025-0202'),
('2025-02-21', 'Liquidación Uber Eats 1ra quincena febrero', 14200.00, 'ingreso', 'ventas_delivery', 'transferencia', 'UE-LIQ-2025-0203'),
('2025-02-28', 'Liquidación Rappi 2da quincena febrero', 11350.00, 'ingreso', 'ventas_delivery', 'transferencia', 'RAP-LIQ-2025-0204'),

-- Catering / eventos
('2025-02-15', 'Catering cena San Valentín - Hotel Fiesta Inn (85 personas)', 34000.00, 'ingreso', 'catering', 'transferencia', 'FAC-2025-0089'),

-- Otro ingreso
('2025-02-20', 'Venta de café en grano a mayoreo - 50kg', 8500.00, 'ingreso', 'otro', 'transferencia', 'FAC-2025-0091');

-- === EGRESOS ===

INSERT INTO "Transacciones" (fecha, descripcion, monto, tipo, categoria, metodo_pago, referencia) VALUES
-- Nómina (quincenal, 12 empleados)
('2025-02-01', 'Nómina 2da quincena enero (12 empleados)', 48500.00, 'egreso', 'nomina', 'transferencia', 'NOM-2025-0201'),
('2025-02-15', 'Nómina 1ra quincena febrero (12 empleados)', 48500.00, 'egreso', 'nomina', 'transferencia', 'NOM-2025-0215'),

-- Renta
('2025-02-01', 'Renta local comercial - febrero 2025', 28000.00, 'egreso', 'renta', 'transferencia', 'RENTA-2025-02'),

-- Proveedores de alimentos (semanal)
('2025-02-03', 'Proveedor café verde Oaxaca - 80kg', 14400.00, 'egreso', 'proveedores', 'transferencia', 'PROV-CAF-0201'),
('2025-02-05', 'Central de Abastos - verduras y frutas semana 1', 6800.00, 'egreso', 'proveedores', 'efectivo', 'PROV-VER-0201'),
('2025-02-07', 'Distribuidora lácteos - leche, crema, quesos', 8950.00, 'egreso', 'proveedores', 'transferencia', 'PROV-LAC-0201'),
('2025-02-12', 'Central de Abastos - verduras y frutas semana 2', 7200.00, 'egreso', 'proveedores', 'efectivo', 'PROV-VER-0202'),
('2025-02-14', 'Panadería La Esperanza - pan artesanal quincenal', 4500.00, 'egreso', 'proveedores', 'efectivo', 'PROV-PAN-0201'),
('2025-02-19', 'Central de Abastos - verduras y frutas semana 3', 8100.00, 'egreso', 'proveedores', 'efectivo', 'PROV-VER-0203'),
('2025-02-21', 'Carnicería Don Sergio - cortes y pollo', 11200.00, 'egreso', 'proveedores', 'transferencia', 'PROV-CAR-0201'),
('2025-02-26', 'Central de Abastos - verduras y frutas semana 4', 6400.00, 'egreso', 'proveedores', 'efectivo', 'PROV-VER-0204'),

-- Servicios
('2025-02-05', 'CFE - consumo eléctrico enero', 5800.00, 'egreso', 'servicios', 'tarjeta', 'CFE-2025-02'),
('2025-02-08', 'Gas LP - recarga tanque estacionario 500L', 4200.00, 'egreso', 'servicios', 'efectivo', 'GAS-2025-0201'),
('2025-02-10', 'SAPAS - agua potable bimestre ene-feb', 1450.00, 'egreso', 'servicios', 'transferencia', 'AGUA-2025-02'),
('2025-02-10', 'Telmex - internet fibra óptica + línea fija', 1299.00, 'egreso', 'servicios', 'tarjeta', 'TEL-2025-02'),

-- Comisiones plataformas delivery
('2025-02-14', 'Comisión Uber Eats enero (30%)', 5490.00, 'egreso', 'plataformas', 'transferencia', 'COM-UE-2025-02'),
('2025-02-28', 'Comisión Rappi febrero (25%)', 5250.00, 'egreso', 'plataformas', 'transferencia', 'COM-RAP-2025-02'),

-- Impuestos y seguridad social
('2025-02-17', 'IMSS - cuotas obrero-patronales febrero', 9800.00, 'egreso', 'impuestos', 'transferencia', 'IMSS-2025-02'),
('2025-02-17', 'SAT - pago provisional ISR enero', 7200.00, 'egreso', 'impuestos', 'transferencia', 'SAT-ISR-2025-02'),

-- Mantenimiento
('2025-02-22', 'Mantenimiento máquina de espresso - refacciones', 3800.00, 'egreso', 'mantenimiento', 'tarjeta', 'MANT-2025-0201'),

-- Insumos desechables
('2025-02-11', 'Vasos, tapas, servilletas, bolsas para llevar', 3200.00, 'egreso', 'insumos', 'tarjeta', 'INS-2025-0201'),
('2025-02-25', 'Productos de limpieza y desinfectantes', 1850.00, 'egreso', 'insumos', 'efectivo', 'INS-2025-0202');


-- -----------------------------------------------------------------------------
-- 3. Datos de prueba: Gastos operativos (tabla existente del Sprint 5)
--    Solo insertar si la tabla ya existe
-- -----------------------------------------------------------------------------

INSERT INTO "Gastos" (empleado, monto, categoria, estado) VALUES
-- Aprobados (8)
('María López', 185.00, 'comida', 'Aprobado'),
('Carlos Ruiz', 240.00, 'transporte', 'Aprobado'),
('Ana Martínez', 520.00, 'materiales', 'Aprobado'),
('Roberto Sánchez', 95.00, 'comida', 'Aprobado'),
('María López', 310.00, 'comida', 'Aprobado'),
('Luis Hernández', 150.00, 'transporte', 'Aprobado'),
('Ana Martínez', 780.00, 'materiales', 'Aprobado'),
('Carlos Ruiz', 125.00, 'comida', 'Aprobado'),

-- Pendientes (4)
('Roberto Sánchez', 450.00, 'otro', 'Pendiente'),
('Luis Hernández', 89.00, 'comida', 'Pendiente'),
('María López', 1200.00, 'materiales', 'Pendiente'),
('Carlos Ruiz', 340.00, 'transporte', 'Pendiente'),

-- Rechazados (3)
('Roberto Sánchez', 3500.00, 'otro', 'Rechazado'),
('Luis Hernández', 890.00, 'materiales', 'Rechazado'),
('Ana Martínez', 2100.00, 'otro', 'Rechazado');

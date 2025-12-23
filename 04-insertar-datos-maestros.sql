-- =============================================
-- DATOS MAESTROS - FarmaciaMiBarrio
-- =============================================

USE FarmaciaMiBarrio;
GO

PRINT 'Insertando datos maestros...';
GO

-- SUCURSALES (4 Sucursales)
INSERT INTO Sucursales (CodigoSucursal, NombreSucursal, Direccion, Telefono, Email, Gerente, FechaApertura, Activo)
VALUES 
    ('SUC001', 'Farmacia Mi Barrio - Sede Central', 'Av. Larco 1234, Miraflores, Lima', '01-4567890', 'central@farmaciamibarrio.com', 'Carlos Mendoza Rivas', '2018-01-15', 1),
    ('SUC002', 'Farmacia Mi Barrio - San Isidro', 'Av. Javier Prado 2345, San Isidro, Lima', '01-4567891', 'sanisidro@farmaciamibarrio.com', 'María González Torres', '2019-03-20', 1),
    ('SUC003', 'Farmacia Mi Barrio - Surco', 'Av. Benavides 3456, Santiago de Surco, Lima', '01-4567892', 'surco@farmaciamibarrio.com', 'Roberto Díaz Flores', '2020-06-10', 1),
    ('SUC004', 'Farmacia Mi Barrio - Los Olivos', 'Av. Alfredo Mendiola 4567, Los Olivos, Lima', '01-4567893', 'losolivos@farmaciamibarrio.com', 'Ana Sánchez Pérez', '2021-09-05', 1);
GO

-- CATEGORÍAS
INSERT INTO Categorias (NombreCategoria, Descripcion, Activo)
VALUES 
    ('Analgésicos y Antiinflamatorios', 'Medicamentos para el alivio del dolor y la inflamación', 1),
    ('Antibióticos', 'Medicamentos para combatir infecciones bacterianas', 1),
    ('Antihipertensivos', 'Medicamentos para controlar la presión arterial', 1),
    ('Antidiabéticos', 'Medicamentos para el control de la diabetes', 1),
    ('Antihistamínicos', 'Medicamentos para alergias y reacciones alérgicas', 1),
    ('Cardiovasculares', 'Medicamentos para el sistema cardiovascular', 1),
    ('Gastrointestinales', 'Medicamentos para trastornos digestivos', 1),
    ('Respiratorios', 'Medicamentos para el sistema respiratorio', 1),
    ('Neurológicos', 'Medicamentos para trastornos neurológicos', 1),
    ('Psiquiátricos', 'Medicamentos para trastornos mentales', 1),
    ('Hormonales', 'Medicamentos hormonales y endocrinos', 1),
    ('Vitaminas y Suplementos', 'Suplementos nutricionales y vitaminas', 1),
    ('Dermatológicos', 'Medicamentos para la piel', 1),
    ('Oftalmológicos', 'Medicamentos para los ojos', 1),
    ('Antivirales', 'Medicamentos para combatir virus', 1);
GO

-- PROVEEDORES
INSERT INTO Proveedores (RUC, RazonSocial, NombreComercial, Direccion, Telefono, Email, ContactoNombre, ContactoTelefono, PaisOrigen, Activo)
VALUES 
    ('20123456789', 'Laboratorios Farmacéuticos del Perú S.A.', 'LabFarma Perú', 'Av. Industrial 1000, Lima', '01-5551000', 'ventas@labfarmaperu.com', 'Juan Pérez', '987654321', 'Perú', 1),
    ('20234567890', 'Droguería Internacional S.A.C.', 'Droguería Inter', 'Calle Los Negocios 200, Lima', '01-5552000', 'compras@droginter.com', 'María López', '987654322', 'Perú', 1),
    ('20345678901', 'Distribuidora Médica Global S.A.', 'MediGlobal', 'Av. Los Comerciantes 300, Lima', '01-5553000', 'ventas@mediglobal.com', 'Carlos Ruiz', '987654323', 'Perú', 1),
    ('20456789012', 'Importadora de Productos Farmacéuticos S.A.', 'ImpFarma', 'Jr. Las Importaciones 400, Lima', '01-5554000', 'info@impfarma.com', 'Ana Torres', '987654324', 'Perú', 1),
    ('20567890123', 'Bayer Perú S.A.', 'Bayer', 'Av. República de Panamá 3495, Lima', '01-5555000', 'contacto@bayer.pe', 'Roberto Díaz', '987654325', 'Alemania', 1),
    ('20678901234', 'Pfizer S.A.', 'Pfizer Perú', 'Av. El Derby 254, Lima', '01-5556000', 'contacto@pfizer.pe', 'Laura Martínez', '987654326', 'Estados Unidos', 1),
    ('20789012345', 'Novartis Biociencias S.A.', 'Novartis', 'Av. Paseo de la República 3074, Lima', '01-5557000', 'info@novartis.pe', 'José García', '987654327', 'Suiza', 1),
    ('20890123456', 'Laboratorios Roemmers S.A.', 'Roemmers', 'Av. Jorge Basadre 592, Lima', '01-5558000', 'ventas@roemmers.pe', 'Patricia Silva', '987654328', 'Argentina', 1);
GO

PRINT 'Datos maestros insertados: 4 Sucursales, 15 Categorías, 8 Proveedores';
GO

-- =============================================
-- CLIENTES Y EMPLEADOS - FarmaciaMiBarrio
-- =============================================

USE FarmaciaMiBarrio;
GO

SET NOCOUNT ON;
GO

PRINT 'Insertando empleados y clientes...';
GO

-- EMPLEADOS (10 por sucursal = 40 empleados)
-- Sucursal 1 - Sede Central
INSERT INTO Empleados (SucursalID, DNI, Nombres, Apellidos, Cargo, Email, Telefono, FechaNacimiento, FechaContratacion, Salario, Usuario, Contrasena, NivelAcceso, Activo)
VALUES 
-- SUPER ADMIN con acceso total
(1, '99999999', 'SUPER', 'ADMINISTRADOR', 'SUPER_ADMIN', 'admin@farmaciamibarrio.com', '999999999', '1975-01-01', '2018-01-01', 8000.00, 'admin', 'Admin123$', 1, 1),
-- </CHANGE>
(1, '12345678', 'Carlos Andrés', 'Mendoza Rivas', 'GERENTE', 'cmendoza@farmaciamibarrio.com', '987654301', '1980-05-15', '2018-01-15', 4500.00, 'cmendoza', 'Pass123$', 2, 1),
(1, '23456789', 'Laura Patricia', 'García López', 'FARMACEUTICO', 'lgarcia@farmaciamibarrio.com', '987654302', '1985-08-20', '2018-02-01', 3500.00, 'lgarcia', 'Pass123$', 3, 1),
(1, '34567890', 'Roberto José', 'Díaz Torres', 'FARMACEUTICO', 'rdiaz@farmaciamibarrio.com', '987654303', '1987-03-10', '2018-03-15', 3500.00, 'rdiaz', 'Pass123$', 3, 1),
(1, '45678901', 'María Elena', 'Sánchez Pérez', 'TECNICO', 'msanchez@farmaciamibarrio.com', '987654304', '1990-06-25', '2018-04-01', 2000.00, 'msanchez', 'Pass123$', 5, 1),
(1, '56789012', 'José Luis', 'Fernández Ruiz', 'TECNICO', 'jfernandez@farmaciamibarrio.com', '987654305', '1992-09-30', '2018-05-15', 2000.00, 'jfernandez', 'Pass123$', 5, 1),
(1, '67890123', 'Ana María', 'Martínez Silva', 'VENDEDOR', 'amartinez@farmaciamibarrio.com', '987654306', '1993-12-05', '2018-06-01', 1500.00, 'amartinez', 'Pass123$', 4, 1),
(1, '78901234', 'Pedro Alberto', 'Ramírez Castro', 'VENDEDOR', 'pramirez@farmaciamibarrio.com', '987654307', '1991-11-18', '2019-01-15', 1500.00, 'pramirez', 'Pass123$', 4, 1),
(1, '89012345', 'Sofia Beatriz', 'Flores Vargas', 'VENDEDOR', 'sflores@farmaciamibarrio.com', '987654308', '1994-04-22', '2019-03-01', 1500.00, 'sflores', 'Pass123$', 4, 1),
(1, '90123456', 'Miguel Ángel', 'Torres Mendoza', 'CAJERO', 'mtorres@farmaciamibarrio.com', '987654309', '1995-07-14', '2019-06-15', 1300.00, 'mtorres', 'Pass123$', 4, 1),
(1, '01234567', 'Carmen Rosa', 'Delgado Núñez', 'CAJERO', 'cdelgado@farmaciamibarrio.com', '987654310', '1996-10-08', '2019-09-01', 1300.00, 'cdelgado', 'Pass123$', 4, 1);

-- Sucursal 2 - San Isidro
INSERT INTO Empleados (SucursalID, DNI, Nombres, Apellidos, Cargo, Email, Telefono, FechaNacimiento, FechaContratacion, Salario, Usuario, Contrasena, NivelAcceso, Activo)
VALUES 
(2, '11234567', 'María Victoria', 'González Torres', 'GERENTE', 'mgonzalez@farmaciamibarrio.com', '987654311', '1982-02-12', '2019-03-20', 4500.00, 'mgarcia', 'Pass123$', 2, 1),
(2, '22345678', 'Jorge Alberto', 'Herrera Campos', 'FARMACEUTICO', 'jherrera@farmaciamibarrio.com', '987654312', '1986-05-17', '2019-04-01', 3500.00, 'jherrera', 'Pass123$', 3, 1),
(2, '33456789', 'Patricia Isabel', 'Rojas Medina', 'FARMACEUTICO', 'projas@farmaciamibarrio.com', '987654313', '1988-08-22', '2019-05-15', 3500.00, 'projas', 'Pass123$', 3, 1),
(2, '44567890', 'Luis Fernando', 'Castro Vega', 'TECNICO', 'lcastro@farmaciamibarrio.com', '987654314', '1991-11-27', '2019-06-01', 2000.00, 'lcastro', 'Pass123$', 5, 1),
(2, '55678901', 'Rosa María', 'Pérez Gutiérrez', 'TECNICO', 'rperez@farmaciamibarrio.com', '987654315', '1993-01-30', '2019-07-15', 2000.00, 'rperez2', 'Pass123$', 5, 1),
(2, '66789012', 'Carlos Eduardo', 'Morales Ríos', 'VENDEDOR', 'cmorales@farmaciamibarrio.com', '987654316', '1994-04-05', '2019-08-01', 1500.00, 'cmorales', 'Pass123$', 4, 1),
(2, '77890123', 'Gabriela Andrea', 'Vásquez Paredes', 'VENDEDOR', 'gvasquez@farmaciamibarrio.com', '987654317', '1995-07-10', '2019-09-15', 1500.00, 'gvasquez', 'Pass123$', 4, 1),
(2, '88901234', 'Fernando José', 'Chávez Luna', 'VENDEDOR', 'fchavez@farmaciamibarrio.com', '987654318', '1992-10-15', '2019-10-01', 1500.00, 'fchavez', 'Pass123$', 4, 1),
(2, '99012345', 'Valeria Sofía', 'Benítez Cruz', 'CAJERO', 'vbenitez@farmaciamibarrio.com', '987654319', '1996-01-20', '2019-11-15', 1300.00, 'vbenitez', 'Pass123$', 4, 1),
(2, '00123456', 'Daniel Alejandro', 'Salazar Ortiz', 'CAJERO', 'dsalazar@farmaciamibarrio.com', '987654320', '1997-04-25', '2019-12-01', 1300.00, 'dsalazar', 'Pass123$', 4, 1);

-- Sucursal 3 - Surco
INSERT INTO Empleados (SucursalID, DNI, Nombres, Apellidos, Cargo, Email, Telefono, FechaNacimiento, FechaContratacion, Salario, Usuario, Contrasena, NivelAcceso, Activo)
VALUES 
(3, '10234567', 'Roberto Manuel', 'Díaz Flores', 'GERENTE', 'rdiaz2@farmaciamibarrio.com', '987654321', '1981-03-08', '2020-06-10', 4500.00, 'rflores2', 'Pass123$', 2, 1),
(3, '20345678', 'Claudia Marcela', 'Jiménez Alvarado', 'FARMACEUTICO', 'cjimenez@farmaciamibarrio.com', '987654322', '1984-06-13', '2020-07-01', 3500.00, 'cjimenez', 'Pass123$', 3, 1),
(3, '30456789', 'Andrés Felipe', 'Navarro Reyes', 'FARMACEUTICO', 'anavarro@farmaciamibarrio.com', '987654323', '1987-09-18', '2020-08-15', 3500.00, 'anavarro', 'Pass123$', 3, 1),
(3, '40567890', 'Diana Carolina', 'Robles Soto', 'TECNICO', 'drobles@farmaciamibarrio.com', '987654324', '1990-12-23', '2020-09-01', 2000.00, 'drobles', 'Pass123$', 5, 1),
(3, '50678901', 'Ricardo Javier', 'Fuentes Aguilar', 'TECNICO', 'rfuentes@farmaciamibarrio.com', '987654325', '1992-03-28', '2020-10-15', 2000.00, 'rfuentes', 'Pass123$', 5, 1),
(3, '60789012', 'Mónica Alejandra', 'Cordero Zamora', 'VENDEDOR', 'mcordero@farmaciamibarrio.com', '987654326', '1993-06-02', '2020-11-01', 1500.00, 'mcordero', 'Pass123$', 4, 1),
(3, '70890123', 'Oscar Enrique', 'Molina Cabrera', 'VENDEDOR', 'omolina@farmaciamibarrio.com', '987654327', '1994-09-07', '2020-12-15', 1500.00, 'omolina', 'Pass123$', 4, 1),
(3, '80901234', 'Lucía Fernanda', 'Palacios Romero', 'VENDEDOR', 'lpalacios@farmaciamibarrio.com', '987654328', '1995-12-12', '2021-01-01', 1500.00, 'lpalacios', 'Pass123$', 4, 1),
(3, '90012345', 'Martín Sebastián', 'Acosta Ramírez', 'CAJERO', 'macosta@farmaciamibarrio.com', '987654329', '1996-03-17', '2021-02-15', 1300.00, 'macosta', 'Pass123$', 4, 1),
(3, '00012345', 'Natalia Beatriz', 'Carrillo Muñoz', 'CAJERO', 'ncarrillo@farmaciamibarrio.com', '987654330', '1997-06-22', '2021-03-01', 1300.00, 'ncarrillo', 'Pass123$', 4, 1);

-- Sucursal 4 - Los Olivos
INSERT INTO Empleados (SucursalID, DNI, Nombres, Apellidos, Cargo, Email, Telefono, FechaNacimiento, FechaContratacion, Salario, Usuario, Contrasena, NivelAcceso, Activo)
VALUES 
(4, '11234568', 'Ana Cristina', 'Sánchez Pérez', 'GERENTE', 'asanchez2@farmaciamibarrio.com', '987654331', '1983-04-15', '2021-09-05', 4500.00, 'arodriguez', 'Pass123$', 2, 1),
(4, '22345679', 'Héctor Manuel', 'Vargas Cortés', 'FARMACEUTICO', 'hvargas@farmaciamibarrio.com', '987654332', '1985-07-20', '2021-10-01', 3500.00, 'hvargas', 'Pass123$', 3, 1),
(4, '33456780', 'Isabel Cristina', 'León Espinoza', 'FARMACEUTICO', 'ileon@farmaciamibarrio.com', '987654333', '1988-10-25', '2021-11-15', 3500.00, 'ileon', 'Pass123$', 3, 1),
(4, '44567891', 'Pablo Arturo', 'Guzmán Castillo', 'TECNICO', 'pguzman@farmaciamibarrio.com', '987654334', '1991-01-30', '2021-12-01', 2000.00, 'pguzman', 'Pass123$', 5, 1),
(4, '55678902', 'Verónica Patricia', 'Santana Mejía', 'TECNICO', 'vsantana@farmaciamibarrio.com', '987654335', '1993-04-04', '2022-01-15', 2000.00, 'vsantana', 'Pass123$', 5, 1),
(4, '66789013', 'Guillermo Andrés', 'Ibarra Solís', 'VENDEDOR', 'gibarra@farmaciamibarrio.com', '987654336', '1994-07-09', '2022-02-01', 1500.00, 'gibarra', 'Pass123$', 4, 1),
(4, '77890124', 'Adriana Paola', 'Miranda Ochoa', 'VENDEDOR', 'amiranda@farmaciamibarrio.com', '987654337', '1995-10-14', '2022-03-15', 1500.00, 'amiranda2', 'Pass123$', 4, 1),
(4, '88901235', 'Rodrigo Alejandro', 'Campos Herrera', 'VENDEDOR', 'rcampos@farmaciamibarrio.com', '987654338', '1992-01-19', '2022-04-01', 1500.00, 'rcampos', 'Pass123$', 4, 1),
(4, '99012346', 'Camila Victoria', 'Ramos Peña', 'CAJERO', 'cramos@farmaciamibarrio.com', '987654339', '1996-04-24', '2022-05-15', 1300.00, 'cramos', 'Pass123$', 4, 1),
(4, '00123457', 'Sebastián Mateo', 'Arias Villanueva', 'CAJERO', 'sarias@farmaciamibarrio.com', '987654340', '1997-07-29', '2022-06-01', 1300.00, 'sarias', 'Pass123$', 4, 1);
GO

-- Insertar permisos por rol
INSERT INTO PermisosRoles (NivelAcceso, NombreRol, Modulo, Permiso, Activo)
VALUES
-- SUPER_ADMIN (Nivel 1) - Acceso total
(1, 'SUPER_ADMIN', 'VENTAS', 'VER', 1),
(1, 'SUPER_ADMIN', 'VENTAS', 'CREAR', 1),
(1, 'SUPER_ADMIN', 'VENTAS', 'EDITAR', 1),
(1, 'SUPER_ADMIN', 'VENTAS', 'ELIMINAR', 1),
(1, 'SUPER_ADMIN', 'COMPRAS', 'VER', 1),
(1, 'SUPER_ADMIN', 'COMPRAS', 'CREAR', 1),
(1, 'SUPER_ADMIN', 'COMPRAS', 'EDITAR', 1),
(1, 'SUPER_ADMIN', 'COMPRAS', 'ELIMINAR', 1),
(1, 'SUPER_ADMIN', 'INVENTARIO', 'VER', 1),
(1, 'SUPER_ADMIN', 'INVENTARIO', 'CREAR', 1),
(1, 'SUPER_ADMIN', 'INVENTARIO', 'EDITAR', 1),
(1, 'SUPER_ADMIN', 'INVENTARIO', 'ELIMINAR', 1),
(1, 'SUPER_ADMIN', 'REPORTES', 'VER', 1),
(1, 'SUPER_ADMIN', 'CONFIGURACION', 'VER', 1),
(1, 'SUPER_ADMIN', 'CONFIGURACION', 'EDITAR', 1),
-- GERENTE (Nivel 2) - Acceso a su sucursal
(2, 'GERENTE', 'VENTAS', 'VER', 1),
(2, 'GERENTE', 'VENTAS', 'CREAR', 1),
(2, 'GERENTE', 'COMPRAS', 'VER', 1),
(2, 'GERENTE', 'COMPRAS', 'CREAR', 1),
(2, 'GERENTE', 'COMPRAS', 'APROBAR', 1),
(2, 'GERENTE', 'INVENTARIO', 'VER', 1),
(2, 'GERENTE', 'INVENTARIO', 'EDITAR', 1),
(2, 'GERENTE', 'REPORTES', 'VER', 1),
-- SUPERVISOR (Nivel 3)
(3, 'SUPERVISOR', 'VENTAS', 'VER', 1),
(3, 'SUPERVISOR', 'VENTAS', 'CREAR', 1),
(3, 'SUPERVISOR', 'INVENTARIO', 'VER', 1),
(3, 'SUPERVISOR', 'REPORTES', 'VER', 1),
-- VENDEDOR (Nivel 4)
(4, 'VENDEDOR', 'VENTAS', 'VER', 1),
(4, 'VENDEDOR', 'VENTAS', 'CREAR', 1),
(4, 'VENDEDOR', 'INVENTARIO', 'VER', 1),
-- ALMACENERO (Nivel 5)
(5, 'ALMACENERO', 'INVENTARIO', 'VER', 1),
(5, 'ALMACENERO', 'INVENTARIO', 'EDITAR', 1),
(5, 'ALMACENERO', 'COMPRAS', 'VER', 1);
GO

PRINT '41 empleados insertados con usuarios y contraseñas (incluye 1 SUPER ADMIN)';
-- </CHANGE>

-- CLIENTES (2000 clientes)
DECLARE @Counter INT = 1;
DECLARE @MaxClientes INT = 2000;
DECLARE @TipoCliente VARCHAR(20);
DECLARE @NombreCliente VARCHAR(100);
DECLARE @ApellidoCliente VARCHAR(100);

WHILE @Counter <= @MaxClientes
BEGIN
    -- Determinar tipo de cliente (30% empresas, 70% personas)
    SET @TipoCliente = CASE 
        WHEN (ABS(CHECKSUM(NEWID())) % 10) < 3 THEN 'VIP'
        WHEN (ABS(CHECKSUM(NEWID())) % 10) < 5 THEN 'FRECUENTE'
        ELSE 'REGULAR'
    END;
    
    SET @NombreCliente = CASE (ABS(CHECKSUM(NEWID())) % 20) + 1
        WHEN 1 THEN 'Juan' WHEN 2 THEN 'María' WHEN 3 THEN 'Carlos' WHEN 4 THEN 'Ana'
        WHEN 5 THEN 'Luis' WHEN 6 THEN 'Rosa' WHEN 7 THEN 'Jorge' WHEN 8 THEN 'Patricia'
        WHEN 9 THEN 'Roberto' WHEN 10 THEN 'Laura' WHEN 11 THEN 'Fernando' WHEN 12 THEN 'Carmen'
        WHEN 13 THEN 'Pedro' WHEN 14 THEN 'Isabel' WHEN 15 THEN 'Miguel' WHEN 16 THEN 'Teresa'
        WHEN 17 THEN 'Javier' WHEN 18 THEN 'Mónica' WHEN 19 THEN 'Ricardo' WHEN 20 THEN 'Silvia'
    END;
    
    SET @ApellidoCliente = CASE (ABS(CHECKSUM(NEWID())) % 20) + 1
        WHEN 1 THEN 'García' WHEN 2 THEN 'Rodríguez' WHEN 3 THEN 'Martínez' WHEN 4 THEN 'López'
        WHEN 5 THEN 'González' WHEN 6 THEN 'Pérez' WHEN 7 THEN 'Sánchez' WHEN 8 THEN 'Ramírez'
        WHEN 9 THEN 'Torres' WHEN 10 THEN 'Flores' WHEN 11 THEN 'Rivera' WHEN 12 THEN 'Gómez'
        WHEN 13 THEN 'Díaz' WHEN 14 THEN 'Cruz' WHEN 15 THEN 'Morales' WHEN 16 THEN 'Herrera'
        WHEN 17 THEN 'Jiménez' WHEN 18 THEN 'Vargas' WHEN 19 THEN 'Castro' WHEN 20 THEN 'Rojas'
    END;
    
    INSERT INTO Clientes (
        TipoDocumento, NumeroDocumento, Nombres, Apellidos, RazonSocial,
        Direccion, Telefono, Email, FechaNacimiento, Genero, TipoCliente, Activo
    )
    VALUES (
        CASE WHEN @TipoCliente = 'VIP' AND (ABS(CHECKSUM(NEWID())) % 3) = 0 THEN 'RUC' ELSE 'DNI' END,
        CASE WHEN (ABS(CHECKSUM(NEWID())) % 3) = 0 
            THEN RIGHT('00000000000' + CAST(20000000000 + @Counter AS VARCHAR(11)), 11)
            ELSE RIGHT('00000000' + CAST(10000000 + @Counter AS VARCHAR(8)), 8)
        END,
        @NombreCliente,
        @ApellidoCliente,
        CASE 
            WHEN (ABS(CHECKSUM(NEWID())) % 10) < 3 
            THEN 'Empresa ' + @ApellidoCliente + ' ' + @NombreCliente + ' S.A.C.'
            ELSE @NombreCliente + ' ' + @ApellidoCliente
        END,
        'Av. Los Clientes ' + CAST(@Counter AS VARCHAR(10)) + ', Lima',
        '9' + RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(8)), 8),
        'cliente' + CAST(@Counter AS VARCHAR(10)) + '@email.com',
        DATEADD(YEAR, -(ABS(CHECKSUM(NEWID())) % 50 + 18), GETDATE()),
        CASE (ABS(CHECKSUM(NEWID())) % 2) WHEN 0 THEN 'M' ELSE 'F' END,
        @TipoCliente,
        1
    );
    
    IF @Counter % 500 = 0
    BEGIN
        PRINT 'Insertados ' + CAST(@Counter AS VARCHAR(10)) + ' clientes...';
    END
    
    SET @Counter = @Counter + 1;
END
GO

PRINT '2,000 clientes insertados exitosamente (TODOS con datos completos, sin NULL)';
GO

-- =============================================
-- SISTEMA DE SEGURIDAD COMPLETO - FarmaciaMiBarrio
-- Sistema de permisos por nivel de acceso
-- =============================================

USE FarmaciaMiBarrio;
GO

-- ============================================
-- FUNCIÓN: Validar Permisos por Usuario
-- ============================================
CREATE FUNCTION dbo.fn_ValidarPermiso (
    @Usuario VARCHAR(50),
    @Modulo NVARCHAR(100),
    @Permiso NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @TienePermiso BIT = 0;
    DECLARE @NivelAcceso INT;
    
    -- Corrección: usar Activo en lugar de Estado
    SELECT @NivelAcceso = NivelAcceso 
    FROM Empleados 
    WHERE Usuario = @Usuario AND Activo = 1;
    
    -- SUPER_ADMIN tiene acceso a todo
    IF @NivelAcceso = 1
        SET @TienePermiso = 1;
    ELSE
    BEGIN
        -- Verificar si tiene el permiso específico
        IF EXISTS (
            SELECT 1 FROM PermisosRoles 
            WHERE NivelAcceso = @NivelAcceso 
            AND Modulo = @Modulo 
            AND Permiso = @Permiso 
            AND Activo = 1
        )
            SET @TienePermiso = 1;
    END
    
    RETURN @TienePermiso;
END;
GO

-- ============================================
-- FUNCIÓN: Obtener Sucursal del Usuario
-- ============================================
CREATE FUNCTION dbo.fn_ObtenerSucursalUsuario (@Usuario VARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @SucursalID INT;
    
    -- Corrección: usar Activo en lugar de Estado
    SELECT @SucursalID = SucursalID 
    FROM Empleados 
    WHERE Usuario = @Usuario AND Activo = 1;
    
    RETURN @SucursalID;
END;
GO

-- ============================================
-- FUNCIÓN: Verificar si es Super Admin
-- ============================================
CREATE FUNCTION dbo.fn_EsSuperAdmin (@Usuario VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @EsSuperAdmin BIT = 0;
    
    -- Corrección: usar Activo en lugar de Estado
    IF EXISTS (
        SELECT 1 FROM Empleados 
        WHERE Usuario = @Usuario 
        AND NivelAcceso = 1 
        AND Activo = 1
    )
        SET @EsSuperAdmin = 1;
    
    RETURN @EsSuperAdmin;
END;
GO

-- ============================================
-- PROCEDIMIENTO: Autenticar Usuario
-- ============================================
CREATE PROCEDURE sp_AutenticarUsuario
    @Usuario VARCHAR(50),
    @Contrasena VARCHAR(255),
    @Autenticado BIT OUTPUT,
    @EmpleadoID INT OUTPUT,
    @NivelAcceso INT OUTPUT,
    @NombreCompleto NVARCHAR(200) OUTPUT,
    @SucursalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    SET @Autenticado = 0;
    
    -- Corrección: concatenar Nombres y Apellidos en lugar de NombreCompleto
    SELECT 
        @EmpleadoID = EmpleadoID,
        @NivelAcceso = NivelAcceso,
        @NombreCompleto = Nombres + ' ' + Apellidos,
        @SucursalID = SucursalID,
        @Autenticado = 1
    FROM Empleados
    WHERE Usuario = @Usuario 
    AND Contrasena = @Contrasena 
    AND Activo = 1;
    
    -- Registrar intento de acceso
    IF @Autenticado = 1
    BEGIN
        UPDATE Empleados 
        SET UltimoAcceso = GETDATE() 
        WHERE EmpleadoID = @EmpleadoID;
        
        INSERT INTO AuditoriaAccesos (EmpleadoID, Usuario, Accion, FechaHora, Resultado)
        VALUES (@EmpleadoID, @Usuario, 'LOGIN', GETDATE(), 'EXITOSO');
    END
    ELSE
    BEGIN
        INSERT INTO AuditoriaAccesos (EmpleadoID, Usuario, Accion, FechaHora, Resultado)
        VALUES (0, @Usuario, 'LOGIN_FALLIDO', GETDATE(), 'DENEGADO');
    END
    
    RETURN;
END;
GO

-- ============================================
-- PROCEDIMIENTO: Registrar Auditoría
-- ============================================
CREATE PROCEDURE sp_RegistrarAuditoria
    @Usuario VARCHAR(50),
    @Accion NVARCHAR(200),
    @Tabla NVARCHAR(50) = NULL,
    @RegistroID INT = NULL,
    @Detalles NVARCHAR(500) = NULL
AS
BEGIN
    DECLARE @EmpleadoID INT;
    
    -- Corrección: usar Activo en lugar de Estado
    SELECT @EmpleadoID = EmpleadoID 
    FROM Empleados 
    WHERE Usuario = @Usuario AND Activo = 1;
    
    INSERT INTO AuditoriaAccesos (
        EmpleadoID, Usuario, Accion, Tabla, RegistroID, 
        FechaHora, Resultado, Detalles
    )
    VALUES (
        ISNULL(@EmpleadoID, 0), @Usuario, @Accion, @Tabla, @RegistroID,
        GETDATE(), 'EXITOSO', @Detalles
    );
END;
GO

-- ============================================
-- VISTAS DE SEGURIDAD POR ROL
-- ============================================

-- Vista: Dashboard SUPER ADMIN (ve todo)
CREATE VIEW vw_Dashboard_SuperAdmin
AS
SELECT 
    'Total Productos' AS Metrica,
    COUNT(*) AS Valor,
    NULL AS SucursalID,
    'PRODUCTOS' AS Tipo
FROM Productos WHERE Activo = 1
UNION ALL
SELECT 
    'Total Clientes',
    COUNT(*),
    NULL,
    'CLIENTES'
FROM Clientes WHERE Activo = 1
UNION ALL
SELECT 
    'Total Empleados',
    COUNT(*),
    NULL,
    'EMPLEADOS'
FROM Empleados WHERE Activo = 1
UNION ALL
SELECT 
    'Total Sucursales',
    COUNT(*),
    NULL,
    'SUCURSALES'
FROM Sucursales WHERE Activo = 1
UNION ALL
-- Corrección: usar Estado en lugar de EstadoVenta
SELECT 
    'Ventas Hoy',
    COUNT(*),
    NULL,
    'VENTAS'
FROM Ventas 
WHERE CAST(FechaVenta AS DATE) = CAST(GETDATE() AS DATE) 
AND Estado = 'COMPLETADA'
UNION ALL
SELECT 
    'Monto Ventas Hoy',
    CAST(SUM(Total) AS INT),
    NULL,
    'MONTO'
FROM Ventas 
WHERE CAST(FechaVenta AS DATE) = CAST(GETDATE() AS DATE) 
AND Estado = 'COMPLETADA';
GO

-- Vista: Dashboard GERENTE (solo su sucursal)
CREATE VIEW vw_Dashboard_Gerente
AS
SELECT 
    e.EmpleadoID,
    e.Usuario,
    e.SucursalID,
    s.NombreSucursal,
    COUNT(DISTINCT i.ProductoID) AS ProductosConStock,
    COUNT(DISTINCT v.VentaID) AS VentasHoy,
    ISNULL(SUM(v.Total), 0) AS MontoVentasHoy,
    COUNT(DISTINCT em.EmpleadoID) AS EmpleadosSucursal
FROM Empleados e
INNER JOIN Sucursales s ON e.SucursalID = s.SucursalID
LEFT JOIN Inventario i ON s.SucursalID = i.SucursalID
-- Corrección: usar Estado y Activo en lugar de EstadoVenta
LEFT JOIN Ventas v ON s.SucursalID = v.SucursalID 
    AND CAST(v.FechaVenta AS DATE) = CAST(GETDATE() AS DATE)
    AND v.Estado = 'COMPLETADA'
LEFT JOIN Empleados em ON s.SucursalID = em.SucursalID AND em.Activo = 1
WHERE e.NivelAcceso = 2 AND e.Activo = 1
GROUP BY e.EmpleadoID, e.Usuario, e.SucursalID, s.NombreSucursal;
GO

-- Vista: Permisos del Usuario
CREATE VIEW vw_Permisos_Usuario
AS
SELECT 
    e.Usuario,
    e.NivelAcceso,
    CASE e.NivelAcceso
        WHEN 1 THEN 'SUPER_ADMIN'
        WHEN 2 THEN 'GERENTE'
        WHEN 3 THEN 'SUPERVISOR'
        WHEN 4 THEN 'VENDEDOR'
        WHEN 5 THEN 'ALMACENERO'
    END AS NombreRol,
    pr.Modulo,
    pr.Permiso,
    e.SucursalID,
    s.NombreSucursal
FROM Empleados e
-- Corrección: usar Activo en lugar de Estado
LEFT JOIN PermisosRoles pr ON e.NivelAcceso = pr.NivelAcceso AND pr.Activo = 1
LEFT JOIN Sucursales s ON e.SucursalID = s.SucursalID
WHERE e.Activo = 1;
GO

-- ============================================
-- TRIGGERS DE AUDITORÍA
-- ============================================

-- Trigger: Auditar cambios en Productos
CREATE TRIGGER trg_Auditoria_Productos
ON Productos
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Accion NVARCHAR(200);
    DECLARE @ProductoID INT;
    
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Accion = 'ACTUALIZAR_PRODUCTO';
        SELECT @ProductoID = ProductoID FROM inserted;
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SET @Accion = 'CREAR_PRODUCTO';
        SELECT @ProductoID = ProductoID FROM inserted;
    END
    ELSE
    BEGIN
        SET @Accion = 'ELIMINAR_PRODUCTO';
        SELECT @ProductoID = ProductoID FROM deleted;
    END
    
    INSERT INTO AuditoriaAccesos (EmpleadoID, Usuario, Accion, Tabla, RegistroID, FechaHora, Resultado)
    VALUES (0, SYSTEM_USER, @Accion, 'Productos', @ProductoID, GETDATE(), 'EXITOSO');
END;
GO

-- Trigger: Auditar cambios en Inventario
CREATE TRIGGER trg_Auditoria_Inventario
ON Inventario
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @Accion NVARCHAR(200);
    DECLARE @InventarioID INT;
    DECLARE @ExistenciaAnterior INT;
    DECLARE @ExistenciaNueva INT;
    
    -- Corrección: usar Existencia en lugar de StockActual
    SELECT 
        @InventarioID = i.InventarioID,
        @ExistenciaNueva = i.Existencia
    FROM inserted i;
    
    SELECT @ExistenciaAnterior = Existencia FROM deleted WHERE InventarioID = @InventarioID;
    
    IF @ExistenciaAnterior IS NULL
        SET @Accion = 'CREAR_INVENTARIO';
    ELSE
        SET @Accion = 'ACTUALIZAR_STOCK: ' + CAST(@ExistenciaAnterior AS VARCHAR) + ' → ' + CAST(@ExistenciaNueva AS VARCHAR);
    
    INSERT INTO AuditoriaAccesos (EmpleadoID, Usuario, Accion, Tabla, RegistroID, FechaHora, Resultado)
    VALUES (0, SYSTEM_USER, @Accion, 'Inventario', @InventarioID, GETDATE(), 'EXITOSO');
END;
GO

-- ============================================
-- INSERTAR PERMISOS POR ROL
-- ============================================

-- Permisos para SUPER_ADMIN (Nivel 1) - Acceso Total
INSERT INTO PermisosRoles (NivelAcceso, NombreRol, Modulo, Permiso, Activo) VALUES
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
(1, 'SUPER_ADMIN', 'CONFIGURACION', 'EDITAR', 1);

-- Permisos para GERENTE (Nivel 2)
INSERT INTO PermisosRoles (NivelAcceso, NombreRol, Modulo, Permiso, Activo) VALUES
(2, 'GERENTE', 'VENTAS', 'VER', 1),
(2, 'GERENTE', 'VENTAS', 'CREAR', 1),
(2, 'GERENTE', 'VENTAS', 'EDITAR', 1),
(2, 'GERENTE', 'COMPRAS', 'VER', 1),
(2, 'GERENTE', 'COMPRAS', 'CREAR', 1),
(2, 'GERENTE', 'INVENTARIO', 'VER', 1),
(2, 'GERENTE', 'INVENTARIO', 'EDITAR', 1),
(2, 'GERENTE', 'REPORTES', 'VER', 1);

-- Permisos para SUPERVISOR (Nivel 3)
INSERT INTO PermisosRoles (NivelAcceso, NombreRol, Modulo, Permiso, Activo) VALUES
(3, 'SUPERVISOR', 'VENTAS', 'VER', 1),
(3, 'SUPERVISOR', 'VENTAS', 'CREAR', 1),
(3, 'SUPERVISOR', 'INVENTARIO', 'VER', 1),
(3, 'SUPERVISOR', 'REPORTES', 'VER', 1);

-- Permisos para VENDEDOR (Nivel 4)
INSERT INTO PermisosRoles (NivelAcceso, NombreRol, Modulo, Permiso, Activo) VALUES
(4, 'VENDEDOR', 'VENTAS', 'VER', 1),
(4, 'VENDEDOR', 'VENTAS', 'CREAR', 1);

-- Permisos para ALMACENERO (Nivel 5)
INSERT INTO PermisosRoles (NivelAcceso, NombreRol, Modulo, Permiso, Activo) VALUES
(5, 'ALMACENERO', 'INVENTARIO', 'VER', 1),
(5, 'ALMACENERO', 'INVENTARIO', 'EDITAR', 1);

GO

SELECT 'Sistema de seguridad configurado correctamente' AS Resultado;
SELECT 'Total de permisos creados: ' + CAST(COUNT(*) AS VARCHAR) AS TotalPermisos 
FROM PermisosRoles;
GO

-- =============================================
-- MOSTRAR TODOS LOS DATOS - FarmaciaMiBarrio
-- Script 21: Consulta completa de todas las tablas
-- =============================================

USE FarmaciaMiBarrio;
GO

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT '  MOSTRANDO TODOS LOS DATOS DE LA BASE';
PRINT '  FarmaciaMiBarrio';
PRINT '========================================';
PRINT '';
GO

-- 1. SUCURSALES
PRINT '=== 1. SUCURSALES (4 registros) ===';
SELECT * FROM Sucursales ORDER BY SucursalID;
PRINT '';
GO

-- 2. CATEGORÍAS
PRINT '=== 2. CATEGORÍAS (15 registros) ===';
SELECT * FROM Categorias ORDER BY CategoriaID;
PRINT '';
GO

-- 3. PROVEEDORES
PRINT '=== 3. PROVEEDORES (8 registros) ===';
SELECT * FROM Proveedores ORDER BY ProveedorID;
PRINT '';
GO

-- 4. PRODUCTOS (10,000 registros - Mostrando primeros 100)
PRINT '=== 4. PRODUCTOS (10,000 registros totales) ===';
PRINT 'Mostrando primeros 100 productos...';
SELECT TOP 100 * FROM Productos ORDER BY ProductoID;
PRINT '';
PRINT 'Para ver todos los productos ejecuta: SELECT * FROM Productos';
PRINT '';
GO

-- 5. INVENTARIO (40,000 registros - Mostrando primeros 100)
PRINT '=== 5. INVENTARIO (40,000 registros totales) ===';
PRINT 'Mostrando primeros 100 registros de inventario...';
SELECT TOP 100 
    i.InventarioID,
    i.ProductoID,
    p.CodigoProducto,
    p.Descripcion,
    i.SucursalID,
    s.NombreSucursal,
    i.Existencia,
    i.UbicacionAlmacen,
    i.FechaUltimaActualizacion
FROM Inventario i
INNER JOIN Productos p ON i.ProductoID = p.ProductoID
INNER JOIN Sucursales s ON i.SucursalID = s.SucursalID
ORDER BY i.InventarioID;
PRINT '';
PRINT 'Para ver todo el inventario ejecuta: SELECT * FROM Inventario';
PRINT '';
GO

-- 6. CLIENTES (2,000 registros - Mostrando primeros 100)
PRINT '=== 6. CLIENTES (2,000 registros totales) ===';
PRINT 'Mostrando primeros 100 clientes...';
SELECT TOP 100 * FROM Clientes ORDER BY ClienteID;
PRINT '';
PRINT 'Para ver todos los clientes ejecuta: SELECT * FROM Clientes';
PRINT '';
GO

-- 7. EMPLEADOS (41 registros)
PRINT '=== 7. EMPLEADOS (41 registros - incluye 1 SUPER ADMIN) ===';
SELECT 
    EmpleadoID,
    SucursalID,
    DNI,
    Nombres,
    Apellidos,
    Cargo,
    Email,
    Telefono,
    FechaNacimiento,
    FechaContratacion,
    Salario,
    Usuario,
    NivelAcceso,
    CASE NivelAcceso
        WHEN 1 THEN 'SUPER_ADMIN'
        WHEN 2 THEN 'GERENTE'
        WHEN 3 THEN 'SUPERVISOR'
        WHEN 4 THEN 'VENDEDOR'
        WHEN 5 THEN 'ALMACENERO'
    END AS RolNombre,
    Activo
FROM Empleados 
ORDER BY NivelAcceso, SucursalID, EmpleadoID;
PRINT '';
GO

-- 8. VENTAS (5,000 registros - Mostrando primeras 100)
PRINT '=== 8. VENTAS (5,000 registros totales) ===';
PRINT 'Mostrando primeras 100 ventas...';
SELECT TOP 100 
    v.VentaID,
    v.NumeroVenta,
    v.SucursalID,
    s.NombreSucursal,
    v.ClienteID,
    CASE 
        WHEN c.Nombres IS NOT NULL THEN c.Nombres + ' ' + c.Apellidos
        ELSE c.RazonSocial
    END AS Cliente,
    v.EmpleadoID,
    e.Nombres + ' ' + e.Apellidos AS Empleado,
    v.FechaVenta,
    v.SubTotal,
    v.Descuento,
    v.IGV,
    v.Total,
    v.MetodoPago,
    v.Estado
FROM Ventas v
INNER JOIN Sucursales s ON v.SucursalID = s.SucursalID
LEFT JOIN Clientes c ON v.ClienteID = c.ClienteID
INNER JOIN Empleados e ON v.EmpleadoID = e.EmpleadoID
ORDER BY v.VentaID;
PRINT '';
PRINT 'Para ver todas las ventas ejecuta: SELECT * FROM Ventas';
PRINT '';
GO

-- 9. DETALLE DE VENTAS (Mostrando primeros 100)
PRINT '=== 9. DETALLE DE VENTAS ===';
PRINT 'Mostrando primeros 100 detalles de ventas...';
SELECT TOP 100 
    dv.DetalleVentaID,
    dv.VentaID,
    v.NumeroVenta,
    dv.ProductoID,
    p.CodigoProducto,
    p.Descripcion,
    dv.Cantidad,
    dv.PrecioUnitario,
    dv.Descuento,
    dv.Subtotal
FROM DetalleVentas dv
INNER JOIN Ventas v ON dv.VentaID = v.VentaID
INNER JOIN Productos p ON dv.ProductoID = p.ProductoID
ORDER BY dv.DetalleVentaID;
PRINT '';
PRINT 'Para ver todos los detalles ejecuta: SELECT * FROM DetalleVentas';
PRINT '';
GO

-- 10. COMPRAS (1,000 registros - Mostrando primeras 50)
PRINT '=== 10. COMPRAS (1,000 registros totales) ===';
PRINT 'Mostrando primeras 50 compras...';
SELECT TOP 50 
    c.CompraID,
    c.NumeroCompra,
    c.ProveedorID,
    pr.RazonSocial AS Proveedor,
    c.SucursalID,
    s.NombreSucursal,
    c.EmpleadoID,
    e.Nombres + ' ' + e.Apellidos AS Empleado,
    c.FechaCompra,
    c.SubTotal,
    c.IGV,
    c.Total,
    c.Estado
FROM Compras c
INNER JOIN Proveedores pr ON c.ProveedorID = pr.ProveedorID
INNER JOIN Sucursales s ON c.SucursalID = s.SucursalID
INNER JOIN Empleados e ON c.EmpleadoID = e.EmpleadoID
ORDER BY c.CompraID;
PRINT '';
PRINT 'Para ver todas las compras ejecuta: SELECT * FROM Compras';
PRINT '';
GO

-- 11. DETALLE DE COMPRAS (Mostrando primeros 100)
PRINT '=== 11. DETALLE DE COMPRAS ===';
PRINT 'Mostrando primeros 100 detalles de compras...';
SELECT TOP 100 
    dc.DetalleCompraID,
    dc.CompraID,
    c.NumeroCompra,
    dc.ProductoID,
    p.CodigoProducto,
    p.Descripcion,
    dc.Cantidad,
    dc.PrecioUnitario,
    dc.Subtotal,
    dc.FechaVencimiento,
    dc.Lote
FROM DetalleCompras dc
INNER JOIN Compras c ON dc.CompraID = c.CompraID
INNER JOIN Productos p ON dc.ProductoID = p.ProductoID
ORDER BY dc.DetalleCompraID;
PRINT '';
PRINT 'Para ver todos los detalles ejecuta: SELECT * FROM DetalleCompras';
PRINT '';
GO

-- 12. PERMISOS POR ROL
PRINT '=== 12. PERMISOS POR ROL ===';
SELECT 
    NivelAcceso,
    NombreRol,
    Modulo,
    Permiso,
    Activo
FROM PermisosRoles
ORDER BY NivelAcceso, Modulo, Permiso;
PRINT '';
GO

-- 13. AUDITORÍA DE ACCESOS (si tiene datos)
PRINT '=== 13. AUDITORÍA DE ACCESOS ===';
IF EXISTS (SELECT 1 FROM AuditoriaAccesos)
BEGIN
    SELECT TOP 50 * FROM AuditoriaAccesos ORDER BY AuditoriaID DESC;
END
ELSE
BEGIN
    PRINT 'No hay registros de auditoría aún.';
END
PRINT '';
GO

-- RESUMEN FINAL DE CONTEO DE REGISTROS
PRINT '========================================';
PRINT '  RESUMEN TOTAL DE REGISTROS';
PRINT '========================================';
SELECT 'Sucursales' AS Tabla, COUNT(*) AS TotalRegistros FROM Sucursales
UNION ALL
SELECT 'Categorías', COUNT(*) FROM Categorias
UNION ALL
SELECT 'Proveedores', COUNT(*) FROM Proveedores
UNION ALL
SELECT 'Productos', COUNT(*) FROM Productos
UNION ALL
SELECT 'Inventario', COUNT(*) FROM Inventario
UNION ALL
SELECT 'Clientes', COUNT(*) FROM Clientes
UNION ALL
SELECT 'Empleados', COUNT(*) FROM Empleados
UNION ALL
SELECT 'Ventas', COUNT(*) FROM Ventas
UNION ALL
SELECT 'DetalleVentas', COUNT(*) FROM DetalleVentas
UNION ALL
SELECT 'Compras', COUNT(*) FROM Compras
UNION ALL
SELECT 'DetalleCompras', COUNT(*) FROM DetalleCompras
UNION ALL
SELECT 'PermisosRoles', COUNT(*) FROM PermisosRoles
UNION ALL
SELECT 'AuditoriaAccesos', COUNT(*) FROM AuditoriaAccesos
ORDER BY Tabla;
GO

PRINT '';
PRINT '========================================';
PRINT '  DATOS MOSTRADOS EXITOSAMENTE';
PRINT '========================================';
PRINT '';
PRINT 'NOTA: Para ver tablas completas usa:';
PRINT '  SELECT * FROM [NombreTabla]';
PRINT '';
PRINT 'Ejemplo:';
PRINT '  SELECT * FROM Productos WHERE Activo = 1';
PRINT '  SELECT * FROM Inventario WHERE SucursalID = 1';
PRINT '  SELECT * FROM Ventas WHERE CAST(FechaVenta AS DATE) = CAST(GETDATE() AS DATE)';
GO

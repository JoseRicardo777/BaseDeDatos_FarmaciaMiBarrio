-- =============================================
-- INVENTARIO POR SUCURSAL - FarmaciaMiBarrio
-- Distribuir stock en las 4 sucursales
-- =============================================

USE FarmaciaMiBarrio;
GO

SET NOCOUNT ON;
GO

-- Agregar DELETE para limpiar datos anteriores y evitar duplicados
-- Limpiar tabla de inventario antes de insertar
DELETE FROM Inventario;
GO

-- Insertar inventario para cada producto en cada sucursal
INSERT INTO Inventario (ProductoID, SucursalID, Existencia, UbicacionAlmacen)
SELECT 
    p.ProductoID,
    s.SucursalID,
    -- Existencia aleatoria según sucursal
    CASE s.SucursalID
        WHEN 1 THEN ABS(CHECKSUM(NEWID())) % 5000 + 1000  -- Sede Central: más stock
        WHEN 2 THEN ABS(CHECKSUM(NEWID())) % 3000 + 500   -- San Isidro: stock medio
        WHEN 3 THEN ABS(CHECKSUM(NEWID())) % 3000 + 500   -- Surco: stock medio
        WHEN 4 THEN ABS(CHECKSUM(NEWID())) % 2000 + 200   -- Los Olivos: menos stock
    END,
    -- Ubicación en almacén
    'ESTANTE-' + CHAR(65 + (ABS(CHECKSUM(NEWID())) % 10)) + '-' + CAST((ABS(CHECKSUM(NEWID())) % 20) + 1 AS VARCHAR(2))
FROM Productos p
CROSS JOIN Sucursales s
WHERE p.Activo = 1 AND s.Activo = 1;
GO

-- Mostrar estadísticas de inventario generado
DECLARE @TotalInventario INT;
SELECT @TotalInventario = COUNT(*) FROM Inventario;

PRINT 'Inventario generado exitosamente';
PRINT 'Total de registros: ' + CAST(@TotalInventario AS VARCHAR(20));
PRINT 'Distribución por sucursal:';

SELECT 
    s.NombreSucursal,
    COUNT(*) AS Productos,
    SUM(i.Existencia) AS TotalUnidades,
    CAST(AVG(CAST(i.Existencia AS DECIMAL(18,2))) AS DECIMAL(10,2)) AS PromedioExistencia
FROM Inventario i
INNER JOIN Sucursales s ON i.SucursalID = s.SucursalID
GROUP BY s.SucursalID, s.NombreSucursal
ORDER BY s.SucursalID;
GO

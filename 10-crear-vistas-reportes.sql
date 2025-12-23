-- =============================================
-- VISTAS PARA REPORTES - FarmaciaMiBarrio
-- Optimizadas para Power BI
-- =============================================

USE FarmaciaMiBarrio;
GO

-- ============================================
-- VISTA: Reporte de Ventas Completo
-- ============================================
CREATE OR ALTER VIEW vw_Reporte_Ventas
AS
SELECT 
    v.VentaID,
    -- Usar NumeroVenta en lugar de NumeroComprobante
    v.NumeroVenta,
    v.FechaVenta,
    YEAR(v.FechaVenta) AS Anio,
    MONTH(v.FechaVenta) AS Mes,
    DATENAME(MONTH, v.FechaVenta) AS NombreMes,
    DAY(v.FechaVenta) AS Dia,
    DATENAME(WEEKDAY, v.FechaVenta) AS DiaSemana,
    s.NombreSucursal,
    s.Direccion AS DireccionSucursal,
    -- Concatenar Nombres y Apellidos en lugar de NombresCompletos
    CASE 
        WHEN c.Nombres IS NOT NULL THEN CONCAT(c.Nombres, ' ', c.Apellidos)
        ELSE c.RazonSocial
    END AS Cliente,
    c.TipoCliente,
    CONCAT(e.Nombres, ' ', e.Apellidos) AS Vendedor,
    e.Cargo AS CargoVendedor,
    v.SubTotal,
    v.IGV,
    v.Descuento,
    v.Total,
    -- Usar MetodoPago en lugar de FormaPago
    v.MetodoPago,
    v.Estado AS EstadoVenta,
    COUNT(dv.DetalleVentaID) AS CantidadProductos,
    SUM(dv.Cantidad) AS UnidadesVendidas
FROM Ventas v
INNER JOIN Sucursales s ON v.SucursalID = s.SucursalID
LEFT JOIN Clientes c ON v.ClienteID = c.ClienteID
INNER JOIN Empleados e ON v.EmpleadoID = e.EmpleadoID
INNER JOIN DetalleVentas dv ON v.VentaID = dv.VentaID
GROUP BY 
    v.VentaID, v.NumeroVenta, v.FechaVenta,
    s.NombreSucursal, s.Direccion, 
    c.Nombres, c.Apellidos, c.RazonSocial, c.TipoCliente,
    e.Nombres, e.Apellidos, e.Cargo,
    v.SubTotal, v.IGV, v.Descuento, v.Total,
    v.MetodoPago, v.Estado;
GO

-- ============================================
-- VISTA: Análisis de Productos Más Vendidos
-- ============================================
CREATE OR ALTER VIEW vw_Productos_Mas_Vendidos
AS
SELECT 
    p.ProductoID,
    p.CodigoProducto,
    -- Usar Descripcion en lugar de NombreProducto
    p.Descripcion AS NombreProducto,
    cat.NombreCategoria,
    p.Presentacion,
    p.Concentracion,
    p.Laboratorio,
    p.PrecioVenta,
    p.PrecioCompra,
    p.MargenGanancia,
    COUNT(DISTINCT dv.VentaID) AS NumeroVentas,
    SUM(dv.Cantidad) AS UnidadesTotalesVendidas,
    SUM(dv.Subtotal) AS IngresoTotal,
    AVG(dv.Cantidad) AS PromedioUnidadesPorVenta,
    MIN(v.FechaVenta) AS PrimeraVenta,
    MAX(v.FechaVenta) AS UltimaVenta
FROM Productos p
INNER JOIN Categorias cat ON p.CategoriaID = cat.CategoriaID
INNER JOIN DetalleVentas dv ON p.ProductoID = dv.ProductoID
INNER JOIN Ventas v ON dv.VentaID = v.VentaID
WHERE v.Estado = 'COMPLETADA' AND p.Activo = 1
GROUP BY 
    p.ProductoID, p.CodigoProducto, p.Descripcion, cat.NombreCategoria,
    p.Presentacion, p.Concentracion, p.Laboratorio, p.PrecioVenta, 
    p.PrecioCompra, p.MargenGanancia;
GO

-- ============================================
-- VISTA: Estado de Inventario por Sucursal
-- ============================================
CREATE OR ALTER VIEW vw_Inventario_Sucursales
AS
SELECT 
    s.SucursalID,
    s.NombreSucursal,
    s.Direccion,
    p.ProductoID,
    p.CodigoProducto,
    -- Usar Descripcion en lugar de NombreProducto
    p.Descripcion AS NombreProducto,
    cat.NombreCategoria,
    p.Presentacion,
    -- Usar Existencia en lugar de StockActual, eliminar StockReservado
    i.Existencia AS StockActual,
    p.StockMinimo,
    p.StockMaximo,
    CASE 
        WHEN i.Existencia <= p.StockMinimo THEN 'CRITICO'
        WHEN i.Existencia <= (p.StockMinimo * 1.5) THEN 'BAJO'
        WHEN i.Existencia >= p.StockMaximo THEN 'EXCESO'
        ELSE 'NORMAL'
    END AS EstadoStock,
    i.UbicacionAlmacen,
    -- Lote y fecha de vencimiento están en Productos, no en Inventario
    p.Lote,
    p.FechaVencimiento,
    DATEDIFF(DAY, GETDATE(), p.FechaVencimiento) AS DiasHastaVencimiento,
    p.PrecioCompra,
    p.PrecioVenta,
    CAST(i.Existencia AS DECIMAL(18,2)) * p.PrecioCompra AS ValorInventarioCompra,
    CAST(i.Existencia AS DECIMAL(18,2)) * p.PrecioVenta AS ValorInventarioVenta,
    i.FechaUltimaActualizacion
FROM Inventario i
INNER JOIN Productos p ON i.ProductoID = p.ProductoID
INNER JOIN Categorias cat ON p.CategoriaID = cat.CategoriaID
INNER JOIN Sucursales s ON i.SucursalID = s.SucursalID
WHERE p.Activo = 1 AND s.Activo = 1;
GO

-- ============================================
-- VISTA: Rendimiento de Empleados
-- ============================================
CREATE OR ALTER VIEW vw_Rendimiento_Empleados
AS
SELECT 
    e.EmpleadoID,
    -- Usar DNI en lugar de CodigoEmpleado
    e.DNI,
    CONCAT(e.Nombres, ' ', e.Apellidos) AS NombreCompleto,
    e.Cargo,
    e.NivelAcceso,
    s.NombreSucursal,
    s.CodigoSucursal,
    COUNT(DISTINCT v.VentaID) AS TotalVentas,
    ISNULL(SUM(v.Total), 0) AS MontoTotalVendido,
    ISNULL(AVG(v.Total), 0) AS PromedioVentaPorTransaccion,
    ISNULL(MAX(v.Total), 0) AS VentaMaxima,
    ISNULL(MIN(v.Total), 0) AS VentaMinima,
    MIN(v.FechaVenta) AS PrimeraVenta,
    MAX(v.FechaVenta) AS UltimaVenta,
    e.FechaContratacion,
    DATEDIFF(DAY, e.FechaContratacion, GETDATE()) AS DiasEnEmpresa,
    e.Salario,
    CASE 
        WHEN ISNULL(SUM(v.Total), 0) > 50000 THEN 'EXCELENTE'
        WHEN ISNULL(SUM(v.Total), 0) > 30000 THEN 'BUENO'
        WHEN ISNULL(SUM(v.Total), 0) > 10000 THEN 'REGULAR'
        ELSE 'BAJO'
    END AS NivelRendimiento
FROM Empleados e
INNER JOIN Sucursales s ON e.SucursalID = s.SucursalID
LEFT JOIN Ventas v ON e.EmpleadoID = v.EmpleadoID AND v.Estado = 'COMPLETADA'
WHERE e.Activo = 1
GROUP BY 
    e.EmpleadoID, e.DNI, e.Nombres, e.Apellidos, e.Cargo, e.NivelAcceso,
    s.NombreSucursal, s.CodigoSucursal, e.FechaContratacion, e.Salario;
GO

-- ============================================
-- VISTA: Análisis de Compras a Proveedores
-- ============================================
CREATE OR ALTER VIEW vw_Analisis_Compras
AS
SELECT 
    prov.ProveedorID,
    prov.RUC,
    prov.RazonSocial,
    prov.NombreComercial,
    -- TipoProveedor no existe, usar PaisOrigen
    prov.PaisOrigen,
    prov.ContactoNombre,
    COUNT(DISTINCT c.CompraID) AS TotalCompras,
    SUM(c.Total) AS MontoTotalComprado,
    AVG(c.Total) AS PromedioCompra,
    MAX(c.Total) AS CompraMaxima,
    COUNT(DISTINCT dc.ProductoID) AS ProductosComprados,
    SUM(dc.Cantidad) AS UnidadesTotalesCompradas,
    MIN(c.FechaCompra) AS PrimeraCompra,
    MAX(c.FechaCompra) AS UltimaCompra,
    DATEDIFF(DAY, MAX(c.FechaCompra), GETDATE()) AS DiasDesdeUltimaCompra,
    CASE 
        WHEN COUNT(DISTINCT c.CompraID) > 100 THEN 'PROVEEDOR_PREFERENCIAL'
        WHEN COUNT(DISTINCT c.CompraID) > 50 THEN 'PROVEEDOR_REGULAR'
        ELSE 'PROVEEDOR_OCASIONAL'
    END AS TipoRelacion
FROM Proveedores prov
INNER JOIN Compras c ON prov.ProveedorID = c.ProveedorID
INNER JOIN DetalleCompras dc ON c.CompraID = dc.CompraID
WHERE prov.Activo = 1 AND c.Estado = 'RECIBIDA'
GROUP BY 
    prov.ProveedorID, prov.RUC, prov.RazonSocial, prov.NombreComercial,
    prov.PaisOrigen, prov.ContactoNombre;
GO

-- ============================================
-- VISTA: Dashboard Ejecutivo
-- ============================================
CREATE OR ALTER VIEW vw_Dashboard_Ejecutivo
AS
SELECT 
    (SELECT COUNT(*) FROM Productos WHERE Activo = 1) AS TotalProductosActivos,
    (SELECT COUNT(*) FROM Clientes WHERE Activo = 1) AS TotalClientes,
    (SELECT COUNT(*) FROM Empleados WHERE Activo = 1) AS TotalEmpleados,
    (SELECT COUNT(*) FROM Sucursales WHERE Activo = 1) AS TotalSucursales,
    (SELECT COUNT(*) FROM Proveedores WHERE Activo = 1) AS TotalProveedores,
    (SELECT COUNT(*) FROM Ventas WHERE Estado = 'COMPLETADA' AND MONTH(FechaVenta) = MONTH(GETDATE()) AND YEAR(FechaVenta) = YEAR(GETDATE())) AS VentasMesActual,
    (SELECT ISNULL(SUM(Total), 0) FROM Ventas WHERE Estado = 'COMPLETADA' AND MONTH(FechaVenta) = MONTH(GETDATE()) AND YEAR(FechaVenta) = YEAR(GETDATE())) AS IngresosMesActual,
    (SELECT ISNULL(SUM(Total), 0) FROM Ventas WHERE Estado = 'COMPLETADA' AND YEAR(FechaVenta) = YEAR(GETDATE())) AS IngresosAnioActual,
    (SELECT ISNULL(SUM(CAST(i.Existencia AS BIGINT) * CAST(p.PrecioVenta AS DECIMAL(18,2))), 0) 
     FROM Inventario i INNER JOIN Productos p ON i.ProductoID = p.ProductoID WHERE p.Activo = 1) AS ValorTotalInventario,
    (SELECT COUNT(*) FROM Inventario i INNER JOIN Productos p ON i.ProductoID = p.ProductoID 
     WHERE i.Existencia <= p.StockMinimo AND p.Activo = 1) AS ProductosStockCritico,
    (SELECT COUNT(*) FROM Productos WHERE FechaVencimiento IS NOT NULL AND FechaVencimiento <= DATEADD(MONTH, 3, GETDATE()) AND Activo = 1) AS ProductosProximosVencer,
    (SELECT ISNULL(SUM(Total), 0) FROM Compras WHERE Estado = 'RECIBIDA' AND MONTH(FechaCompra) = MONTH(GETDATE()) AND YEAR(FechaCompra) = YEAR(GETDATE())) AS ComprasMesActual;
GO

PRINT 'Vistas para reportes creadas exitosamente';
PRINT 'Total de vistas creadas: 6';
GO

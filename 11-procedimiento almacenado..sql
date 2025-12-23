-- =============================================
-- PROCEDIMIENTOS ALMACENADOS - FarmaciaMiBarrio
-- =============================================

USE FarmaciaMiBarrio;
GO

-- ============================================
-- SP: Buscar Productos (con filtros)
-- ============================================
CREATE OR ALTER PROCEDURE sp_BuscarProductos
    @TextoBusqueda VARCHAR(200) = NULL,
    @CategoriaID INT = NULL,
    @SucursalID INT = NULL
AS
BEGIN
    -- Usando nombres correctos de columnas: Descripcion, sin CodigoBarras, sin LaboratorioFabricante, sin StockReservado
    SELECT 
        p.ProductoID,
        p.CodigoProducto,
        p.Descripcion,
        cat.NombreCategoria,
        p.Presentacion,
        p.Concentracion,
        p.Laboratorio,
        p.PrincipioActivo,
        p.PrecioVenta,
        p.RequiereReceta,
        ISNULL(i.Existencia, 0) AS StockDisponible,
        i.UbicacionAlmacen,
        p.Activo
    FROM Productos p
    INNER JOIN Categorias cat ON p.CategoriaID = cat.CategoriaID
    LEFT JOIN Inventario i ON p.ProductoID = i.ProductoID 
        AND (@SucursalID IS NULL OR i.SucursalID = @SucursalID)
    WHERE p.Activo = 1
        AND (@TextoBusqueda IS NULL OR 
             p.Descripcion LIKE '%' + @TextoBusqueda + '%' OR
             p.CodigoProducto LIKE '%' + @TextoBusqueda + '%' OR
             p.Laboratorio LIKE '%' + @TextoBusqueda + '%')
        AND (@CategoriaID IS NULL OR p.CategoriaID = @CategoriaID)
    ORDER BY p.Descripcion;
END;
GO

-- ============================================
-- SP: Registrar Venta
-- ============================================
CREATE OR ALTER PROCEDURE sp_RegistrarVenta
    @SucursalID INT,
    @ClienteID INT = NULL,
    @EmpleadoID INT,
    @MetodoPago VARCHAR(20),
    @DetallesJSON VARCHAR(MAX), -- JSON con productos [{ProductoID, Cantidad, PrecioUnitario}]
    @VentaID INT OUTPUT,
    @NumeroVenta VARCHAR(20) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @SubTotal DECIMAL(18,2) = 0;
        DECLARE @IGV DECIMAL(18,2);
        DECLARE @Total DECIMAL(18,2);
        
        -- Generar NumeroVenta usando formato VENT-YYYYMMDD-0001
        DECLARE @UltimoNumero INT;
        DECLARE @FechaHoy VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112);
        
        SELECT @UltimoNumero = ISNULL(MAX(CAST(RIGHT(NumeroVenta, 4) AS INT)), 0)
        FROM Ventas
        WHERE LEFT(NumeroVenta, 13) = 'VENT-' + @FechaHoy;
        
        SET @NumeroVenta = 'VENT-' + @FechaHoy + '-' + RIGHT('0000' + CAST(@UltimoNumero + 1 AS VARCHAR(4)), 4);
        
        -- Calcular totales (simplificado - en producción parsearías el JSON)
        SET @SubTotal = 0; -- Aquí calcularías desde el JSON
        SET @IGV = @SubTotal * 0.18;
        SET @Total = @SubTotal + @IGV;
        
        -- Insertar venta usando MetodoPago
        INSERT INTO Ventas (NumeroVenta, SucursalID, ClienteID, 
                           EmpleadoID, FechaVenta, SubTotal, Descuento, IGV, Total, 
                           MetodoPago, Estado)
        VALUES (@NumeroVenta, @SucursalID, @ClienteID,
                @EmpleadoID, GETDATE(), @SubTotal, 0, @IGV, @Total, 
                @MetodoPago, 'COMPLETADA');
        
        SET @VentaID = SCOPE_IDENTITY();
        
        -- Aquí deberías parsear el JSON de productos e insertar los detalles
        -- Ejemplo simplificado:
        -- INSERT INTO DetalleVentas (VentaID, ProductoID, Cantidad, PrecioUnitario, Descuento)
        -- SELECT @VentaID, ProductoID, Cantidad, PrecioUnitario, 0
        -- FROM OPENJSON(@DetallesJSON)
        -- WITH (ProductoID INT, Cantidad INT, PrecioUnitario DECIMAL(18,2))
        
        COMMIT TRANSACTION;
        
        SELECT @VentaID AS VentaID, @NumeroVenta AS NumeroVenta, @Total AS Total;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- ============================================
-- SP: Actualizar Stock
-- ============================================
CREATE OR ALTER PROCEDURE sp_ActualizarStock
    @ProductoID INT,
    @SucursalID INT,
    @Cantidad INT,
    @TipoMovimiento VARCHAR(20) -- ENTRADA, SALIDA, AJUSTE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Usando FechaUltimaActualizacion en lugar de FechaUltimaEntrada y FechaActualizacion
    IF @TipoMovimiento = 'ENTRADA'
    BEGIN
        UPDATE Inventario
        SET Existencia = Existencia + @Cantidad,
            FechaUltimaActualizacion = GETDATE()
        WHERE ProductoID = @ProductoID AND SucursalID = @SucursalID;
        
        IF @@ROWCOUNT = 0
        BEGIN
            -- Si no existe el registro, crearlo
            INSERT INTO Inventario (ProductoID, SucursalID, Existencia, FechaUltimaActualizacion)
            VALUES (@ProductoID, @SucursalID, @Cantidad, GETDATE());
        END
    END
    ELSE IF @TipoMovimiento = 'SALIDA'
    BEGIN
        -- Verificar stock disponible
        DECLARE @StockActual INT;
        SELECT @StockActual = Existencia
        FROM Inventario
        WHERE ProductoID = @ProductoID AND SucursalID = @SucursalID;
        
        IF @StockActual >= @Cantidad
        BEGIN
            UPDATE Inventario
            SET Existencia = Existencia - @Cantidad,
                FechaUltimaActualizacion = GETDATE()
            WHERE ProductoID = @ProductoID AND SucursalID = @SucursalID;
        END
        ELSE
        BEGIN
            THROW 50001, 'Stock insuficiente para realizar la operación', 1;
        END
    END
    ELSE IF @TipoMovimiento = 'AJUSTE'
    BEGIN
        UPDATE Inventario
        SET Existencia = @Cantidad,
            FechaUltimaActualizacion = GETDATE()
        WHERE ProductoID = @ProductoID AND SucursalID = @SucursalID;
    END
    
    -- Retornar nuevo stock
    SELECT 
        ProductoID,
        SucursalID,
        Existencia AS StockActual,
        FechaUltimaActualizacion
    FROM Inventario
    WHERE ProductoID = @ProductoID AND SucursalID = @SucursalID;
END;
GO

-- ============================================
-- SP: Reporte de Ventas por Período
-- ============================================
CREATE OR ALTER PROCEDURE sp_ReporteVentasPeriodo
    @FechaInicio DATE,
    @FechaFin DATE,
    @SucursalID INT = NULL
AS
BEGIN
    -- Usando MetodoPago en lugar de FormaPago
    SELECT 
        CAST(v.FechaVenta AS DATE) AS Fecha,
        s.NombreSucursal,
        COUNT(v.VentaID) AS TotalVentas,
        SUM(v.Total) AS MontoTotal,
        SUM(CASE WHEN v.MetodoPago = 'EFECTIVO' THEN v.Total ELSE 0 END) AS MontoEfectivo,
        SUM(CASE WHEN v.MetodoPago = 'TARJETA' THEN v.Total ELSE 0 END) AS MontoTarjeta,
        SUM(CASE WHEN v.MetodoPago IN ('YAPE','PLIN') THEN v.Total ELSE 0 END) AS MontoDigital,
        SUM(CASE WHEN v.MetodoPago = 'TRANSFERENCIA' THEN v.Total ELSE 0 END) AS MontoTransferencia,
        AVG(v.Total) AS PromedioVenta,
        SUM(v.Descuento) AS TotalDescuentos
    FROM Ventas v
    INNER JOIN Sucursales s ON v.SucursalID = s.SucursalID
    WHERE v.Estado = 'COMPLETADA'
        AND CAST(v.FechaVenta AS DATE) BETWEEN @FechaInicio AND @FechaFin
        AND (@SucursalID IS NULL OR v.SucursalID = @SucursalID)
    GROUP BY CAST(v.FechaVenta AS DATE), s.NombreSucursal
    ORDER BY Fecha DESC, s.NombreSucursal;
END;
GO

-- ============================================
-- SP: Productos con Stock Bajo
-- ============================================
CREATE OR ALTER PROCEDURE sp_ProductosStockBajo
    @SucursalID INT = NULL
AS
BEGIN
    SELECT 
        p.ProductoID,
        p.CodigoProducto,
        p.Descripcion,
        s.NombreSucursal,
        i.Existencia AS StockActual,
        p.StockMinimo,
        (p.StockMinimo - i.Existencia) AS CantidadFaltante,
        p.PrecioCompra,
        (p.StockMinimo - i.Existencia) * p.PrecioCompra AS MontoReposicion
    FROM Productos p
    INNER JOIN Inventario i ON p.ProductoID = i.ProductoID
    INNER JOIN Sucursales s ON i.SucursalID = s.SucursalID
    WHERE i.Existencia <= p.StockMinimo
        AND p.Activo = 1
        AND (@SucursalID IS NULL OR i.SucursalID = @SucursalID)
    ORDER BY (p.StockMinimo - i.Existencia) DESC, s.NombreSucursal;
END;
GO

PRINT 'Procedimientos almacenados creados exitosamente';
GO

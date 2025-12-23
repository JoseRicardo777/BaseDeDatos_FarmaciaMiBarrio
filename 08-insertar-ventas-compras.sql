-- =============================================
-- VENTAS Y COMPRAS - FarmaciaMiBarrio
-- Generar 5000 ventas y 1000 compras
-- =============================================

USE FarmaciaMiBarrio;
GO

SET NOCOUNT ON;
GO

PRINT 'Generando transacciones de ventas y compras...';
GO

-- GENERAR 5000 VENTAS
DECLARE @Counter INT = 1;
DECLARE @MaxVentas INT = 5000;
DECLARE @VentaID INT;
DECLARE @NumProductos INT;
DECLARE @FechaVenta DATETIME;
DECLARE @ClienteID INT;

WHILE @Counter <= @MaxVentas
BEGIN
    -- Fecha aleatoria en los últimos 365 días
    SET @FechaVenta = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 365), GETDATE());
    
    -- Seleccionar cliente aleatorio (SIEMPRE debe tener cliente)
    SELECT TOP 1 @ClienteID = ClienteID 
    FROM Clientes 
    WHERE Activo = 1 
    ORDER BY NEWID();
    
    -- Insertar venta
    INSERT INTO Ventas (
        NumeroVenta, SucursalID, ClienteID, EmpleadoID, FechaVenta,
        SubTotal, Descuento, IGV, Total, MetodoPago, Estado
    )
    VALUES (
        'V-' + FORMAT(GETDATE(), 'yyyyMMdd') + '-' + RIGHT('00000' + CAST(@Counter AS VARCHAR(5)), 5),
        (ABS(CHECKSUM(NEWID())) % 4) + 1, -- Sucursal aleatoria (1-4)
        @ClienteID, -- SIEMPRE con cliente, nunca NULL
        (SELECT TOP 1 EmpleadoID FROM Empleados WHERE Cargo IN ('VENDEDOR', 'FARMACEUTICO', 'CAJERO') ORDER BY NEWID()),
        @FechaVenta,
        0, 0, 0, 0, -- Se actualizarán después
        CASE (ABS(CHECKSUM(NEWID())) % 5)
            WHEN 0 THEN 'EFECTIVO'
            WHEN 1 THEN 'TARJETA'
            WHEN 2 THEN 'YAPE'
            WHEN 3 THEN 'PLIN'
            ELSE 'TRANSFERENCIA'
        END,
        CASE WHEN (ABS(CHECKSUM(NEWID())) % 100) < 98 THEN 'COMPLETADA' ELSE 'ANULADA' END
    );
    
    SET @VentaID = SCOPE_IDENTITY();
    
    -- Insertar detalle de venta (1-5 productos por venta)
    SET @NumProductos = (ABS(CHECKSUM(NEWID())) % 5) + 1;
    
    DECLARE @DetCounter INT = 1;
    WHILE @DetCounter <= @NumProductos
    BEGIN
        DECLARE @ProductoID INT;
        DECLARE @PrecioVenta DECIMAL(18,2);
        DECLARE @Cantidad INT;
        
        -- Seleccionar producto aleatorio
        SELECT TOP 1 
            @ProductoID = ProductoID,
            @PrecioVenta = PrecioVenta
        FROM Productos
        WHERE Activo = 1
        ORDER BY NEWID();
        
        SET @Cantidad = (ABS(CHECKSUM(NEWID())) % 10) + 1;
        
        INSERT INTO DetalleVentas (VentaID, ProductoID, Cantidad, PrecioUnitario, Descuento)
        VALUES (
            @VentaID,
            @ProductoID,
            @Cantidad,
            @PrecioVenta,
            CASE WHEN (ABS(CHECKSUM(NEWID())) % 10) = 0 THEN ROUND(RAND(CHECKSUM(NEWID())) * 10, 2) ELSE 0 END
        );
        
        SET @DetCounter = @DetCounter + 1;
    END
    
    -- Actualizar totales de la venta
    UPDATE Ventas
    SET 
        SubTotal = (SELECT SUM(Subtotal) FROM DetalleVentas WHERE VentaID = @VentaID),
        Descuento = (SELECT SUM(Descuento) FROM DetalleVentas WHERE VentaID = @VentaID),
        IGV = (SELECT SUM(Subtotal) FROM DetalleVentas WHERE VentaID = @VentaID) * 0.18,
        Total = (SELECT SUM(Subtotal) FROM DetalleVentas WHERE VentaID = @VentaID) * 1.18
    WHERE VentaID = @VentaID;
    
    IF @Counter % 500 = 0
    BEGIN
        PRINT 'Insertadas ' + CAST(@Counter AS VARCHAR(10)) + ' ventas...';
    END
    
    SET @Counter = @Counter + 1;
END
GO

PRINT '5,000 ventas generadas exitosamente (TODAS con cliente asignado, sin NULL)';
GO

-- GENERAR 1000 COMPRAS
DECLARE @Counter2 INT = 1;
DECLARE @MaxCompras INT = 1000;
DECLARE @CompraID INT;
DECLARE @NumProductosCompra INT;
DECLARE @FechaCompra DATETIME;

WHILE @Counter2 <= @MaxCompras
BEGIN
    -- Fecha aleatoria en los últimos 365 días
    SET @FechaCompra = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 365), GETDATE());
    
    -- Insertar compra
    INSERT INTO Compras (
        NumeroCompra, ProveedorID, SucursalID, EmpleadoID, FechaCompra,
        SubTotal, IGV, Total, Estado
    )
    VALUES (
        'C-' + FORMAT(GETDATE(), 'yyyyMMdd') + '-' + RIGHT('00000' + CAST(@Counter2 AS VARCHAR(5)), 5),
        (ABS(CHECKSUM(NEWID())) % 8) + 1, -- Proveedor aleatorio (1-8)
        (ABS(CHECKSUM(NEWID())) % 4) + 1, -- Sucursal aleatoria (1-4)
        (SELECT TOP 1 EmpleadoID FROM Empleados WHERE Cargo IN ('GERENTE', 'FARMACEUTICO') ORDER BY NEWID()),
        @FechaCompra,
        0, 0, 0, -- Se actualizarán después
        'RECIBIDA'
    );
    
    SET @CompraID = SCOPE_IDENTITY();
    
    -- Insertar detalle de compra (5-20 productos por compra)
    SET @NumProductosCompra = (ABS(CHECKSUM(NEWID())) % 16) + 5;
    
    DECLARE @DetCounter2 INT = 1;
    WHILE @DetCounter2 <= @NumProductosCompra
    BEGIN
        DECLARE @ProductoIDCompra INT;
        DECLARE @PrecioCompra DECIMAL(18,2);
        DECLARE @CantidadCompra INT;
        
        -- Seleccionar producto aleatorio
        SELECT TOP 1 
            @ProductoIDCompra = ProductoID,
            @PrecioCompra = PrecioCompra
        FROM Productos
        WHERE Activo = 1
        ORDER BY NEWID();
        
        SET @CantidadCompra = (ABS(CHECKSUM(NEWID())) % 500) + 50;
        
        INSERT INTO DetalleCompras (CompraID, ProductoID, Cantidad, PrecioUnitario, FechaVencimiento, Lote)
        VALUES (
            @CompraID,
            @ProductoIDCompra,
            @CantidadCompra,
            @PrecioCompra,
            DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 730) + 365, GETDATE()), -- Vencimiento en 1-3 años
            'LOTE-' + FORMAT(@FechaCompra, 'yyyyMMdd') + '-' + RIGHT('000' + CAST(@DetCounter2 AS VARCHAR(3)), 3)
        );
        
        SET @DetCounter2 = @DetCounter2 + 1;
    END
    
    -- Actualizar totales de la compra
    UPDATE Compras
    SET 
        SubTotal = (SELECT SUM(Subtotal) FROM DetalleCompras WHERE CompraID = @CompraID),
        IGV = (SELECT SUM(Subtotal) FROM DetalleCompras WHERE CompraID = @CompraID) * 0.18,
        Total = (SELECT SUM(Subtotal) FROM DetalleCompras WHERE CompraID = @CompraID) * 1.18
    WHERE CompraID = @CompraID;
    
    IF @Counter2 % 100 = 0
    BEGIN
        PRINT 'Insertadas ' + CAST(@Counter2 AS VARCHAR(10)) + ' compras...';
    END
    
    SET @Counter2 = @Counter2 + 1;
END
GO

PRINT '1,000 compras generadas exitosamente';
GO

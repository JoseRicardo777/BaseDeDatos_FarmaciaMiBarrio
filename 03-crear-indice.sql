-- =============================================
-- ÍNDICES PARA OPTIMIZACIÓN - FarmaciaMiBarrio
-- =============================================

USE FarmaciaMiBarrio;
GO

-- Índices en Productos
CREATE NONCLUSTERED INDEX IX_Productos_CategoriaID ON Productos(CategoriaID);
CREATE NONCLUSTERED INDEX IX_Productos_ProveedorID ON Productos(ProveedorID);
CREATE NONCLUSTERED INDEX IX_Productos_Descripcion ON Productos(Descripcion);
CREATE NONCLUSTERED INDEX IX_Productos_Activo ON Productos(Activo);
GO

-- Índices en Inventario
CREATE NONCLUSTERED INDEX IX_Inventario_ProductoID ON Inventario(ProductoID);
CREATE NONCLUSTERED INDEX IX_Inventario_SucursalID ON Inventario(SucursalID);
CREATE NONCLUSTERED INDEX IX_Inventario_Existencia ON Inventario(Existencia);
GO

-- Índices en Ventas
CREATE NONCLUSTERED INDEX IX_Ventas_SucursalID ON Ventas(SucursalID);
CREATE NONCLUSTERED INDEX IX_Ventas_ClienteID ON Ventas(ClienteID);
CREATE NONCLUSTERED INDEX IX_Ventas_EmpleadoID ON Ventas(EmpleadoID);
CREATE NONCLUSTERED INDEX IX_Ventas_FechaVenta ON Ventas(FechaVenta);
CREATE NONCLUSTERED INDEX IX_Ventas_Estado ON Ventas(Estado);
GO

-- Índices en DetalleVentas
CREATE NONCLUSTERED INDEX IX_DetalleVentas_VentaID ON DetalleVentas(VentaID);
CREATE NONCLUSTERED INDEX IX_DetalleVentas_ProductoID ON DetalleVentas(ProductoID);
GO

-- Índices en Compras
CREATE NONCLUSTERED INDEX IX_Compras_ProveedorID ON Compras(ProveedorID);
CREATE NONCLUSTERED INDEX IX_Compras_SucursalID ON Compras(SucursalID);
CREATE NONCLUSTERED INDEX IX_Compras_FechaCompra ON Compras(FechaCompra);
GO

-- Índices en Clientes
CREATE NONCLUSTERED INDEX IX_Clientes_NumeroDocumento ON Clientes(NumeroDocumento);
CREATE NONCLUSTERED INDEX IX_Clientes_TipoCliente ON Clientes(TipoCliente);
GO

-- Índices en Empleados
CREATE NONCLUSTERED INDEX IX_Empleados_SucursalID ON Empleados(SucursalID);
CREATE NONCLUSTERED INDEX IX_Empleados_DNI ON Empleados(DNI);
CREATE NONCLUSTERED INDEX IX_Empleados_Cargo ON Empleados(Cargo);
GO

PRINT 'Índices creados exitosamente';
GO

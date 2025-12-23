-- =============================================
-- TABLAS MAESTRAS - FarmaciaMiBarrio
-- =============================================

USE FarmaciaMiBarrio;
GO

-- TABLA: Sucursales (4 sucursales)
CREATE TABLE Sucursales (
    SucursalID INT IDENTITY(1,1) PRIMARY KEY,
    CodigoSucursal VARCHAR(10) NOT NULL UNIQUE,
    NombreSucursal NVARCHAR(100) NOT NULL,
    Direccion NVARCHAR(250) NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    Gerente NVARCHAR(100),
    FechaApertura DATE NOT NULL,
    Activo BIT DEFAULT 1,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    FechaActualizacion DATETIME DEFAULT GETDATE()
);
GO

-- TABLA: Categorias de Productos
CREATE TABLE Categorias (
    CategoriaID INT IDENTITY(1,1) PRIMARY KEY,
    NombreCategoria NVARCHAR(100) NOT NULL UNIQUE,
    Descripcion NVARCHAR(500),
    Activo BIT DEFAULT 1,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

-- TABLA: Proveedores
CREATE TABLE Proveedores (
    ProveedorID INT IDENTITY(1,1) PRIMARY KEY,
    RUC VARCHAR(11) NOT NULL UNIQUE,
    RazonSocial NVARCHAR(200) NOT NULL,
    NombreComercial NVARCHAR(200),
    Direccion NVARCHAR(250),
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    ContactoNombre NVARCHAR(100),
    ContactoTelefono VARCHAR(20),
    PaisOrigen NVARCHAR(50),
    Activo BIT DEFAULT 1,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    FechaActualizacion DATETIME DEFAULT GETDATE()
);
GO

-- TABLA: Productos
CREATE TABLE Productos (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    CodigoProducto VARCHAR(20) NOT NULL UNIQUE,
    Descripcion NVARCHAR(500) NOT NULL,
    CategoriaID INT NOT NULL,
    ProveedorID INT NOT NULL,
    PrecioCompra DECIMAL(18,2) NOT NULL,
    PrecioVenta DECIMAL(18,2) NOT NULL,
    MargenGanancia AS (((PrecioVenta - PrecioCompra) / PrecioCompra) * 100) PERSISTED,
    StockMinimo INT DEFAULT 100,
    StockMaximo INT DEFAULT 10000,
    RequiereReceta BIT DEFAULT 0,
    FechaVencimiento DATE,
    Lote VARCHAR(50),
    Laboratorio NVARCHAR(200),
    PrincipioActivo NVARCHAR(500),
    Presentacion NVARCHAR(200),
    Concentracion NVARCHAR(100),
    ViaAdministracion NVARCHAR(100),
    Activo BIT DEFAULT 1,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    FechaActualizacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Productos_Categoria FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID),
    CONSTRAINT FK_Productos_Proveedor FOREIGN KEY (ProveedorID) REFERENCES Proveedores(ProveedorID),
    CONSTRAINT CHK_Precio_Compra CHECK (PrecioCompra > 0),
    CONSTRAINT CHK_Precio_Venta CHECK (PrecioVenta >= PrecioCompra)
);
GO

-- TABLA: Inventario por Sucursal
CREATE TABLE Inventario (
    InventarioID INT IDENTITY(1,1) PRIMARY KEY,
    ProductoID INT NOT NULL,
    SucursalID INT NOT NULL,
    Existencia INT NOT NULL DEFAULT 0,
    UbicacionAlmacen VARCHAR(50),
    FechaUltimaActualizacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Inventario_Producto FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    CONSTRAINT FK_Inventario_Sucursal FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID),
    CONSTRAINT UQ_Inventario_Producto_Sucursal UNIQUE (ProductoID, SucursalID),
    CONSTRAINT CHK_Existencia CHECK (Existencia >= 0)
);
GO

-- TABLA: Clientes
CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    TipoDocumento VARCHAR(10) NOT NULL, -- DNI, RUC, CE
    NumeroDocumento VARCHAR(20) NOT NULL UNIQUE,
    Nombres NVARCHAR(100),
    Apellidos NVARCHAR(100),
    RazonSocial NVARCHAR(200),
    Direccion NVARCHAR(250),
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    FechaNacimiento DATE,
    Genero CHAR(1), -- M, F
    TipoCliente VARCHAR(20) DEFAULT 'REGULAR', -- REGULAR, FRECUENTE, VIP
    Activo BIT DEFAULT 1,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    FechaActualizacion DATETIME DEFAULT GETDATE()
);
GO

-- TABLA: Empleados
CREATE TABLE Empleados (
    EmpleadoID INT IDENTITY(1,1) PRIMARY KEY,
    SucursalID INT NOT NULL,
    DNI VARCHAR(8) NOT NULL UNIQUE,
    Nombres NVARCHAR(100) NOT NULL,
    Apellidos NVARCHAR(100) NOT NULL,
    Cargo NVARCHAR(50) NOT NULL, -- FARMACEUTICO, TECNICO, VENDEDOR, GERENTE, CAJERO
    Email VARCHAR(100),
    Telefono VARCHAR(20),
    Direccion NVARCHAR(250),
    FechaNacimiento DATE,
    FechaContratacion DATE NOT NULL,
    Salario DECIMAL(18,2),
    -- Agregando seguridad y control de acceso
    Usuario VARCHAR(50) UNIQUE,
    Contrasena VARCHAR(255),
    NivelAcceso INT DEFAULT 4, -- 1=SUPER_ADMIN, 2=GERENTE, 3=SUPERVISOR, 4=VENDEDOR, 5=ALMACENERO
    UltimoAcceso DATETIME,
    -- </CHANGE>
    Activo BIT DEFAULT 1,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    FechaActualizacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Empleados_Sucursal FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID)
);
GO

-- TABLA: Ventas
CREATE TABLE Ventas (
    VentaID INT IDENTITY(1,1) PRIMARY KEY,
    NumeroVenta VARCHAR(20) NOT NULL UNIQUE,
    SucursalID INT NOT NULL,
    ClienteID INT,
    EmpleadoID INT NOT NULL,
    FechaVenta DATETIME NOT NULL DEFAULT GETDATE(),
    SubTotal DECIMAL(18,2) NOT NULL,
    Descuento DECIMAL(18,2) DEFAULT 0,
    IGV DECIMAL(18,2) NOT NULL,
    Total DECIMAL(18,2) NOT NULL,
    MetodoPago VARCHAR(20) NOT NULL, -- EFECTIVO, TARJETA, YAPE, PLIN, TRANSFERENCIA
    Estado VARCHAR(20) DEFAULT 'COMPLETADA', -- COMPLETADA, ANULADA
    Observaciones NVARCHAR(500),
    FechaRegistro DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Ventas_Sucursal FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID),
    CONSTRAINT FK_Ventas_Cliente FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
    CONSTRAINT FK_Ventas_Empleado FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID)
);
GO

-- TABLA: Detalle de Ventas
CREATE TABLE DetalleVentas (
    DetalleVentaID INT IDENTITY(1,1) PRIMARY KEY,
    VentaID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(18,2) NOT NULL,
    Descuento DECIMAL(18,2) DEFAULT 0,
    Subtotal AS (Cantidad * PrecioUnitario - Descuento) PERSISTED,
    CONSTRAINT FK_DetalleVentas_Venta FOREIGN KEY (VentaID) REFERENCES Ventas(VentaID),
    CONSTRAINT FK_DetalleVentas_Producto FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    CONSTRAINT CHK_Cantidad CHECK (Cantidad > 0)
);
GO

-- TABLA: Compras a Proveedores
CREATE TABLE Compras (
    CompraID INT IDENTITY(1,1) PRIMARY KEY,
    NumeroCompra VARCHAR(20) NOT NULL UNIQUE,
    ProveedorID INT NOT NULL,
    SucursalID INT NOT NULL,
    EmpleadoID INT NOT NULL,
    FechaCompra DATETIME NOT NULL DEFAULT GETDATE(),
    SubTotal DECIMAL(18,2) NOT NULL,
    IGV DECIMAL(18,2) NOT NULL,
    Total DECIMAL(18,2) NOT NULL,
    Estado VARCHAR(20) DEFAULT 'RECIBIDA', -- PENDIENTE, RECIBIDA, ANULADA
    Observaciones NVARCHAR(500),
    FechaRegistro DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Compras_Proveedor FOREIGN KEY (ProveedorID) REFERENCES Proveedores(ProveedorID),
    CONSTRAINT FK_Compras_Sucursal FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID),
    CONSTRAINT FK_Compras_Empleado FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID)
);
GO

-- TABLA: Detalle de Compras
CREATE TABLE DetalleCompras (
    DetalleCompraID INT IDENTITY(1,1) PRIMARY KEY,
    CompraID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(18,2) NOT NULL,
    Subtotal AS (Cantidad * PrecioUnitario) PERSISTED,
    FechaVencimiento DATE,
    Lote VARCHAR(50),
    CONSTRAINT FK_DetalleCompras_Compra FOREIGN KEY (CompraID) REFERENCES Compras(CompraID),
    CONSTRAINT FK_DetalleCompras_Producto FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    CONSTRAINT CHK_Cantidad_Compra CHECK (Cantidad > 0)
);
GO

-- Nueva tabla de auditoría para el sistema
-- TABLA: AuditoriaAccesos
CREATE TABLE AuditoriaAccesos (
    AuditoriaID INT IDENTITY(1,1) PRIMARY KEY,
    EmpleadoID INT NOT NULL,
    Usuario VARCHAR(50) NOT NULL,
    Accion NVARCHAR(200) NOT NULL,
    Tabla NVARCHAR(50),
    RegistroID INT,
    FechaHora DATETIME DEFAULT GETDATE(),
    DireccionIP VARCHAR(50),
    Resultado VARCHAR(20), -- EXITOSO, DENEGADO
    Detalles NVARCHAR(500),
    CONSTRAINT FK_Auditoria_Empleados FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID)
);
GO

-- TABLA: Permisos por Rol
CREATE TABLE PermisosRoles (
    PermisoID INT IDENTITY(1,1) PRIMARY KEY,
    NivelAcceso INT NOT NULL,
    NombreRol NVARCHAR(50) NOT NULL,
    Modulo NVARCHAR(100) NOT NULL, -- VENTAS, COMPRAS, INVENTARIO, REPORTES, CONFIGURACION
    Permiso NVARCHAR(50) NOT NULL, -- VER, CREAR, EDITAR, ELIMINAR, APROBAR
    Activo BIT DEFAULT 1
);
GO
-- </CHANGE>

PRINT 'Tablas maestras creadas exitosamente';
GO

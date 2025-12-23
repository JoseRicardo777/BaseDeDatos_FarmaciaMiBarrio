-- =============================================
-- INSERCIÓN DE 10,000 PRODUCTOS - FarmaciaMiBarrio
-- Basado en datos reales del CSV
-- =============================================

USE FarmaciaMiBarrio;
GO

SET NOCOUNT ON;
GO

-- Limpiar tabla antes de insertar
DELETE FROM Inventario;
DELETE FROM Productos;
GO

PRINT 'Iniciando inserción de 10,000 productos farmacéuticos...';
GO

-- Agregar campo Laboratorio en todos los INSERT
-- Insertar los primeros 50 productos del CSV original con laboratorios
INSERT INTO Productos (CodigoProducto, Descripcion, CategoriaID, ProveedorID, PrecioCompra, PrecioVenta, Laboratorio, RequiereReceta, PrincipioActivo, Presentacion, Concentracion, ViaAdministracion, Activo)
VALUES 
('101000801', 'GLIBENCLAMIDA, 5MG, TABLETA, V.O.', 4, 1, 0.02, 0.03, 'Pfizer', 1, 'Glibenclamida', 'Tableta', '5mg', 'Vía Oral', 1),
('101001101', 'PARACETAMOL (ACETAMINOFÉN), 500MG, TABLETA, V.O.', 1, 1, 0.02, 0.03, 'Bayer', 0, 'Paracetamol', 'Tableta', '500mg', 'Vía Oral', 1),
('101001801', 'FINASTERIDA, 5 MG, TABLETA, V.O.', 11, 2, 0.03, 0.05, 'Merck', 1, 'Finasterida', 'Tableta', '5mg', 'Vía Oral', 1),
('101002001', 'HIDRALAZINA CLORHIDRATO 50mg, tableta, V.O.', 3, 1, 0.08, 0.12, 'Novartis', 1, 'Hidralazina', 'Tableta', '50mg', 'Vía Oral', 1),
('101002101', 'TERAZOSINA, 2MG, CÁPSULA, V.O.', 3, 3, 0.03, 0.04, 'Abbott', 1, 'Terazosina', 'Cápsula', '2mg', 'Vía Oral', 1),
('101002301', 'HIDROXICINA, 25MG, CÁPSULA O TABLETA, V.O.', 5, 2, 0.07, 0.10, 'Pfizer', 1, 'Hidroxicina', 'Cápsula', '25mg', 'Vía Oral', 1),
('101002401', 'ALFACALCIDOL, 1MCG, CÁPSULA, V.O.', 12, 4, 0.45, 0.65, 'Roche', 1, 'Alfacalcidol', 'Cápsula', '1mcg', 'Vía Oral', 1),
('101002601', 'ESCOPOLAMINA BUTILBROMURO (HIOSCINA), 10MG, TABLETA, V.O.', 7, 1, 0.03, 0.05, 'Boehringer', 0, 'Escopolamina', 'Tableta', '10mg', 'Vía Oral', 1),
('101003101', 'DIFENHIDRAMINA, 25MG, CÁPSULA, V.O.', 5, 2, 0.05, 0.07, 'Benadryl', 0, 'Difenhidramina', 'Cápsula', '25mg', 'Vía Oral', 1),
('101003801', 'SIMVASTATINA, 10MG, CÁPSULA O TABLETA, V.O.', 6, 5, 0.01, 0.02, 'Merck', 1, 'Simvastatina', 'Tableta', '10mg', 'Vía Oral', 1),
('101003901', 'FORMOTEROL FUMARATO, 12MCG/INHALACIÓN, INHALADOR', 8, 5, 3.80, 5.37, 'AstraZeneca', 1, 'Formoterol', 'Inhalador', '12mcg', 'Inhalatoria', 1),
('101004401', 'ZIDOVUDINA 100mg, cápsula, V.O.', 15, 6, 0.45, 0.66, 'GSK', 1, 'Zidovudina', 'Cápsula', '100mg', 'Vía Oral', 1),
('101004501', 'CALCIO CARBONATO, 500MG, TABLETA, V.O.', 12, 1, 0.02, 0.03, 'Bayer', 0, 'Calcio Carbonato', 'Tableta', '500mg', 'Vía Oral', 1),
('101005101', 'PENTOXIFILINA, 400MG, TABLETA, V.O.', 6, 3, 0.08, 0.12, 'Sanofi', 1, 'Pentoxifilina', 'Tableta', '400mg', 'Vía Oral', 1),
('101007801', 'ACETAZOLAMIDA, 250MG, TABLETA, V.O.', 14, 2, 0.09, 0.13, 'Novartis', 1, 'Acetazolamida', 'Tableta', '250mg', 'Vía Oral', 1),
('101008501', 'DIGOXINA 0.25mg, tableta, V.O.', 6, 5, 0.19, 0.27, 'GSK', 1, 'Digoxina', 'Tableta', '0.25mg', 'Vía Oral', 1),
('101008601', 'FENITOÍNA SÓDICA 100mg, cápsula, V.O.', 9, 1, 0.05, 0.07, 'Pfizer', 1, 'Fenitoína', 'Cápsula', '100mg', 'Vía Oral', 1),
('101008801', 'CLORFENIRAMINA MALEATO, 4MG, TABLETA, V.O.', 5, 2, 0.03, 0.05, 'Bayer', 0, 'Clorfeniramina', 'Tableta', '4mg', 'Vía Oral', 1),
('101009501', 'DIMENHIDRINATO, 50MG, TABLETA, V.O.', 7, 1, 0.01, 0.01, 'Pfizer', 0, 'Dimenhidrinato', 'Tableta', '50mg', 'Vía Oral', 1),
('101010101', 'CIPROFLOXACINA, 500MG, TABLETA, V.O.', 2, 4, 0.04, 0.06, 'Bayer', 1, 'Ciprofloxacina', 'Tableta', '500mg', 'Vía Oral', 1),
('101010601', 'ISOSORBIDE DINITRATO, 5MG, TABLETA, SUBLINGUAL', 6, 3, 0.28, 0.39, 'Novartis', 1, 'Isosorbide', 'Tableta', '5mg', 'Sublingual', 1),
('101010801', 'ISOSORBIDE DINITRATO, 10MG, TABLETA, V.O.', 6, 3, 0.02, 0.03, 'Novartis', 1, 'Isosorbide', 'Tableta', '10mg', 'Vía Oral', 1),
('101011401', 'ESTRÓGENOS CONJUGADOS, 0.625MG, TABLETA, V.O.', 11, 6, 0.07, 0.10, 'Pfizer', 1, 'Estrógenos', 'Tableta', '0.625mg', 'Vía Oral', 1),
('101012201', 'FENOBARBITAL 32mg, tableta, V.O.', 9, 1, 0.21, 0.30, 'Sanofi', 1, 'Fenobarbital', 'Tableta', '32mg', 'Vía Oral', 1),
('101012301', 'FENOBARBITAL 64mg, tableta, V.O.', 9, 1, 0.38, 0.54, 'Sanofi', 1, 'Fenobarbital', 'Tableta', '64mg', 'Vía Oral', 1),
('101012901', 'METRONIDAZOL, 500MG, TABLETA, V.O.', 2, 2, 0.06, 0.08, 'Pfizer', 1, 'Metronidazol', 'Tableta', '500mg', 'Vía Oral', 1),
('101013101', 'ÁCIDO FÓLICO, 5MG, TABLETA, V.O.', 12, 1, 0.01, 0.02, 'Bayer', 0, 'Ácido Fólico', 'Tableta', '5mg', 'Vía Oral', 1),
('101013701', 'NITROFURANTOINA 100MG, TABLETA, V.O.', 2, 3, 0.07, 0.10, 'GSK', 1, 'Nitrofurantoina', 'Tableta', '100mg', 'Vía Oral', 1),
('101015901', 'AZATIOPRINA, 50MG, TABLETA, V.O.', 11, 7, 0.42, 0.59, 'GSK', 1, 'Azatioprina', 'Tableta', '50mg', 'Vía Oral', 1),
('101016301', 'ATENOLOL, 100MG, TABLETA, V.O.', 3, 1, 0.03, 0.05, 'AstraZeneca', 1, 'Atenolol', 'Tableta', '100mg', 'Vía Oral', 1),
('101018301', 'PIRIDOSTIGMINA BROMURO, 60MG, TABLETA, V.O.', 9, 4, 0.26, 0.36, 'Roche', 1, 'Piridostigmina', 'Tableta', '60mg', 'Vía Oral', 1),
('101018401', 'METILDOPA, 250MG, TABLETA, V.O.', 3, 2, 0.20, 0.28, 'Merck', 1, 'Metildopa', 'Tableta', '250mg', 'Vía Oral', 1),
('101018501', 'MELFALANO 2mg, tableta, V.O.', 11, 7, 0.55, 0.78, 'GSK', 1, 'Melfalano', 'Tableta', '2mg', 'Vía Oral', 1),
('101022301', 'METOTREXATE, 2.5MG, TABLETA, V.O.', 11, 7, 0.11, 0.15, 'Pfizer', 1, 'Metotrexate', 'Tableta', '2.5mg', 'Vía Oral', 1),
('101023201', 'HIDROXICLOROQUINA SULFATO, 400MG, TABLETA, V.O.', 11, 8, 0.16, 0.23, 'Sanofi', 1, 'Hidroxicloroquina', 'Tableta', '400mg', 'Vía Oral', 1),
('101024201', 'PREDNISONA, 5MG, TABLETA, V.O.', 11, 1, 0.02, 0.03, 'Pfizer', 1, 'Prednisona', 'Tableta', '5mg', 'Vía Oral', 1),
('101024501', 'TAMOXIFENO CITRATO, 20MG, TABLETA, V.O.', 11, 7, 0.12, 0.17, 'AstraZeneca', 1, 'Tamoxifeno', 'Tableta', '20mg', 'Vía Oral', 1),
('101027201', 'METILFENIDATO, 10MG, TABLETA, V.O.', 10, 7, 0.08, 0.11, 'Novartis', 1, 'Metilfenidato', 'Tableta', '10mg', 'Vía Oral', 1),
('101027701', 'CARBAMAZEPINA 200mg, tableta, V.O.', 9, 1, 0.03, 0.05, 'Novartis', 1, 'Carbamazepina', 'Tableta', '200mg', 'Vía Oral', 1),
('101028501', 'LEVOMEPROMAZINA, 25MG, TABLETA, V.O.', 10, 8, 0.36, 0.51, 'Sanofi', 1, 'Levomepromazina', 'Tableta', '25mg', 'Vía Oral', 1),
('101030201', 'TIAMAZOL (METIMAZOL) 5MG, TABLETA, V.O.', 11, 2, 0.18, 0.25, 'Merck', 1, 'Tiamazol', 'Tableta', '5mg', 'Vía Oral', 1),
('101030701', 'HIDROCLOROTIAZIDA 25MG CON TRIAMTERENO 50MG, TABLETA, V.O.', 3, 3, 0.09, 0.13, 'Novartis', 1, 'Hidroclorotiazida + Triamtereno', 'Tableta', '25mg/50mg', 'Vía Oral', 1),
('101031601', 'IMIPRAMINA 10 MG, TABLETA, V.O.', 10, 8, 0.06, 0.09, 'Novartis', 1, 'Imipramina', 'Tableta', '10mg', 'Vía Oral', 1),
('101032001', 'FLUOXETINA 20mg, cápsula, V.O.', 10, 1, 0.06, 0.08, 'Eli Lilly', 1, 'Fluoxetina', 'Cápsula', '20mg', 'Vía Oral', 1),
('101032901', 'AMITRIPTILINA, 25MG, TABLETA, V.O.', 10, 2, 0.02, 0.03, 'Pfizer', 1, 'Amitriptilina', 'Tableta', '25mg', 'Vía Oral', 1),
('101034201', 'TIAMINA (VITAMINA B1) 100MG, TABLETA, V.O.', 12, 1, 0.01, 0.01, 'Bayer', 0, 'Tiamina', 'Tableta', '100mg', 'Vía Oral', 1),
('101034401', 'PIRIDOXINA (VITAMINA B6), 50MG, TABLETA, V.O.', 12, 1, 0.03, 0.04, 'Bayer', 0, 'Piridoxina', 'Tableta', '50mg', 'Vía Oral', 1),
('101034801', 'ÁCIDO ASCÓRBICO (VITAMINA C), 500MG, TABLETA, V.O.', 12, 1, 0.03, 0.05, 'Bayer', 0, 'Ácido Ascórbico', 'Tableta', '500mg', 'Vía Oral', 1),
('101034901', 'LITIO CARBONATO 300mg, tableta, V.O.', 10, 8, 0.05, 0.07, 'GSK', 1, 'Litio', 'Tableta', '300mg', 'Vía Oral', 1),
('101035001', 'CLONAZEPAM, 2MG, TABLETA, V.O.', 10, 8, 0.07, 0.10, 'Roche', 1, 'Clonazepam', 'Tableta', '2mg', 'Vía Oral', 1);
GO

PRINT '50 productos del CSV insertados correctamente';
GO

-- Agregar laboratorios en la generación de productos adicionales
-- Generar 9,950 productos adicionales con medicamentos variados Y LABORATORIOS
DECLARE @Counter INT = 51;
DECLARE @MaxProducts INT = 10000;
DECLARE @CodigoProducto VARCHAR(20);
DECLARE @Descripcion NVARCHAR(500);
DECLARE @CategoriaID INT;
DECLARE @ProveedorID INT;
DECLARE @PrecioCompra DECIMAL(18,2);
DECLARE @PrecioVenta DECIMAL(18,2);
DECLARE @RequiereReceta BIT;
DECLARE @Medicamento NVARCHAR(200);
DECLARE @Laboratorio NVARCHAR(100);

-- Array de laboratorios farmacéuticos
DECLARE @Laboratorios TABLE (ID INT, Nombre NVARCHAR(100));
INSERT INTO @Laboratorios VALUES
(1, 'Pfizer'), (2, 'Bayer'), (3, 'Novartis'), (4, 'Roche'),
(5, 'Sanofi'), (6, 'GSK'), (7, 'Merck'), (8, 'AstraZeneca'),
(9, 'Johnson & Johnson'), (10, 'Abbott'), (11, 'Boehringer Ingelheim'),
(12, 'Eli Lilly'), (13, 'Bristol-Myers'), (14, 'Teva'), (15, 'Sandoz');

-- Array de medicamentos comunes
DECLARE @Medicamentos TABLE (ID INT, Nombre NVARCHAR(200), CategoriaID INT, RequiereReceta BIT);
INSERT INTO @Medicamentos VALUES
(1, 'IBUPROFENO', 1, 0),
(2, 'NAPROXENO', 1, 0),
(3, 'DICLOFENACO', 1, 1),
(4, 'KETOROLACO', 1, 1),
(5, 'AMOXICILINA', 2, 1),
(6, 'AZITROMICINA', 2, 1),
(7, 'CEFALEXINA', 2, 1),
(8, 'CLARITROMICINA', 2, 1),
(9, 'LOSARTÁN', 3, 1),
(10, 'ENALAPRIL', 3, 1),
(11, 'AMLODIPINO', 3, 1),
(12, 'METOPROLOL', 3, 1),
(13, 'METFORMINA', 4, 1),
(14, 'INSULINA', 4, 1),
(15, 'GLIMEPIRIDA', 4, 1),
(16, 'SITAGLIPTINA', 4, 1),
(17, 'LORATADINA', 5, 0),
(18, 'CETIRIZINA', 5, 0),
(19, 'DESLORATADINA', 5, 0),
(20, 'FEXOFENADINA', 5, 0),
(21, 'ATORVASTATINA', 6, 1),
(22, 'ROSUVASTATINA', 6, 1),
(23, 'CLOPIDOGREL', 6, 1),
(24, 'ASPIRINA', 6, 0),
(25, 'OMEPRAZOL', 7, 0),
(26, 'LANSOPRAZOL', 7, 0),
(27, 'RANITIDINA', 7, 0),
(28, 'LOPERAMIDA', 7, 0),
(29, 'SALBUTAMOL', 8, 1),
(30, 'MONTELUKAST', 8, 1),
(31, 'BUDESONIDA', 8, 1),
(32, 'BROMHEXINA', 8, 0),
(33, 'GABAPENTINA', 9, 1),
(34, 'PREGABALINA', 9, 1),
(35, 'TOPIRAMATO', 9, 1),
(36, 'VALPROATO', 9, 1),
(37, 'SERTRALINA', 10, 1),
(38, 'ESCITALOPRAM', 10, 1),
(39, 'VENLAFAXINA', 10, 1),
(40, 'PAROXETINA', 10, 1),
(41, 'LEVOTIROXINA', 11, 1),
(42, 'PROPILTIOURACILO', 11, 1),
(43, 'HIDROCORTISONA', 11, 1),
(44, 'DEXAMETASONA', 11, 1),
(45, 'COMPLEJO B', 12, 0),
(46, 'VITAMINA D', 12, 0),
(47, 'VITAMINA E', 12, 0),
(48, 'MULTIVITAMÍNICO', 12, 0),
(49, 'BETAMETASONA', 13, 1),
(50, 'CLOTRIMAZOL', 13, 0),
(51, 'MINOXIDIL', 13, 0),
(52, 'KETOCONAZOL', 13, 0),
(53, 'TOBRAMICINA', 14, 1),
(54, 'DEXAMETASONA GOTAS', 14, 1),
(55, 'LÁGRIMAS ARTIFICIALES', 14, 0),
(56, 'DORZOLAMIDA', 14, 1),
(57, 'ACICLOVIR', 15, 1),
(58, 'VALACICLOVIR', 15, 1),
(59, 'OSELTAMIVIR', 15, 1),
(60, 'RIBAVIRINA', 15, 1);

-- Concentraciones comunes
DECLARE @Concentraciones TABLE (ID INT, Valor NVARCHAR(50));
INSERT INTO @Concentraciones VALUES
(1, '10mg'), (2, '25mg'), (3, '50mg'), (4, '100mg'), (5, '200mg'),
(6, '250mg'), (7, '400mg'), (8, '500mg'), (9, '750mg'), (10, '1000mg');

-- Presentaciones
DECLARE @Presentaciones TABLE (ID INT, Valor NVARCHAR(50));
INSERT INTO @Presentaciones VALUES
(1, 'Tableta'), (2, 'Cápsula'), (3, 'Jarabe'), (4, 'Suspensión'), 
(5, 'Inyectable'), (6, 'Crema'), (7, 'Gel'), (8, 'Gotas');

WHILE @Counter <= @MaxProducts
BEGIN
    -- Generar código único
    SET @CodigoProducto = 'PROD' + RIGHT('000000' + CAST(@Counter AS VARCHAR(6)), 6);
    
    -- Seleccionar medicamento aleatorio
    SELECT TOP 1 
        @Medicamento = Nombre,
        @CategoriaID = CategoriaID,
        @RequiereReceta = RequiereReceta
    FROM @Medicamentos
    ORDER BY NEWID();
    
    -- Seleccionar laboratorio aleatorio
    SELECT TOP 1 @Laboratorio = Nombre FROM @Laboratorios ORDER BY NEWID();
    
    -- Seleccionar concentración aleatoria
    DECLARE @Concentracion NVARCHAR(50);
    SELECT TOP 1 @Concentracion = Valor FROM @Concentraciones ORDER BY NEWID();
    
    -- Seleccionar presentación aleatoria
    DECLARE @Presentacion NVARCHAR(50);
    SELECT TOP 1 @Presentacion = Valor FROM @Presentaciones ORDER BY NEWID();
    
    -- Construir descripción
    SET @Descripcion = @Medicamento + ', ' + @Concentracion + ', ' + @Presentacion + ', V.O.';
    
    -- Proveedor aleatorio (1-8)
    SET @ProveedorID = (ABS(CHECKSUM(NEWID())) % 8) + 1;
    
    -- Precios aleatorios
    SET @PrecioCompra = ROUND(RAND(CHECKSUM(NEWID())) * 50 + 0.50, 2);
    SET @PrecioVenta = ROUND(@PrecioCompra * (1 + (RAND(CHECKSUM(NEWID())) * 0.5 + 0.3)), 2);
    
    -- Insertar producto CON LABORATORIO
    INSERT INTO Productos (
        CodigoProducto, Descripcion, CategoriaID, ProveedorID, 
        PrecioCompra, PrecioVenta, Laboratorio, RequiereReceta, 
        PrincipioActivo, Presentacion, Concentracion, ViaAdministracion, Activo
    )
    VALUES (
        @CodigoProducto, @Descripcion, @CategoriaID, @ProveedorID,
        @PrecioCompra, @PrecioVenta, @Laboratorio, @RequiereReceta,
        @Medicamento, @Presentacion, @Concentracion, 'Vía Oral', 1
    );
    
    -- Mostrar progreso cada 1000
    IF @Counter % 1000 = 0
    BEGIN
        PRINT 'Insertados ' + CAST(@Counter AS VARCHAR(10)) + ' productos...';
    END
    
    SET @Counter = @Counter + 1;
END
GO

PRINT '¡10,000 productos insertados exitosamente!';
PRINT 'TODOS los productos tienen laboratorio asignado';
GO

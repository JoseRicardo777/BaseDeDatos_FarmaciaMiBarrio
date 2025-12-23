-- =============================================
-- BASE DE DATOS EMPRESARIAL: FarmaciaMiBarrio
-- SQL Server Management Studio 20
-- Compatible con SSIS y Power BI Desktop
-- =============================================

USE master;
GO

-- Eliminar base de datos si existe
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'FarmaciaMiBarrio')
BEGIN
    ALTER DATABASE FarmaciaMiBarrio SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE FarmaciaMiBarrio;
END
GO

-- Crear base de datos sin especificar rutas (usa las predeterminadas del sistema)
CREATE DATABASE FarmaciaMiBarrio;
GO

USE FarmaciaMiBarrio;
GO

PRINT 'Base de datos FarmaciaMiBarrio creada exitosamente';
GO


/************************************************************************
    Data Warehouse Setup Script
    Purpose:
        Initializes the DataWarehouse database for a new environment by dropping
        any existing database with the same name and recreating it cleanly.
        Creates the required bronze, silver, and gold schemas for the data lakehouse
        architecture used by the project.

    Warning:
        This script is destructive. It permanently drops the DataWarehouse database
        if it already exists, including all data, objects, and permissions within it.
        Execute only in a development, test, or controlled environment where data loss
        is acceptable and approved.

    Repository note:
        Intended for use in GitHub repositories as a setup/bootstrap script for the
        database environment.
************************************************************************/

USE master;
GO

-- DROP AND RECREATE THE 'DataWarehouse' DATABASE
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

--CREATE THE 'DataWarehouse' DATABASE
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--CREATE SCHEMAS

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO

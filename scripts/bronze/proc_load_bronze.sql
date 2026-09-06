/*
================================================================================
Procedure: bronze.load_bronze
Purpose:
    Loads raw CRM and ERP CSV data into the Bronze layer staging tables.

Process:
    - Truncates each Bronze table before loading.
    - Imports CSV files using BULK INSERT.
    - Prints progress and load duration for each dataset.
    - Captures and rethrows errors for monitoring and troubleshooting.

Data Sources:
    - CRM: customer, sales, and product information.
    - ERP: customer, location, and product category information.

Requirements:
    - SQL Server must have access to /var/opt/mssql/data/datasets/.
    - Target Bronze tables must already exist.

Usage Example:
  EXEC bronze.load_bronze;
================================================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;
    Begin TRY
        PRINT '================================================================================';
        PRINT 'Loading Bronze Layer Data';
        PRINT '================================================================================';

        PRINT '--------------------------------------------------------------------------------';
        PRINT 'Loading CRM Data';
        PRINT '--------------------------------------------------------------------------------';
        SET @start_time = GETDATE();
        PRINT '>>TRUNCATING bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>>INSERTING bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM '/var/opt/mssql/data/datasets/source_crm/cust_info.csv'
        WITH (
            FIELDTERMINATOR = ',',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration:   ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>>TRUNCATING bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>>INSERTING bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM '/var/opt/mssql/data/datasets/source_crm/sales_details.csv'
        WITH (
            FIELDTERMINATOR = ',',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration:   ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>>TRUNCATING bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>>INSERTING bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM '/var/opt/mssql/data/datasets/source_crm/prd_info.csv'
        WITH (
            FIELDTERMINATOR = ',',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration:   ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------------------------------------';

        PRINT '--------------------------------------------------------------------------------';
        PRINT 'Loading ERP Data';
        PRINT '--------------------------------------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>>TRUNCATING bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>>INSERTING bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM '/var/opt/mssql/data/datasets/source_erp/CUST_AZ12.csv'
        WITH (
            FIELDTERMINATOR = ',',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration:   ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------------------------------------';

        
        SET @start_time = GETDATE();
        PRINT '>>TRUNCATING bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>>INSERTING bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM '/var/opt/mssql/data/datasets/source_erp/LOC_A101.csv'
        WITH (
            FIELDTERMINATOR = ',',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration:   ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------------------------------------';


        SET @start_time = GETDATE();
        PRINT '>>TRUNCATING bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>>INSERTING bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/var/opt/mssql/data/datasets/source_erp/PX_CAT_G1V2.csv'
        WITH (
            FIELDTERMINATOR = ',',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration:   ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------------------------------------';
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while loading Bronze Layer Data';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        THROW;
    END CATCH
END;

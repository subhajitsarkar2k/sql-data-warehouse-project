
/*
Quality Checks for Silver Layer
==================================================================================
-- Data Quality Validation Queries
-- A collection of SQL checks for CRM and ERP datasets, covering duplicate and
-- null identifiers, invalid values, unwanted whitespace, data consistency,
-- date ranges and ordering, sales calculations, and categorical value
-- standardization. Includes exploratory queries for inspecting source data
-- anomalies before and after cleaning.
==================================================================================
*/

--Checks for Unwanted Spaces
--Expectation: No Results


SELECT 
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL


SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost = 0 OR prd_cost IS NULL

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM (cst_lastname)


--Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info


--Check dates

SELECT
NULLIF(sls_due_dt,0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101

SELECT
*
FROM bronze.crm_sales_details
WHERE sls_due_dt > sls_ship_dt OR sls_order_dt > sls_due_dt


SELECT
*
FROM silver.crm_sales_details
WHERE sls_sales IS NULL OR sls_quantity * sls_price IS NULL
OR sls_Sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
OR sls_sales != sls_quantity * sls_price

SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

SELECT DISTINCT gen FROM silver.erp_cust_az12

SELECT DISTINCT gen
FROM bronze.erp_cust_az12;

SELECT 
    CASE 
        WHEN UPPER(LTRIM(RTRIM(gen))) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(LTRIM(RTRIM(gen))) IN ('M', 'MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gen
FROM bronze.erp_cust_az12;

SELECT DISTINCT
    gen,
    UPPER(TRIM(gen)) AS cleaned_gen,
    CASE
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        ELSE 'n/a'
    END AS result
FROM bronze.erp_cust_az12;

SELECT DISTINCT
    gen,
    LEN(gen) AS len,
    DATALENGTH(gen) AS bytes,
    ASCII(RIGHT(gen, 1)) AS last_char_ascii
FROM bronze.erp_cust_az12
WHERE gen IS NOT NULL;



SELECT 
    CASE 
        WHEN UPPER(TRIM(REPLACE(gen, CHAR(13), ''))) IN ('F', 'FEMALE') 
            THEN 'Female'
        WHEN UPPER(TRIM(REPLACE(gen, CHAR(13), ''))) IN ('M', 'MALE') 
            THEN 'Male'
        ELSE 'n/a'
    END AS gen
FROM bronze.erp_cust_az12;



SELECT DISTINCT
*
FROM silver.erp_loc_a101


SELECT DISTINCT
    maintenance,
    ASCII(RIGHT(maintenance, 1)) AS last_char_ascii
FROM bronze.erp_px_cat_g1v2;

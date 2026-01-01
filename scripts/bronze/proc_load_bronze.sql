/*
========================================================
Stored Procedure: Allows to load use the Bronze Layer
========================================================
The stored procedure loads the data from the external CSV files to the 'bronze' schema.

It is used to truncate the tables before loading the data, and then using BULK INSERT to load
the data into the tables. 

*/
EXEC bronze.load_bronze;
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT '==============================';
		PRINT 'Loading the Bronze Layer';
		PRINT '------------------------------';
		PRINT 'Print the CRM Tables';
		PRINT '------------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table 1 (6 Total)';

		TRUNCATE TABLE bronze.crm_cust_info;
	
		PRINT '>> Inserting Table 1 (6 Total)';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Personal Projects and References\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table 2';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Table 2';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Personal Projects and References\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
	    SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table 3';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Table 3';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Personal Projects and References\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------';

		PRINT '------------------------------';
		PRINT 'Print the ERP Tables';
		PRINT '------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table 4';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Table 4';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Personal Projects and References\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

	    SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table 5';

		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Table 5';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Personal Projects and References\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table 6';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Table 6';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Personal Projects and References\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------';
		SET @batch_end_time = GETDATE();
		
		PRINT '==============================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT ' - Total Load Duration: '+ CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '==============================';
	END TRY
	BEGIN CATCH
		PRINT '==============================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '==============================';

	END CATCH
END

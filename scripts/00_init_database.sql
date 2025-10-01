/*
================================================================================
CREATE DATABASE AND SCHEMAS
================================================================================
Script Purpose:
       This script creates a new database called 'daily_grind_analytics' after checking if it already exists.
	   If the database exists, it will be dropped and recreated. Additionally, the script sets up the 
	   schemas within the database: 'sales'.
	   This script also creates tables in the 'sales' schema, dropping existing tables 
	   if they already exist. Run this script to re-define the DDL structure of 
	   'sales' Tables.

	  WARNING !!!
          Running this script will drop the entire 'daily_grind_analytics' database if it exists. 
	  The entire database and all its contents will consequently be deleted (permanently) without prompting for confirmation.
	  Proceed with caution and ensure you have proper backups before running this script.
*/



USE master;
GO

--drop and recreate the database 'daily_grind_analytics'
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'daily_grind_analytics')
BEGIN
      ALTER DATABASE daily_grind_analytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	  DROP DATABASE daily_grind_analytics;
END;
GO

-- create the 'daily_grind_analytics' database 
CREATE DATABASE daily_grind_analytics;
GO


--switch to the newly created 'daily_grind_analytics' database 
USE daily_grind_analytics;
GO


--create schemas\
CREATE SCHEMA sales;
GO

--create the 'sale.coffee_shop_data' table
IF OBJECT_ID ('sales.coffee_shop_data' ,  'U') IS NOT NULL
    DROP TABLE sales.coffee_shop_data;
CREATE TABLE sales.coffee_shop_data (
		dates			DATE,
		datetimes	        DATETIME,
		hour_of_day		INT,
		cash_type		NVARCHAR(10),
		card			NCHAR(19),
		sales		        FLOAT,
		coffee_name		NVARCHAR(20),
		time_of_day		NVARCHAR(20),
		weekdays		NCHAR(3),
		month_name		NCHAR(3),
		weekday_sort	        INT,
		month_sort		INT
);
GO

TRUNCATE TABLE sales.coffee_shop_data;
GO

BULK INSERT sales.coffee_shop_data
FROM 'C:\projects\personal\tableua\local_coffee_shop_dashboard\datasets\coffee_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO




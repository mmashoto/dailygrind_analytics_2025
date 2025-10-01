
/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Retrieve a list of unique cash types the customers use to purchase their 
coffee with

SELECT DISTINCT 
    cash_type 
FROM sales.coffee_shop_data
ORDER BY 1;

-- Retrieve a list of unique coffee offerings(types of coffee drinks)
SELECT DISTINCT 
    coffee_name
FROM sales.coffee_shop_data
ORDER BY 1;

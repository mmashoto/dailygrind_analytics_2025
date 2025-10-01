/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages, ATV (Average Transaction Value) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT SUM(sales)                   AS total_sales 
FROM sales.coffee_shop_data;

-- Find the Total number of Orders
SELECT COUNT(datetimes)             AS total_orders FROM sales.coffee_shop_data;
SELECT COUNT(DISTINCT (datetimes))  AS total_orders FROM sales.coffee_shop_data;

-- Find the total number of products
SELECT COUNT(DISTINCT(coffee_name)) AS total_products FROM sales.coffee_shop_data;

-- Find the Total number of Customers who use cards and cash
SELECT
cash_type,
COUNT(cash_type)                    AS number_of_transactions
FROM sales.coffee_shop_data
GROUP BY cash_type;

-- Find the ATV(Average Transaction Value)
WITH average_transation_value AS (
   SELECT 
         SUM(sales)                 AS total_sum,
         COUNT(datetimes)           AS number_of_transations
   FROM sales.coffee_shop_data
)
SELECT  ROUND( total_sum/ number_of_transations, 2)   AS ATV
FROM average_transation_value

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, ROUND(SUM(sales), 2) AS measure_value    FROM sales.coffee_shop_data
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT datetimes)                     FROM sales.coffee_shop_data
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT coffee_name)                 FROM sales.coffee_shop_data
UNION ALL
SELECT 'Average Transaction Value', ROUND(SUM(sales) / COUNT(datetimes), 2)    FROM sales.coffee_shop_data



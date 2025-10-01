/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/
                   
-- Find the total sales by cash type
SELECT 
     cash_type,
     SUM(sales)          AS total_sales
FROM sales.coffee_shop_data
GROUP BY cash_type
ORDER BY 2 DESC

--Find the total sale by coffee_type
SELECT 
     coffee_name,
     ROUND(SUM(sales),0) AS total_sales
FROM sales.coffee_shop_data
GROUP BY coffee_name
ORDER BY 2 DESC

-- check if multiple orders where made at the same time
SELECT *
FROM
  (SELECT datetimes, COUNT(datetimes) OVER(PARTITION BY datetimes) AS check_pk
  FROM sales.coffee_shop_data) AS t
WHERE check_pk > 1
-- this data suggests that customers purchasing behavior is characterized by single-item transactions.





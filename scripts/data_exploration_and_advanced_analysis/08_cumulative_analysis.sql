/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per year
-- and the running total of sales over time 
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM
(
    SELECT 
        DATETRUNC(year, dates)		        AS order_date,
        ROUND(SUM(sales),0)			AS total_sales
    FROM sales.coffee_shop_data
    WHERE dates IS NOT NULL
    GROUP BY DATETRUNC(year, dates)
) t
-- Calculate the total sales per month 
-- and the running total of sales over time 
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM
(
    SELECT 
        DATETRUNC(month, dates)		        AS order_date,
        ROUND(SUM(sales), 0)	                AS total_sales
    FROM sales.coffee_shop_data
    WHERE dates IS NOT NULL
    GROUP BY DATETRUNC(month, dates)
) t
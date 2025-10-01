/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products generating the highest sales?
-- Simple Ranking
SELECT TOP 5
    coffee_name,
    ROUND(SUM(sales),0) AS total_sales
FROM sales.coffee_shop_data
GROUP BY coffee_name
ORDER BY total_sales DESC;



-- Complex but flexibly ranking using window functions
SELECT *
FROM (
  SELECT TOP 4
        coffee_name,
	RANK() OVER (ORDER BY SUM(sales) DESC) AS rank_products,
        ROUND(SUM(sales),0) AS total_sales
  FROM sales.coffee_shop_data
  GROUP BY coffee_name
) AS ranked_products
WHERE rank_products <= 4;

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 4
    coffee_name,
    ROUND(SUM(sales),0) AS total_sales
FROM sales.coffee_shop_data
GROUP BY coffee_name
ORDER BY total_sales ;


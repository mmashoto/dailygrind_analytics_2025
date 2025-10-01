/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT 
    MIN(dates) AS first_order_date,
    MAX(dates) AS last_order_date,
    DATEDIFF(MONTH, MIN(dates), MAX(dates)) AS order_range_months
FROM sales.coffee_shop_data;


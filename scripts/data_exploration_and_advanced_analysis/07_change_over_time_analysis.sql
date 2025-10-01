/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions
SELECT
	    YEAR(dates)		                  AS order_year,
	    MONTH(dates)		              AS order_month,
	    ROUND(SUM(sales), 0)              AS 'total_sales(in rands)'
FROM sales.coffee_shop_data
WHERE dates IS NOT NULL
GROUP BY YEAR(dates), MONTH(dates)
ORDER BY YEAR(dates), MONTH(dates);

-- DATETRUNC()
SELECT
		 DATETRUNC(month, dates)          AS order_date,
		 SUM(sales)		                  AS total_sales
FROM sales.coffee_shop_data
WHERE dates IS NOT NULL
GROUP BY DATETRUNC(month, dates)
ORDER BY DATETRUNC(month, dates);

-- FORMAT()
SELECT
    FORMAT(dates, 'yyyy-MMM')             AS order_date,
    SUM(sales)				              AS total_sales
FROM sales.coffee_shop_data
WHERE dates IS NOT NULL
GROUP BY FORMAT(dates, 'yyyy-MMM')
ORDER BY FORMAT(dates, 'yyyy-MMM');

/*
WEEKLY SALES ANALYSIS
=========================================================================
1. Weekly sales trends
2. Top 5 performing weeks in each year (with and without cte)
3. Average weekly sales 
4. Weekly growth rate -- (performance analysis)
*/

--1.  Weekly sales trends
SELECT 
	    MONTH(dates)					AS order_month,
		FORMAT(dates, 'MMM')			AS order_month_name,
		DATEPART(wk, dates)				AS order_week,
		ROUND(SUM(sales), 0)			AS total_sales
FROM sales.coffee_shop_data
WHERE dates IS NOT NULL
GROUP BY MONTH(dates), FORMAT(dates, 'MMM'), DATEPART(wk, dates)
ORDER BY MONTH(dates),FORMAT(dates, 'MMM'), DATEPART(wk, dates) DESC


--2. Top performing week in each month
-- (a) with cte 
WITH weekly_sales  AS (
		SELECT  
				YEAR(dates)				AS order_year,
--				FORMAT(dates, 'MMM')	AS order_month_name,
				MONTH(dates)			AS order_month,
				DATEPART(wk, dates)		AS week_of_the_year,
				SUM(sales)				AS total_sales,
				ROW_NUMBER()  OVER(PARTITION BY YEAR(dates),  MONTH(dates)  ORDER BY SUM(sales)) AS weekly_sales_rank
		FROM sales.coffee_shop_data
		GROUP BY  YEAR(dates), MONTH(dates), DATEPART(wk, dates)
) 
SELECT order_year, order_month, week_of_the_year, total_sales
FROM  weekly_sales
WHERE weekly_sales_rank = 1;


-- (b)without cte
SELECT TOP 5
		YEAR(dates)					    AS order_year,
--	    MONTH(dates)					AS order_month,
		FORMAT(dates, 'MMM')			AS order_month_name,
		DATEPART(wk, dates)				AS order_week,
		ROUND(SUM(sales), 0)			AS total_sales
FROM	sales.coffee_shop_data
WHERE	dates IS NOT NULL
GROUP BY YEAR(dates),FORMAT(dates, 'MMM'), DATEPART(wk, dates)
ORDER BY total_sales DESC


--3. Average weekly sales
SELECT 
     ROUND(AVG(total_sales), 0)		    AS avg_weekly_sales
FROM(
	    SELECT 
				DATEPART(wk, dates)	    AS order_week,
				SUM(sales)              AS total_sales
		FROM sales.coffee_shop_data
		GROUP BY DATEPART(wk, dates)
		
) AS t
--4. Weekly sales growth
WITH weekly_sales_growth AS (
			SELECT 
					YEAR(dates)				AS order_year,
					MONTH(dates)			AS order_month,
					FORMAT(dates, 'MMM')	AS month_name,
					DATEPART(wk, dates)		AS order_week,
					ROUND(SUM(sales), 0)	AS total_sales,
					(ROUND(((SUM(sales) - LAG(SUM(sales)) OVER(ORDER BY YEAR(dates),MONTH(dates), DATEPART(wk, dates)))  / LAG(SUM(sales)) OVER(ORDER BY YEAR(dates), MONTH(dates), DATEPART(wk, dates)) ),2))*100 AS weekly_growth_rates
			FROM	sales.coffee_shop_data
			WHERE	dates IS NOT NULL
			GROUP BY YEAR(dates), MONTH(dates), FORMAT(dates, 'MMM') ,DATEPART(wk, dates)
) 
SELECT order_year, order_month, order_week, total_sales, weekly_growth_rates
FROM weekly_sales_growth

/*
MONTHLY SALES ANALYSIS
=========================================================================
1. Monthly sales trends
2. Average monthly sales
2. Top 3 performing months in each year
3. Weekly patterns and trends of the top performing months
4. Coffee type that contributed to the most sales 
*/

--1. Monthly sales trends 
SELECT
		YEAR(dates)							AS order_year,
	    MONTH(dates)					    AS order_month,
	    ROUND(SUM(sales), 0)			    AS 'total_sales(in rands)'
FROM	sales.coffee_shop_data
WHERE	dates IS NOT NULL
GROUP BY YEAR(dates), MONTH(dates)
ORDER BY YEAR(dates), MONTH(dates);
-- 2. Average monthly sales
SELECT 
	    ROUND(AVG(total_sales), 0)		   AS avg_monthly_sales
FROM(
		SELECT 
				MONTH(dates)			   AS order_month,
				SUM(sales)                 AS total_sales
		FROM sales.coffee_shop_data
		GROUP BY MONTH(dates)
		
) AS t

-- 3. Top 3 performing months in each year
WITH monthly_sales  AS (
		SELECT  
				YEAR(dates)				   AS order_year,
				FORMAT(dates, 'MMM')       AS order_month_abbr,
				MONTH(dates)		       AS order_month,
				ROUND(SUM(sales),0)			AS total_sales,
				ROW_NUMBER()  OVER(PARTITION BY YEAR(dates) ORDER BY SUM(sales) DESC) AS monthly_sales_rank
		FROM sales.coffee_shop_data
		GROUP BY  YEAR(dates), MONTH(dates),FORMAT(dates, 'MMM') 
) 
SELECT	order_year, order_month_abbr, order_month,total_sales, monthly_sales_rank
FROM	monthly_sales
WHERE	monthly_sales_rank <= 3 


-- 4. Weekly patterns and trends of the top performing months
WITH weekly_sales  AS (
		SELECT  
				YEAR(dates)			 AS year,
--				FORMAT(dates, 'MMM') AS month,
				MONTH(dates)		 AS month,
				DATEPART(wk, dates)  AS week_of_the_year,
				SUM(sales)			 AS total_sales
		FROM sales.coffee_shop_data
		GROUP BY  YEAR(dates), MONTH(dates), DATEPART(wk, dates)
) 
SELECT year, month, week_of_the_year, total_sales
FROM  weekly_sales
WHERE month IN (  10,9,5) 

-- 5. Top 4 coffee names that contributed to the most sales 
WITH weekly_sales  AS (
		SELECT  
				YEAR(dates)			AS year,
--				FORMAT(dates, 'MMM') AS month,
				MONTH(dates)		AS month,
				SUM(sales)			AS total_sales,
				coffee_name,
				ROW_NUMBER()  OVER(PARTITION BY YEAR(dates), MONTH(dates)  ORDER BY SUM(sales) DESC) AS coffee_name_sales_rank
		FROM sales.coffee_shop_data
		GROUP BY  YEAR(dates), MONTH(dates), coffee_name
) 
SELECT year, month, total_sales,coffee_name, coffee_name_sales_rank
FROM  weekly_sales
WHERE month IN (  10,9,5) and coffee_name_sales_rank <=4



--DAILY SALES ANALYSIS 
-- =========================================================================
-- total sales by hour of the day and for all the months and years 
SELECT 
	YEAR(dates)							AS year,
	FORMAT(datetimes, 'MMMM')			AS month,
	FORMAT(datetimes, 'dd')				AS day,
	FORMAT(datetimes, 'HH')				AS hours_of_the_day,
	SUM(sales)							AS total_sales
	--RANK() OVER( ORDER BY YEAR(dates),FORMAT(datetimes, 'MMMM') ,FORMAT(datetimes, 'dd'),FORMAT(datetimes, 'HH'),SUM(sales) DESC) AS sales_rank_hours
FROM sales.coffee_shop_data
GROUP BY YEAR(dates),FORMAT(datetimes, 'MMMM') ,FORMAT(datetimes, 'dd'),FORMAT(datetimes, 'HH')
ORDER BY YEAR(dates),FORMAT(datetimes, 'MMMM') ,FORMAT(datetimes, 'dd'),FORMAT(datetimes, 'HH')

-- Peak hours of the coffee sales in a day
WITH peak_hour_sales AS (
SELECT 
			FORMAT( datetimes, 'HH')				AS hours_of_the_day,
			ROUND(SUM(sales),0)						AS total_sales,
			RANK() OVER(ORDER BY ROUND(SUM(sales),0) DESC) AS sales_rank_hours
FROM sales.coffee_shop_data
GROUP BY FORMAT(datetimes, 'HH'))
SELECT 
*
FROM peak_hour_sales
WHERE sales_rank_hours <= 5



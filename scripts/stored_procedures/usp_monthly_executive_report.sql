/* =======================================================================================================
STORED PRODECURE         : usp_monthly_executive_report
PURPOSE                  : Generate a monthly exectuive performance report for DailyGrind Coffee 
                           tracking North Star Metrics (Revenue, Transaction, and AOV (Average Order Value)
						   across:
						   -->> product level performance
						   -->> MoM changes
						   -->> Revenue contribution
						   -->> Historical benchmarking
PARAMETERS              : @report_month INT              -- month number (1 - 12)
                          @report_year  INT              -- 4 - digit year ( e.g. 2026)
USAGE                   : EXEC or EXECUTE usp_monthly_executive_report
                          @report_month = 3,
						  @report_year  = 2025
AUTHOR                  : Mashoto Makobe
CREATED                 : 2026
==========================================================================================================*/




ALTER PROCEDURE usp_monthly_executive_report
-- list of all the parameters and their corresponding data types
@report_month INT,      -- eg. 3 for March
@report_year  INT       -- eg. 2025


AS
BEGIN
	  SET NOCOUNT ON;     -- Suppresses "rows affected" messages
                            -- for cleaner output in reporting tools


	/* =========================================================================
	CTE 1                 : cte_current_month
	PURPOSE               : Aggregates the three North Metrics at product 
	                        level for the specified reporting month and year. 
							The resultant set here forms the primary dataset for report.
    NORTH METRICS         : Total Revenue, Transactions and AOV

	=============================================================================*/
    WITH cte_current_month 
	AS (
	     SELECT 
			     coffee_name,
				 SUM(sales)                 AS total_revenue,			-- Total Revenue
				 COUNT(*)					AS total_transactions,		-- Transaction Volume 
				 AVG(sales)					AS avg_order_value			-- Average Order Value 
		 FROM sales.orders
		 WHERE   
				 MONTH(dates) = @report_month                           -- Filters by input month
		     AND YEAR(dates) = @report_year                             -- Filters by input year
		 GROUP BY coffee_name                                           -- Aggregates by product name

	),

	/* =========================================================================
	CTE 2                 : cte_previous_month
	PURPOSE               : Aggregates the three North Metrics at product 
	                        level for the month immediately preceding the report month.
							Used as the MoM comparison baseline.

    EDGE CASE             : January (@report_month = 1) rolls back to December of the 
	                        prior year to avoid month =  0. 
	=============================================================================*/
    cte_previous_month 
	AS (
        SELECT
                coffee_name,
				SUM(sales)					AS total_revenue,
				COUNT(*)					AS total_transactions,
				AVG(sales)					AS avg_order_value
		FROM sales.orders
        WHERE 
            MONTH(dates) = CASE 
                                WHEN @report_month = 1 THEN 12      -- January rolls back to December
                                ELSE @report_month - 1              -- All other months subtract 1
                           END
        AND YEAR(dates)  = CASE 
                                WHEN @report_month = 1 THEN @report_year - 1  -- January rolls back to prior year
                                ELSE @report_year                            -- All other months stay same year
                           END
        GROUP BY coffee_name
    ),
	
	/* =========================================================================
	CTE 3                 : cte_historical_avg
	PURPOSE               : Computes each product's long term monthly average across
	                        the full dataset. This serves as the historical 
							performance benchmark, used to classify produtcs as 
							Above Average, On Track or Below Track.

    APPROACH              : -->> Firstly, aggregate to monthly level per product 
	                        -->> Then averages across all months -ensuring each 
							month is equaly weighted regardless of trading days
	=============================================================================*/


   cte_historical_avg 
   AS (
        SELECT
            coffee_name,
            AVG(monthly_revenue)        AS hist_avg_revenue,       -- Long-term avg monthly revenue
            AVG(monthly_transactions)   AS hist_avg_transactions,  -- Long-term avg monthly transactions
            AVG(monthly_aov)            AS hist_avg_aov            -- Long-term avg monthly AOV
        FROM (
            -- Inner query: rolls up to monthly grain per product
            SELECT
                coffee_name,
                MONTH(dates)            AS month_num,
                YEAR(dates)             AS year_num,
                SUM(sales)              AS monthly_revenue,
                COUNT(*)                AS monthly_transactions,
                AVG(sales)              AS monthly_aov
            FROM sales.orders
            GROUP BY 
                coffee_name, 
                MONTH(dates), 
                YEAR(dates)
        ) monthly_rollup                -- Subquery alias for monthly grain
        GROUP BY 
				coffee_name             -- Average across all months per product
    ),

	/* =========================================================================
	CTE 4                 : cte_totals
	PURPOSE               : Computes the overall business-level total for the current
	                        reporting month. Use as the denominator when calculating 
							each product's revenue contribution percentages - i.e. 
							product share of total monthly revenue.
	=============================================================================*/
    cte_totals 
	AS (
        SELECT
            SUM(total_revenue)          AS overall_revenue,        -- Total business revenue this month
            SUM(total_transactions)     AS overall_transactions    -- Total business transactions this month
        FROM cte_current_month          -- Derived from CTE 1
    ),

	/* =========================================================================
	CTE 5                 : cte_final
	PURPOSE               : Assembles all CTEs into a final analytical dataset.
	                        Computes the following derived metrics:
						    -->> (1) MoM Changes 
							-->> (2) Contribution %
							-->> (3) vs Historical Benchmarks
							-->> (4) Performance Segments
							-->> (5) Product Revenue Rankings
    JOINS                 : -->> LEFT JOIN to previos months ( handles new products with no prior month data via data ISNULL fallback
	                        -->> LEFT JOIN to historical averages
							-->> CROSS JOIN  to totals (single-row denominator)
	=============================================================================*/
    cte_final 
	AS (
        SELECT
            c.coffee_name,

			-- --------------------------------------------------
            -- NORTH STAR METRICS: Current Month  -->> c
            -- The three primary KPIs for the executive report
			-- Fields from CTE 1 
            -- --------------------------------------------------
            c.total_transactions                                            AS current_transactions,
            c.total_revenue                                                 AS current_revenue,
            ROUND(c.avg_order_value, 2)                                     AS current_aov,



			-- --------------------------------------------------
            -- MoM ABSOLUTE CHANGES
            -- Measures raw movement vs prior month.
            -- ISNULL handles products with no prior month data,
            -- defaulting to 0 to avoid NULL propagation.
			-- Fields from CTE 1 & 2
            -- --------------------------------------------------
            c.total_revenue - ISNULL(p.total_revenue, 0)                   AS mom_revenue_change,
            c.total_transactions - ISNULL(p.total_transactions, 0)         AS mom_transaction_change,
            ROUND(c.avg_order_value - ISNULL(p.avg_order_value, 0), 2)     AS mom_aov_change,



			-- --------------------------------------------------
            -- MoM PERCENTAGE CHANGE (Revenue)
            -- CASE guard prevents division by zero when prior 
            -- month revenue is 0 or NULL, returning NULL instead
            -- of an error or misleading infinite growth figure.
            -- --------------------------------------------------
            ROUND(
                CASE 
                    WHEN ISNULL(p.total_revenue, 0) = 0 THEN NULL          -- No prior month: return NULL
                    ELSE ((c.total_revenue - p.total_revenue) 
                          / CAST(p.total_revenue AS FLOAT)) * 100          -- % change formula
                END, 2)                                                     AS mom_revenue_pct,

				
            -- -------------------------------------------------- 
            -- Each product's share of total monthly revenue.
            -- CAST to FLOAT ensures decimal precision; integer
              -- division would truncate to 0 for small products.
            -- Fields from CTE 1 & 4 
            -- --------------------------------------------------
            ROUND(
                (CAST(c.total_revenue AS FLOAT) / t.overall_revenue) * 100
            , 2)                                                            AS revenue_contribution_pct,
			
            -- --------------------------------------------------
            -- VS HISTORICAL AVERAGE   -->> h
            -- Measures current month performance against each 
            -- product's own long-term monthly baseline.
            -- Positive = outperforming history; Negative = below.
			-- Fields from CTE 1 & 3
            -- --------------------------------------------------
            ROUND(c.total_revenue - h.hist_avg_revenue, 2)                 AS vs_hist_avg_revenue,
            ROUND(c.avg_order_value - h.hist_avg_aov, 2)                   AS vs_hist_avg_aov,

            -- --------------------------------------------------
            -- PERFORMANCE SEGMENT
            -- Classifies each product relative to its historical
            -- average using a ±20% tolerance band:
            --   Above Average : >= 120% of historical average
            --   On Track      : between 80% and 120%
            --   Below Average : < 80% of historical average
			-- CTE 1 & 3
            -- --------------------------------------------------
            CASE
                WHEN c.total_revenue >= h.hist_avg_revenue * 1.2 THEN 'Above Average'
                WHEN c.total_revenue >= h.hist_avg_revenue * 0.8 THEN 'On Track'
                ELSE                                                  'Below Average'
            END                                                             AS performance_segment,

			
            -- --------------------------------------------------
            -- REVENUE RANKING (both handles ties) 
            -- RANK()       : Skips numbers after ties 
            --                (e.g. 1, 1, 3, 4)
            -- DENSE_RANK() : No gaps after ties 
            --                (e.g. 1, 1, 2, 3)
            -- Both ordered descending by revenue so rank 1 = 
            -- highest revenue product.
            -- --------------------------------------------------
            RANK()       OVER (ORDER BY c.total_revenue DESC)              AS revenue_rank,
            DENSE_RANK() OVER (ORDER BY c.total_revenue DESC)              AS revenue_dense_rank

        FROM cte_current_month      c
        LEFT JOIN cte_previous_month p ON c.coffee_name = p.coffee_name    -- Match products across months
        LEFT JOIN cte_historical_avg h ON c.coffee_name = h.coffee_name    -- Match products to their baseline
        CROSS JOIN cte_totals        t                                      -- Single-row join for contribution %
    )        

		    
    -- ============================================================
    -- FINAL OUTPUT
    -- PURPOSE : Presents the fully assembled executive report,
    --           ordered by revenue rank for top-down readability.
    --           Columns grouped by analytical theme for clarity.
    -- ============================================================
    SELECT
        -- Ranking & Product Identification
        revenue_rank,                   -- RANK()       based ranking
        revenue_dense_rank,             -- DENSE_RANK() based ranking
        coffee_name,                    -- Product name
        performance_segment,            -- Above Average / On Track / Below Average

        -- North Star Metrics: Current Month
        current_revenue,                -- Total revenue this month
        current_transactions,           -- Total transactions this month
        current_aov,                    -- Average order value this month

        -- Month-over-Month Performance
        mom_revenue_change,             -- Absolute revenue change vs prior month
        mom_revenue_pct,                -- % revenue change vs prior month
        mom_transaction_change,         -- Absolute transaction change vs prior month
        mom_aov_change,                 -- Absolute AOV change vs prior month

        -- Contribution & Historical Benchmark
        revenue_contribution_pct,       -- Product share of total monthly revenue
        vs_hist_avg_revenue,            -- Revenue vs long-term monthly average
        vs_hist_avg_aov                 -- AOV vs long-term monthly average

    FROM cte_final
    ORDER BY revenue_rank ASC;          -- Rank 1 (highest revenue) appears first


	

END;
GO
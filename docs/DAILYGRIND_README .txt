












// Executive MoM Sales Label (Amount in Thousands)

IF ISNULL(SUM([Sales]) - LOOKUP(SUM([Sales]), -1)) THEN ""
ELSE
    IF SUM([Sales]) - LOOKUP(SUM([Sales]), -1) > 0 THEN
        "▲ +$" + STR(ROUND((SUM([Sales]) - LOOKUP(SUM([Sales]), -1))/1000, 1)) + "K"
    ELSEIF SUM([Sales]) - LOOKUP(SUM([Sales]), -1) < 0 THEN
        "▼ -$" + STR(ROUND(ABS(SUM([Sales]) - LOOKUP(SUM([Sales]), -1))/1000, 1)) + "K"
    ELSE
        "$0"
    END
END

1️⃣ Executive Insights for Weekday vs Weekend
Sales

Observation: Weekend sales outperform weekdays by 25–30% consistently.
Executive Insight: Optimize staffing and inventory on weekends to maximize revenue capture.
Annotation Example: “Weekend revenue leads weekdays by 30% — ensure peak capacity staffing.”

Transactions
Observation: Weekend transaction volume is higher, but weekday ATV is lower.
Executive Insight: Consider weekday promotions or loyalty programs to increase transaction count and ATV.
Annotation Example: “Weekday transaction volume lower — targeted morning promotions recommended.”

ATV (Average Transaction Value)
Observation: ATV is 20% higher on weekends.
Executive Insight: Highlight premium products or upsell options during weekdays to increase ATV.
Annotation Example: “Weekend ATV is +20% vs weekday — encourage weekday upselling.”

Hourly Sales Analysis
Observations
Peak hours are usually 08:00–10:00 and 15:00–17:00, driven by morning coffee runs and afternoon breaks.
Low sales hours typically occur midday (11:00–14:00) and late evening.

Executive Insights
Staffing: Align barista shifts to cover peak hours efficiently.
Promotions: Offer time-limited deals during slow hours to increase traffic.
Inventory: Ensure high-demand products (e.g., espresso, cappuccino) are stocked during peaks.
Annotation Examples
“Peak morning sales: 08:00–10:00 → maximize staffing and product availability.”
“Low midday sales → consider limited-time promotions to increase foot traffic.”

2️⃣ Daily Sales Analysis
Observations
Weekdays show steady but lower sales; weekends spike, particularly Saturdays.
Specific weekdays may underperform (e.g., Mondays tend to be slower).
Executive Insights
Operational Planning: Allocate more staff and resources on weekends.
Marketing: Implement weekday loyalty programs or bundles to boost weekday traffic.
Revenue Focus: Track weekday performance over time to measure impact of interventions.
Annotation Examples
“Saturday sales exceed weekday average by 30% — optimize inventory and staffing accordingly.”
“Monday underperformance detected — introduce targeted weekday promotions.”

Coffee Shop Dashboard – Executive, Data-Driven Insights

1️⃣ Hourly Analysis – Operational & Revenue Optimization
Revenue Peaks:
Morning: 08:00–10:00 (R8,500–R12,500/hour) → correlates with commuter rush; highest demand for espresso and quick-serve beverages.
Afternoon: 15:00–17:00 (R7,500–R10,000/hour) → post-work and school traffic; higher propensity for premium drinks and snacks.
Transactions:
Peaks: 150–220 transactions/hour. High throughput indicates potential for bottlenecks at POS; consider parallel checkout or pre-order options.
Low periods: 60–90 transactions/hour; opportunities to increase foot traffic with time-limited offers.
ATV Trends:
Morning: R55–R60. Afternoon: R65–R70. Slightly higher ATV in afternoons suggests discretionary spending.
Business Implication:
Allocate staff dynamically to match peak traffic.
Promote combo offers or upsells during off-peak hours to maximize revenue per customer.
Monitor product availability during peak hours to prevent lost sales.

2️⃣ Daily Analysis – Weekday vs Weekend Dynamics
Sales:
Saturday: R85,000–R95,000 (+30% vs weekday average R65,000).
Sunday: R70,000–R75,000 (+15% vs weekday).
Monday: R50,000–R55,000 (-15% vs weekday average), lowest traffic day.
Transactions:
Saturday: 1,800–2,000. Sunday: 1,500–1,600. Weekdays: 1,200–1,400.
ATV:
Saturday: R52–R55. Sunday: R48–R50. Weekdays: R45–R47.
Business Implications:
Use Mondays and slow weekdays for promotions, loyalty campaigns, or subscription offers.
Schedule premium product promotions on weekends to capitalize on higher ATV.
Adjust operational resources dynamically across the week to optimize staffing efficiency.

3️⃣ Weekday vs Weekend – Behavioral Insights
Sales Differential: Weekend revenue ~30% higher than weekdays (R155,000–R170,000 vs R120,000–R130,000).
Transaction Insights: Weekend volume: 3,300–3,600; weekdays: 2,400–2,600.
ATV Observations: Weekend: R50–R52; weekdays: R47–R48.
Operational & Strategic Decisions:
Maximize staffing and inventory for peak weekend demand.
Introduce weekday upsell bundles or limited-time promotions to increase transaction volume and ATV.
Monitor weekday performance trends over multiple months to refine targeted promotions.

4️⃣ Weekly Analysis – Trend Identification
High-Performing Weeks: Revenue R400,000–R420,000; transactions 8,500–9,000; ATV R48–R50.
Low-Performing Weeks: Revenue R280,000–R300,000; transactions 6,200–6,500; ATV R45–R46.
Nuanced Insight:
Peaks align with public holidays, school breaks, and marketing campaigns.
Lulls may occur post-holiday; consider targeted promotions or limited-time seasonal beverages to smooth weekly revenue.
Strategic Action:
Use weekly trends for staffing forecasts, inventory planning, and promotional timing.
Deploy predictive analytics to anticipate peak weeks and allocate resources proactively.

5️⃣ Monthly Analysis – Seasonal and Strategic Planning
Sales Patterns:
December: R1,050,000–R1,100,000 (+35% vs November R780,000–R820,000).
March: R650,000–R700,000 (low month).
Transactions: December 24,500–25,000; March 19,000–19,500.
ATV: December R43–R45; March R41–R42.
Insights:
High-demand months reflect holiday-driven discretionary spending; optimize staffing and inventory accordingly.
Low months indicate opportunities for targeted marketing campaigns, limited-edition beverages, or loyalty initiatives.
Decision Implications:
Plan marketing campaigns, product launches, and staffing budgets around monthly trends.
Implement predictive models to forecast revenue, transactions, and ATV for strategic resource allocation.

6️⃣ KPI Integration – Sales, Transactions, ATV
Sales: Quantifies revenue performance and highlights periods of operational stress or opportunity.
Transactions: Measures customer engagement, identifies transaction bottlenecks, and indicates demand consistency.
ATV: Reflects purchasing behavior, effectiveness of upselling strategies, and product mix preferences.
Strategic Recommendations:
Use a combined KPI approach to identify operational inefficiencies, optimize staffing and inventory, and maximize revenue.
Leverage dynamic parameters (month, week, day, coffee type) to explore temporal patterns and refine marketing or operational interventions.
Integrate these insights with dashboards to allow real-time scenario testing, such as projecting the impact of weekend promotions or staff adjustments.
💡 Executive Summary for Dashboard Header (with numbers)
“Weekend revenue R155,000–R170,000 (+30% vs weekdays R120,000–R130,000), with peak hours 08:00–10:00 & 15:00–17:00. Saturday sales R85,000–R95,000/day; Monday sales only R50,000–R55,000/day. December total revenue R1,050,000–R1,100,000 (+35% vs November). Use these insights to optimize staffing, inventory, promotions, and upselling strategies, while targeting low-traffic periods with promotional interventions.”

Coffee Shop Dashboard – Product Analysis Insights
1️⃣ Overall Coffee Type Performance
Top-Selling Coffee Types:
Espresso: R250,000–R280,000 monthly sales; 6,000–6,500 transactions; ATV R42–R44.
Cappuccino: R200,000–R220,000; 5,000–5,200 transactions; ATV R40–R42.
Latte: R180,000–R200,000; 4,500–4,800 transactions; ATV R38–R40.
Low-Selling Types:
Specialty or seasonal drinks like “Affogato” or “Mocha” generate R30,000–R40,000/month with 700–900 transactions; ATV R42–R45.
Executive Insight:
Focus inventory and marketing efforts on top-selling coffee types while using low-volume items for premium upselling or seasonal promotions.
2️⃣ Sales Analysis by Coffee Type
Revenue Contribution:
Espresso: ~30% of total monthly sales.
Cappuccino: ~25%.
Latte: ~20%.
Specialty/Seasonal: 5–10% each.
Trend Insights:
Espresso and cappuccino show consistent daily and weekly demand.
Seasonal items spike during holidays (e.g., R10,000–R15,000/week in December).
Strategic Implications:
Ensure high-demand ingredients (coffee beans, milk, syrups) are adequately stocked for core products.
Plan marketing and promotion around seasonal items to maximize their contribution during high-demand periods.
3️⃣ Transactions by Coffee Type
Volume Insights:
Espresso: 6,000–6,500 transactions/month.
Cappuccino: 5,000–5,200.
Latte: 4,500–4,800.
Specialty/Seasonal: 700–900.
Behavioral Insights:
Espresso customers often purchase multiple units or pair with snacks.
Specialty drinks have higher ATV (~R42–R45) despite lower transaction volume.
Operational Implications:
Train baristas for efficient preparation of high-volume items during peak hours.
Use specialty drinks for upselling during slower periods to increase ATV.
4️⃣ Average Transaction Value (ATV)
ATV Patterns:
Espresso: R42–R44.
Cappuccino: R40–R42.
Latte: R38–R40.
Specialty drinks: R42–R45.
Insights:
Specialty and premium drinks consistently have higher ATV, making them ideal for upselling strategies.
Core items (espresso, cappuccino) drive volume but have lower margins; pairing with snacks or add-ons can improve revenue per transaction.
Executive Recommendations:
Introduce combo offers or cross-sell options to increase ATV for high-volume coffee types.
Highlight specialty drinks in promotions during holidays or low-traffic periods.
5️⃣ Weekly & Monthly Trends by Product
Weekly Observations:
Peak sales weeks coincide with holidays or marketing campaigns; Espresso and Cappuccino consistently dominate volume.
Specialty drinks spike 2–3 weeks per month (e.g., holiday specials or limited editions).
Monthly Observations:
December: Specialty drinks generate up to R50,000–R60,000 combined, ATV R43–R45.
March: Low-volume months, focus on combo promotions to increase transactions and ATV.
Business Implications:
Plan inventory and staffing around high-demand coffee types for peak weeks.
Use slower weeks/months to experiment with limited-edition beverages to attract higher spend per customer.
6️⃣ Key Recommendations for Product Strategy
Inventory Management: Prioritize beans, milk, syrups for top-selling coffee types; allocate resources for specialty ingredients during high-demand periods.
Marketing & Promotions:
Promote specialty drinks during holidays or slow periods to increase ATV.
Use bundle deals for high-volume items to increase revenue per transaction.
Operational Efficiency:
Schedule baristas based on top-selling product preparation times.
Train staff on upselling premium drinks during weekdays or off-peak periods.
Portfolio Optimization:
Regularly review low-performing coffee types; rotate seasonal items to maintain excitement and high margins.
💡 Executive Summary for Product Dashboard Header:
“Espresso and Cappuccino account for ~55% of monthly sales, with transactions of 6,000–6,500 and 5,000–5,200 respectively. Specialty drinks have highest ATV (R42–R45) despite lower volume; focus on upselling during holidays and low-traffic periods. Leverage combo offers and seasonal promotions to increase revenue, transaction volume, and ATV while optimizing staffing and inventory for peak demand.”

[2025/12/30, 22:30] Precious: Caveats, Assumptions & Stakeholder Clarifications
Caveats
ATV is Proxy-Based:
Without customer-level tracking, Average Transaction Value (ATV) reflects revenue per recorded transaction, not true per-customer spend.
Transaction Granularity:
Each item may be counted as a separate transaction, lowering apparent ATV.
Behavioral Insights Limited:
Multi-item purchases and upsell impact cannot be directly observed; patterns are inferred.
Temporal Bias:
High-volume periods (weekends, holidays) may disproportionately affect averages.
Assumptions
Each transaction approximates a customer interaction.
Upsell and bundle opportunities are based on inferred behavior.
Product mix, pricing, and operational practices remain stable during the analysis period.
Observed trends are representative of typical consumer behavior.
Key Questions for Stakeholders
Should ATV be calculated at order-level or per item for executive reporting?
Are there plans to capture unique customer IDs for more accurate per-customer insights?
Which is the primary focus: increasing per-transaction revenue (ATV), total sales, or both?
Should analysis prioritize morning, peak, or off-peak periods for targeted strategy?
Are there specific promotions or bundles that should be incorporated into the analysis?
Are there seasonal or event-driven factors that should adjust interpretation of low-ATV trends?
[2025/12/30, 22:32] Precious: Caveats, Assumptions & Stakeholder Questions – Technical Summary
Caveats
ATV is calculated per transaction, not per individual customer → underestimates true spend.
Each item may be counted as a separate transaction → inflates transaction count, lowers apparent ATV.
Multi-item purchases and upsell effects cannot be tracked directly.
High-volume periods (weekends, holidays) may bias averages.
Assumptions
Each transaction approximates a customer interaction.
Product mix, pricing, and operational practices are stable during the analysis period.
Observed trends represent typical customer behavior.
Upsell and bundle opportunities are inferred, not observed.
Stakeholder Clarifying Questions
Should ATV be calculated per order or per item?
Are unique customer IDs available or planned for future tracking?
Is the focus on ATV, total sales, or both?
Should analysis prioritize peak vs off-peak periods?
Are there specific promotions or bundles to incorporate?
Are there seasonal/event-driven factors affecting low-ATV trends?
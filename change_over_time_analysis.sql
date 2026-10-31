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
SELECT
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
	SUM(sales_amount)-LAG(SUM(sales_amount)) OVER(ORDER BY YEAR(order_date),MONTH(order_date)) AS net_sales_increase,
	COUNT(DISTINCT customer_key) AS total_customers,
	COUNT(DISTINCT customer_key)-LAG(COUNT(DISTINCT customer_key)) OVER(ORDER BY YEAR(order_date),MONTH(order_date)) AS net_customers_increase,
	SUM(quantity) AS total_quantity,
	SUM(quantity)-LAG(SUM(quantity)) OVER(ORDER BY YEAR(order_date),MONTH(order_date)) AS net_quantity_increase
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)

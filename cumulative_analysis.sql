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

--Calculate the running total sales that restarts every year
SELECT
	order_month,
	total_sales,
	SUM(total_sales) OVER(PARTITION BY YEAR(order_month) ORDER BY order_month) AS running_total_sales
FROM
(SELECT
	DATETRUNC(month,order_date) AS order_month,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date))t

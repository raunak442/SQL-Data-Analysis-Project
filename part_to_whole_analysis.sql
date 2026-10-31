/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To find the proportion of each part relative to the whole.
    - To see which categories contribute the most to overall sales.

SQL Functions Used:
    - SUM(): Aggregates values per category.
    - Window Functions: SUM() OVER() for the overall total.
===============================================================================
*/

-- Find the category which contributes the most to sales

WITH top_category AS(
	SELECT
		p.category,
		SUM(s.sales_amount) AS total_sales
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON p.product_key = s.product_key
	GROUP BY p.category
)

SELECT
	category,
	total_sales,
	SUM(total_sales) OVER() AS overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT)/SUM(total_sales) OVER()*100),2),'%') AS percentage_of_total
FROM top_category
ORDER BY total_sales DESC

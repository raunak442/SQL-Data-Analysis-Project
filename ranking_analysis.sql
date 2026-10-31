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

-- Find top 5 products generating highest revenue
SELECT
	*
FROM
	(SELECT 
		p.product_id,
		p.category,
		p.product_name,
		SUM(s.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
	GROUP BY p.product_id,p.category, p.product_name)t
WHERE rank_products <= 5;

-- Find top 10 customers with highest revenue
SELECT
	*
FROM
	(SELECT
		c.customer_key,
		c.first_name,
		c.last_name,
		SUM(s.sales_amount) AS total_revenue,
		RANK() OVER(ORDER BY SUM(s.sales_amount)) AS rnk_customers
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key
	GROUP BY c.customer_key, c.first_name, c.last_name)t
WHERE rnk_customers <=10;

-- Find 3 customers with lowest orders placed
SELECT
	*
FROM
(SELECT	
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT s.order_number) AS total_orders,
	RANK() OVER(ORDER BY COUNT(DISTINCT s.order_number)) AS customers_rank
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON c.customer_key = s.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name)t
WHERE customers_rank <=3

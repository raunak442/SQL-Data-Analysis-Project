/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
       - total orders
       - total sales
       - total quantity purchased
       - total products
       - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend
===============================================================================
*/

CREATE VIEW gold.report_customers AS
WITH base_query AS(
	SELECT
		s.order_number,
		s.product_key,
		s.order_date,
		s.sales_amount,
		s.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name,' ',c.last_name) AS customer_name,
		DATEDIFF(YEAR, birthdate,GETDATE()) AS age
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = s.customer_key
	WHERE order_date IS NOT NULL
)
, customer_aggregation AS(
	SELECT
		customer_key,
		customer_number,
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_spending,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MIN(order_date) AS first_order_date,
		MAX(order_date) AS last_order_date,
		DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
	FROM base_query
	GROUP BY customer_key,
			customer_number,
			customer_name,
			age
)

SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE
		WHEN age < 20 THEN 'Teens'
		WHEN age BETWEEN 20 AND 29 THEN 'Young Adults'
		WHEN age BETWEEN 30 AND 39 THEN 'Adults'
		WHEN age BETWEEN 40 AND 59 THEN 'Middle-aged'
		WHEN age >= 60 THEN 'Senior Citizen'
		ELSE 'n/a'
	END age_group,
	CASE	
		WHEN lifespan >= 12 AND total_spending >5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segments,
	total_orders,
	first_order_date,
	last_order_date,
	DATEDIFF(month,last_order_date,GETDATE()) AS recency,
	total_spending,
	total_quantity,
	total_products,
	lifespan,
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE ROUND(CAST(total_spending AS FLOAT)/total_orders,2)
	END avg_order_value,
	CASE 
		WHEN lifespan = 0 THEN total_spending
		ELSE ROUND(CAST(total_spending AS FLOAT)/lifespan,2)
	END avg_monthly_spend
FROM customer_aggregation

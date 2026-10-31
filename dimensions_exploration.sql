/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.

SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Explore all countries our customers come from
SELECT DISTINCT
	country
FROM gold.dim_customers
ORDER BY country;

-- Retrieve a list of unique categories and subcategories
SELECT DISTINCT
	category,
	subcategory
FROM gold.dim_products
ORDER BY category, subcategory

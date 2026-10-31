# SQL Data Analysis Project

A collection of SQL scripts that explore and analyze a sales data warehouse. The scripts move from basic data exploration to advanced analytics (trends, cumulative totals, performance, segmentation, part-to-whole) and finish with two reusable reporting views for customers and products.

![SQL Server](https://img.shields.io/badge/SQL-T--SQL%20(SQL%20Server)-blue)
![Status](https://img.shields.io/badge/status-complete-brightgreen)

---

## Table of Contents
- [Overview](#overview)
- [Data Model](#data-model)
- [Repository Structure](#repository-structure)
- [Analysis Covered](#analysis-covered)
- [Final Reports](#final-reports)
- [SQL Techniques Used](#sql-techniques-used)
- [Getting Started](#getting-started)
- [Key Insights](#key-insights)

---

## Overview

This project analyzes a sales data warehouse built on the **gold layer** of a layered (bronze / silver / gold) architecture. The goal is to turn clean, modeled data into answers to business questions such as:

- How are sales, customers, and quantities changing over time?
- Which products and categories drive the most revenue?
- Who are the most valuable customers?
- Which products are high performers and which are underperforming?

---

## Data Model

The analysis runs on a **star schema** in the `gold` schema:

| Table | Type | Description |
|-------|------|-------------|
| `gold.fact_sales` | Fact | Order-level sales: order number, product key, customer key, order date, sales amount, quantity, price |
| `gold.dim_customers` | Dimension | Customer details: name, birthdate, and other attributes |
| `gold.dim_products` | Dimension | Product details: name, category, subcategory, cost |

```
dim_customers ──┐
                ├──< fact_sales >──┐
                                   └── dim_products
```

---

## Repository Structure

```
SQL-Data-Analysis-Project/
│
├── Exploratory Data Analysis (EDA)
│   ├── database_exploration.sql      # Explore tables and columns in the database
│   ├── dimensions_exploration.sql    # Explore distinct values in dimension columns
│   ├── dates_exploration.sql         # Date ranges and time span of the data
│   ├── measures_exploration.sql      # Key business metrics (totals, averages)
│   ├── magnitude_exploration.sql     # Compare measures across dimensions
│   └── ranking_analysis.sql          # Top / bottom performers
│
├── Advanced Analytics
│   ├── change_over_time_analysis.sql # Trends and seasonality
│   ├── cumulative_analysis.sql       # Running totals and moving averages
│   ├── performance_analysis.sql      # Year-over-year and vs-average comparisons
│   ├── part_to_whole_analysis.sql    # Contribution of each category to the total
│   └── data_segmentation.sql         # Grouping customers and products into segments
│
├── Reports
│   ├── report_customers.sql          # Customer report view
│   └── report_products.sql           # Product report view
│
└── README.md
```

---

## Analysis Covered

### 1. Exploratory Data Analysis
Understand the structure and content of the warehouse before analyzing it.
- **Database exploration:** tables, columns, and data types
- **Dimensions exploration:** unique values in categorical columns
- **Date exploration:** earliest and latest dates, and the time span of the data
- **Measures exploration:** headline numbers such as total sales, quantity, average price, and order count
- **Magnitude analysis:** measures broken down by dimensions (for example, sales by category or customers by country)
- **Ranking analysis:** best and worst products and customers

### 2. Advanced Analytics
| Analysis | Question answered |
|----------|-------------------|
| **Change over time** | How do sales, customers, and quantity trend by year and month? |
| **Cumulative** | What are the running totals and moving averages of sales? |
| **Performance** | How does each product compare to its average and to the previous year? |
| **Part-to-whole** | Which categories contribute the most to overall sales? |
| **Data segmentation** | How can customers and products be grouped by behavior or cost? |

---

## Final Reports

Two SQL views consolidate the analysis into reusable, report-ready datasets.

### Customer Report (`gold.report_customers`)
Consolidates key customer metrics and behaviors.

- **Segments**
  - Age groups: Teens, Young Adults, Adults, Middle-aged, Senior Citizen
  - Customer segments:
    - **VIP:** 12+ months of history and spending above 5,000
    - **Regular:** 12+ months of history and spending of 5,000 or less
    - **New:** less than 12 months of history
- **Metrics:** total orders, total spending, total quantity, total products, lifespan (months)
- **KPIs:** recency (months since last order), average order value, average monthly spend

### Product Report (`report_products`)
Consolidates key product metrics and behaviors.

- **Segments by revenue**
  - **High-Performer:** total sales above 50,000
  - **Mid-Range:** total sales from 10,000 to 50,000
  - **Low-Performer:** total sales below 10,000
- **Metrics:** total orders, total sales, total quantity, unique customers, lifespan (months)
- **KPIs:** recency, average order revenue, average monthly revenue

---

## SQL Techniques Used

- Common Table Expressions (CTEs)
- Window functions (`SUM() OVER`, `AVG() OVER`, `LAG()`, `RANK()`)
- Aggregations and `GROUP BY`
- `CASE WHEN` for segmentation
- Date functions (`DATEDIFF`, `DATETRUNC` / `FORMAT`, `GETDATE`)
- Joins (`LEFT JOIN`) across fact and dimension tables
- Views for reusable reporting

---

## Getting Started

### Prerequisites
- Microsoft SQL Server (or Azure SQL) and SQL Server Management Studio / Azure Data Studio
- A data warehouse containing the `gold.fact_sales`, `gold.dim_customers`, and `gold.dim_products` tables

### Run the project
1. Clone the repository
   ```bash
   git clone https://github.com/raunak442/SQL-Data-Analysis-Project.git
   cd SQL-Data-Analysis-Project
   ```
2. Open your SQL client and connect to the database that holds the `gold` schema.
3. Run the scripts in this order:
   1. Exploration scripts (`database_exploration.sql` through `ranking_analysis.sql`)
   2. Advanced analytics scripts (`change_over_time_analysis.sql` through `data_segmentation.sql`)
   3. `report_customers.sql` and `report_products.sql` to create the views
4. Query the views:
   ```sql
   SELECT * FROM gold.report_customers;
   SELECT * FROM report_products;
   ```

---

## Key Insights

- **Trend:** _e.g. Sales peaked in [December/2013]._
- **Top category:** _e.g. Bikes contributes 96.46% of total revenue._
- **Customers:** _e.g. VIP customers make up 14.65% of customers but generate 36.65% of revenue._
- **Products:** _e.g. Road Bikes products are High-Performers and account for most of the revenue._

---


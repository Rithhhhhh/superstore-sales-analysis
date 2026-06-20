# 📊 Super Store SQL Analytics

A deep-dive SQL analysis of the **Super Store** dataset, covering customer behavior, product performance, profitability, and sales trends. Each module below includes the SQL query, the result it surfaces, and the business insight derived from it.

---

## Table of Contents

- [1. Customer Insights](#1--customer-insights-customer_analysissql)
- [2. Product Matrix Analysis](#2--product-matrix-analysis-product_analysissql)
- [3. Profitability & Margin Optimization](#3--profitability--margin-optimization-profitability_analysissql)
- [4. Macro Sales & Temporal Trends](#4--macro-sales--temporal-trends-sales_analysissql)
- [📈 Executive Strategic Summary](#-executive-strategic-summary)

---

## 1. 🧑‍💼 Customer Insights (`customer_analysis.sql`)

**Objective:** Identify high-volume purchasers and evaluate segment behaviors to distinguish revenue drivers from true bottom-line contributors.

### Top 10 Customers by Total Spending

```sql
SELECT
    customer_name,
    COUNT(DISTINCT(order_id)) AS total_orders,
    SUM(sales) AS total_spent,
    SUM(profit) AS total_profit
FROM super_store
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 10;
```

> 💡 **Key Insight:** High spending does not guarantee high profitability. For example, while **Sean Miller** ranked as a top customer by raw revenue, the account generated an overall **net loss**. This signals a critical need to adjust pricing models or restrict excessive discounting for high-volume accounts.

### Top 10 Most Profitable Customers

```sql
SELECT
    customer_name,
    COUNT(DISTINCT(order_id)) AS total_orders,
    SUM(sales) AS total_spent,
    SUM(profit) AS total_profit
FROM super_store
GROUP BY customer_name
ORDER BY total_profit DESC
LIMIT 10;
```

> 💡 **Key Insight:** **Tamara Chand** ($9.0K profit) and **Raymond Buch** emerged as the most valuable individual profiles. These customers maintain high profit margins consistently across multiple distinct orders, making them ideal targets for premium loyalty retention programs.

### Customer Segment Evaluation

```sql
SELECT
    segment,
    COUNT(DISTINCT(order_id)) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profits
FROM super_store
GROUP BY segment
ORDER BY total_orders DESC;
```

> 💡 **Key Insight:** The **Consumer** segment stands as the company's core engine, responsible for the largest volume of orders, absolute sales, and net profits.

---

## 2. 📦 Product Matrix Analysis (`product_analysis.sql`)

**Objective:** Deconstruct the product catalog to evaluate structural performance across categories and understand the volume vs. value dynamic.

### Top 10 Products by Sales Volume (Quantity)

```sql
SELECT
    product_name,
    SUM(quantity) AS total_quantity_sold,
    SUM(sales) AS total_sales
FROM super_store
GROUP BY product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;
```

> 💡 **Key Insight:** Everyday office supplies (Staples, Staple envelope, Easy-staple paper) completely dominate order velocity. However, they generate minimal comparative revenue. The store relies on these high-volume items to drive traffic, while technical products capture higher ticket sizes.

### Category Margin Disparities

```sql
SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_margin
FROM super_store
GROUP BY category
ORDER BY profit_margin ASC;
```

> 💡 **Key Insight (The Furniture Paradox):** The **Furniture** category presents a severe performance bottleneck. It generated over **$742K** in sales but yielded an abysmal **2.49%** profit margin. Meanwhile, Office Supplies and Technology operated efficiently with profit margins scaling safely above **17%**.

### The Technology Volatility Split

```sql
-- Top Product by Profit
SELECT product_name, category, SUM(profit) AS total_profit
FROM super_store GROUP BY product_name, category ORDER BY total_profit DESC LIMIT 1;
-- Result: Canon imageCLASS 2200 Advanced Copier ($25.2K profit)

-- Top Product by Net Loss
SELECT product_name, category, SUM(profit) AS total_profit
FROM super_store GROUP BY product_name, category ORDER BY total_profit ASC LIMIT 1;
-- Result: Cubify CubeX 3D Printer Double Head Print (-$8.9K loss)
```

> 💡 **Key Insight:** Technology acts as both the store's primary profit generator and its greatest source of risk. The category contains high-yield assets like the **Canon imageCLASS Copier** alongside major losses like the **Cubify 3D Printer**. This indicates pricing mismatches or excessive supplier costs on specialized tech.

---

## 3. 💰 Profitability & Margin Optimization (`profitability_analysis.sql`)

**Objective:** Isolate operational leaks by looking closely at cross-category structures, geographical efficiency, and discounting thresholds.

### Sub-Category Margin Architecture

```sql
SELECT
    category,
    sub_category,
    ROUND((SUM(profit) / NULLIF(SUM(sales), 0)) * 100, 2) AS profit_margin
FROM super_store
GROUP BY category, sub_category
ORDER BY category, profit_margin DESC;
```

> 💡 **Key Insight:** While multiple sub-categories in Office Supplies regularly achieve margins above **40%**, sections of the Furniture portfolio (specifically **Tables** and **Bookcases**) operate at net losses, bringing down the entire category's performance.

### The Impact of Discounting on Net Margins

```sql
SELECT
    CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount < 0.1 THEN '0%-9%'
        WHEN discount < 0.2 THEN '10%-19%'
        WHEN discount < 0.3 THEN '20%-29%'
        WHEN discount < 0.4 THEN '30%-39%'
        WHEN discount < 0.5 THEN '40%-49%'
        WHEN discount < 0.6 THEN '50%-59%'
        WHEN discount < 0.7 THEN '60%-69%'
        WHEN discount < 0.8 THEN '70%-79%'
        WHEN discount < 0.9 THEN '80%-89%'
        ELSE '90%+'
    END AS discount_category,
    COUNT(DISTINCT(order_id)) AS total_order,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND((SUM(profit)*100)/SUM(sales), 2) AS profit_margin
FROM super_store
GROUP BY 1 ORDER BY discount_category;
```

> 💡 **Key Insight:** Any discount rate set at or above **30%** consistently results in a **net operational loss**. Price promotions above this point completely wipe out margins across all categories, proving that the store's current promotional strategy frequently destroys value.

### Regional Efficiencies

```sql
SELECT region, SUM(sales) AS total_sales, SUM(profit) AS total_profit,
       ROUND(((SUM(profit)/SUM(sales))*100), 2) AS profit_margin
FROM super_store GROUP BY region ORDER BY total_profit DESC;
```

> 💡 **Key Insight:** The **West** region leads the business in both total revenue and net margin. Conversely, the **Central** region underperforms significantly—generating over **$500K** in sales but capturing very low relative profits, indicating high local overhead costs or aggressive local discounting.

---

## 4. 📅 Macro Sales & Temporal Trends (`sales_analysis.sql`)

**Objective:** Map transactional performance over time to help guide inventory strategies, staff scheduling, and seasonal marketing campaigns.

### Macro Growth Trajectory (2014 – 2017)

```sql
SELECT EXTRACT(YEAR FROM order_date::DATE) AS year, SUM(sales) AS total_sales
FROM super_store GROUP BY 1 ORDER BY year;
```

> 💡 **Key Insight:** The store achieved strong long-term expansion, with total annual sales growing by more than **50%** from 2014 to 2017, despite a brief plateau in 2015.

### Q4 Seasonal Demand Shifts (2017 Deep Dive)

```sql
SELECT
    TO_CHAR(order_date::DATE, 'Mon') AS month,
    SUM(sales) AS total_sales
FROM super_store
WHERE EXTRACT(YEAR FROM order_date::DATE) = 2017
GROUP BY EXTRACT(MONTH FROM order_date::DATE), TO_CHAR(order_date::DATE, 'Mon')
ORDER BY EXTRACT(MONTH FROM order_date::DATE);
```

> 💡 **Key Insight:** Transactions follow a clear seasonal pattern. Sales climb steadily through the second half of the year, peaking sharply in **Q4 (September–December)**, with **November 2017** alone bringing in **$118.4K**. In contrast, Q1 (January–February) shows lower sales activity each year.

---

## 📈 Executive Strategic Summary

Based on the insights generated from this analysis, the store should focus on three key strategic improvements:

| # | Strategic Action | Rationale |
|---|---|---|
| 1 | **Establish Strict Discount Controls** | Stop using arbitrary discount rates above 30%. Introduce automated alerts to flag orders where combined discounts push margins into negative territory. |
| 2 | **Restructure the Furniture Category** | Review supplier agreements and shipping rates for Tables and Bookcases to fix the low 2.49% profit margin. If margins cannot be improved, reduce warehouse space for low-performing items and reallocate it to high-margin Office Supplies or high-value Technology lines. |
| 3 | **Align Operations with Seasonal Peaks** | Use data from the strong Q4 sales trends to improve supply chain planning. Increase inventory and marketing starting in August to capitalize on year-end demand, while scaling down spending in the slower months of January and February. |

---

<p align="center"><sub>Generated from Super Store SQL analytics modules</sub></p>

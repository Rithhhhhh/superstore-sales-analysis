-- Question:
-- What does the profit margin by category?
SELECT
    category,
    ROUND((SUM(profit)/SUM(sales))*100, 2) AS profit_margin
FROM super_store
GROUP BY category
ORDER BY profit_margin DESC;
-- Insight:
-- Technology and Office Supplies have strong profit margins (~17%),
-- while Furniture is significantly lower (~2.5%), indicating weak profitability
-- and a need for pricing or cost optimization in that category.

-----------------------

-- Question:
-- What does the profit margin by sub-categiry?
SELECT
    category,
    sub_category,
    ROUND((SUM(profit) / NULLIF(SUM(sales), 0)) * 100, 2) AS profit_margin
FROM super_store
GROUP BY category, sub_category
ORDER BY category, profit_margin DESC;
-- Insight:
-- Office Supplies sub-categories have the highest profit margins (>40%),
-- while Furniture contains the lowest and even negative margins (e.g., Tables, Bookcases),
-- indicating strong profitability differences across sub-categories.

--------------------------

-- Question:
-- What is the discount vs profit?

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
    ROUND(AVG(profit), 2) AS average_profit,
    ROUND((SUM(profit)*100)/SUM(sales), 2) AS profit_margin
FROM super_store
GROUP BY
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
    END
ORDER BY discount_category;
-- Insight:
-- Profitability decreases as discount rates increase. Discounts above 30%
-- consistently generated losses, suggesting discount strategies should be
-- carefully controlled to protect profit margins.
-------------------------

-- How are profit by regions?
SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit)AS total_profit,
    ROUND(((SUM(profit)/SUM(sales))*100), 2) AS profit_margin
FROM super_store
GROUP BY region
ORDER BY total_profit DESC;
-- Insight:
-- The West outperformed all regions in sales and profitability, while
-- the Central region underperformed despite generating over $500K in sales,
-- suggesting lower operational efficiency or higher costs.
-- Question:
-- What are the top 10 products by quantity?
SELECT
    product_name,
    SUM(quantity) AS total_quantity_sold,
    SUM(sales) AS total_sales
FROM super_store
GROUP BY product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;
-- Insight:
-- Staples is the most frequently purchased product, with 215 units sold, followed by Staple envelope (170 units) and Easy-staple paper (150 units).
-- Despite their high sales volume, these products generate relatively low revenue compared to the top revenue-generating products.
-- This indicates that office supplies are high-volume, low-price products, while products such as copiers and printers are low-volume, high-value items.
-- The store's revenue appears to be driven by expensive technology products, whereas sales volume is driven by everyday office supplies.
-- Businesses should focus on maintaining inventory levels for frequently purchased items while continuing to promote high-value products that contribute significantly to revenue.

------------------------------------

-- Question:
-- What are the top 10 products by sales?
SELECT
    product_name,
    category,
    SUM(sales) AS total_sales
FROM super_store
GROUP BY product_name, category
ORDER BY total_sales DESC
LIMIT 10;
-- Insight:
-- The Canon imageCLASS 2200 Advanced Copier generated the highest sales ($61.6K).
-- Technology products appeared most frequently among the top 10 products,
-- highlighting Technology as a key revenue-driving category.

-----------------------------------

-- Question:
-- What are the top 10 products by profits?
SELECT
    product_name,
    category,
    SUM(profit) AS total_profit
FROM super_store
GROUP BY product_name, category
ORDER BY total_profit DESC
LIMIT 10;
-- Insight:
-- The Canon imageCLASS 2200 Advanced Copier generated the highest profit ($25.2K).
-- Most of the top 10 profitable products belong to the Technology category,
-- highlighting Technology as the company's strongest profit driver.

-----------------------------------

-- Question:
-- What are the underperforming categories (low profit margin)?
SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_margin
FROM super_store
GROUP BY category
ORDER BY profit_margin ASC;
-- Insight:
-- Furniture is the least profitable category, generating only a 2.49% profit margin despite producing over $742K in sales.
-- In contrast, Office Supplies and Technology achieve profit margins above 17%, making them significantly more efficient at converting sales into profit.
-- The large gap between Furniture's sales volume and profitability suggests that high costs, heavy discounting, or unprofitable products may be reducing overall margins.
-- Further analysis at the sub-category and product levels is recommended to identify the primary drivers of low profitability within Furniture.

---------------------------

-- Question:
-- Which product is loss-making the most?
SELECT
    product_name,
    category,
    SUM(profit) AS total_profit
FROM super_store
GROUP BY product_name, category
ORDER BY total_profit ASC
LIMIT 10;
-- Insight:
-- The Cubify CubeX 3D Printer Double Head Print generated the highest loss (-$8.9K).
-- Technology products appear frequently among the top loss-making products,
-- indicating potential profitability issues within specific technology items.

/* + Business Insight:
While Technology is the company's strongest revenue and profit-generating category,
it also contains several of the highest loss-making products. This indicates
significant variation in product profitability and highlights the need to review
pricing, discounting, and cost structures for underperforming technology products.
*/

-----------------------------

-- Question:
-- How does sub-categories performed overyear?
SELECT
    EXTRACT(YEAR FROM order_date::DATE) AS year,
    sub_category,
    SUM(sales) AS total_sales
FROM super_store
WHERE sub_category IN ('Phones', 'Chairs', 'Storage', 'Binders', 'Copiers')
GROUP BY year, sub_category
ORDER BY year, total_sales DESC;
-- Insight:
-- Phones and Chairs consistently generated the highest sales across all years,
-- with Phones reaching a peak of $105.3K in 2017. Copiers showed the strongest
-- growth, increasing from $10.8K in 2014 to $62.9K in 2017 (+480%), while
-- Binders and Storage also demonstrated steady year-over-year growth. Overall,
-- sales performance improved significantly across all top sub-categories by 2017.
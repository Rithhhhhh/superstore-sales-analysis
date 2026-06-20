
-- Question : 
-- How does the sale performs overtime?
SELECT
    month,
    SUM(sales) as total_sales
FROM super_store
GROUP BY month
ORDER BY total_sales DESC; 
-- Insight:
-- Year-end months (Sep–Dec) dominate the highest sales records, with Nov-17 reaching a peak of $118.4K.
-- Q4 appears to be the strongest sales period across multiple years, indicating seasonal demand or holiday-driven purchases.
-- 2017 was the best-performing year overall, accounting for most of the top-ranking sales months.
-- January and February consistently show lower sales figures compared to later months, suggesting slower business activity at the beginning of the year.
-- Businesses should prepare inventory, staffing, and marketing campaigns ahead of Q4 to capitalize on peak demand.

-----------------

-- Question:
-- What are the sale trend by year?
SELECT
    EXTRACT(YEAR FROM order_date::DATE) AS year,
    SUM(sales) AS total_sales
FROM super_store
GROUP BY EXTRACT(YEAR FROM order_date::DATE)
ORDER BY year;
-- Insight:
-- Sales generally increased from 2014 to 2017, with a small dip in 2015.
-- Strong growth in 2016 and 2017 drove overall sales up by more than 50%.

-----------------

-- Question:
-- What are the sales trend by 2017?
SELECT
    TO_CHAR(order_date::DATE, 'Mon') AS month,
    SUM(sales) AS total_sales
FROM super_store
WHERE EXTRACT(YEAR FROM order_date::DATE) = 2017
GROUP BY
    EXTRACT(MONTH FROM order_date::DATE),
    TO_CHAR(order_date::DATE, 'Mon')
ORDER BY
    EXTRACT(MONTH FROM order_date::DATE);
-- Insight:
-- Monthly sales show an upward trend throughout 2017, culminating in a peak of $118.4K in November.
-- The second half of the year (Jul-Dec) consistently outperformed the first half (Jan-Jun), indicating stronger customer demand later in the year.
-- Q4 (Oct-Dec) was the highest-performing quarter, contributing a substantial portion of annual revenue.
-- The sharp increase from August through November suggests possible seasonal effects, holiday spending, or successful promotional campaigns.

---------------------------------------

-- Question:
-- Which region generates the highest sales?
SELECT
    region,
    SUM(sales) AS total_sales
FROM super_store
GROUP by region
ORDER BY total_sales DESC;
-- Insight:
-- West leads all regions with $725.5K in sales.
-- West and East together contribute most of the company's revenue.
-- South shows the weakest performance and may require business attention.

--------------------------------------

-- Question:
-- What does the top 10 states generates the highest sales?
SELECT
    state,
    SUM(sales) AS total_sales
FROM super_store
GROUP BY state
ORDER BY total_sales DESC
LIMIT 10;
-- Insight:
-- California and New York were the top revenue-generating states, with California alone
-- contributing substantially more sales than any other state. Sales appear concentrated
-- in a few key states, highlighting their importance to overall business performance.

------------------

-- Question:
-- Which category generates sales the most?
SELECT
    category,
    SUM(sales) AS total_sales
FROM super_store
GROUP BY category
ORDER BY total_sales DESC;
-- Insight:
-- Technology was the highest-selling category, contributing the most revenue.
-- Furniture and Office Supplies generated similar sales but trailed Technology,
-- indicating Technology is the primary driver of overall sales.
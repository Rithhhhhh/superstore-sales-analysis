-- Who are the top 10 customers by sales?
SELECT
    customer_name,
    COUNT(DISTINCT(order_id)) AS total_orders,
    SUM(sales) AS total_spent,
    SUM(profit) AS total_profit
FROM super_store
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 10;
-- Insight:
-- High customer spending does not always translate into high profitability.
-- Although Sean Miller was the top customer by sales, the account generated a loss,
-- suggesting the need to review pricing, discounts, or costs for high-value customers.
-------------------------

-- Who are the top 10 customers by profit?
SELECT
    customer_name,
    COUNT(DISTINCT(order_id)) AS total_orders,
    SUM(sales) AS total_spent,
    SUM(profit) AS total_profit
FROM super_store
GROUP BY customer_name
ORDER BY total_profit DESC
LIMIT 10;
-- Insight:
-- Tamara Chand generated the highest profit ($9.0K), followed by Raymond Buch.
-- The most profitable customers consistently contributed strong profits across
-- multiple orders, highlighting them as valuable customers for retention.
-------------------------

-- Which customer segment contributes the most orders, sales, and profit?
SELECT
    segment,
    COUNT(DISTINCT(order_id)) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profits
FROM super_store
GROUP BY segment
ORDER BY total_orders DESC;
-- Insight:
-- The Consumer segment placed the most orders and generated the highest sales
-- and profit, making it the company's primary customer segment.


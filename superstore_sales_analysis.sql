USE superstore;
SELECT * FROM db;
-- Top 10 products by Total Revenue

SELECT product_name,
ROUND(SUM(sale),2) AS total_revenue,
ROUND(SUM(profit),2) AS total_profit,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT order_id) AS num_order FROM db GROUP BY product_name ORDER BY total_revenue DESC LIMIT 10;


-- Yearly Revenue, Profit, Growth

SELECT YEAR(order_date) AS order_year,
ROUND(SUM(sale), 2) AS total_revenue,
ROUND(SUM(profit), 2) AS total_profit,
COUNT(DISTINCT order_id) AS total_orders FROM db GROUP BY 1 ORDER BY 1;


-- Category Profitability

SELECT category,
ROUND(SUM(sale),2) AS revenue,
ROUND(SUM(profit),2) AS profit,
COUNT(DISTINCT order_id) AS orders FROM db GROUP BY category ORDER BY profit DESC;

-- Region Profitability


SELECT region,
ROUND(SUM(sale),2) AS revenue,
ROUND(SUM(profit),2) AS profit,
COUNT(DISTINCT order_id) AS orders FROM db GROUP BY region ORDER BY profit DESC;


-- Segment * Category matrix (The Most Profitable Combination)

SELECT segment,category,
ROUND(SUM(sale),2) AS revenue,
ROUND(SUM(profit),2) AS profit,
COUNT(DISTINCT customer_id) AS orders FROM db GROUP BY segment,category ORDER BY profit DESC;



-- Customer Purches analysis (Top 10 Customers BY Revenue)

SELECT customer_name,segment,region,
COUNT(DISTINCT order_id) AS total_order,
ROUND(SUM(sale),2) AS lifetime_revenue,
ROUND(SUM(profit),2) AS lifetime_profit FROM db GROUP BY customer_name,segment,region ORDER BY lifetime_revenue DESC LIMIT 10;



-- 1. Динамика месячной выручки
SELECT
    DATE_TRUNC('month', invoice_date)::date AS month,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM sales
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY month;


-- 2. Выручка по странам
SELECT
    country,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM sales
GROUP BY country
ORDER BY total_revenue DESC;


-- 3. Доля каждой страны в общей выручке
SELECT
    country,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue,
    ROUND(
        SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER (),
        2
    ) AS revenue_share_percent
FROM sales
GROUP BY country
ORDER BY total_revenue DESC;


-- 4. Средний и медианный чек
WITH order_totals AS (
    SELECT
        invoice_no,
        SUM(revenue) AS order_revenue
    FROM sales
    GROUP BY invoice_no
)
SELECT
    ROUND(AVG(order_revenue)::numeric, 2) AS average_order_value,
    ROUND(PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY order_revenue)::numeric, 2
    ) AS median_order_value
FROM order_totals;


-- 5. Распределение заказов по стоимости
WITH order_totals AS (
    SELECT
        invoice_no,
        SUM(revenue) AS order_revenue
    FROM sales
    GROUP BY invoice_no
)
SELECT
    CASE
        WHEN order_revenue < 100 THEN 'Small (<100)'
        WHEN order_revenue < 500 THEN 'Medium (100-500)'
        WHEN order_revenue < 2000 THEN 'Large (500-2000)'
        ELSE 'Very Large (>=2000)'
    END AS order_category,
    COUNT(*) AS order_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM order_totals
GROUP BY order_category
ORDER BY MIN(order_revenue);

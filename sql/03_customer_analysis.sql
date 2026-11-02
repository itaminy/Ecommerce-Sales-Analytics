
-- 1. Общая статистика по клиентам
SELECT
    COUNT(*) AS total_customers,
    ROUND(AVG(total_revenue)::numeric, 2) AS average_customer_revenue,
    ROUND(AVG(total_orders)::numeric, 2) AS average_orders_per_customer
FROM customer_sales_summary;


-- 2. Топ-10 клиентов по выручке
SELECT
    customer_id,
    total_orders,
    ROUND(total_revenue::numeric, 2) AS total_revenue,
    ROUND(average_order_value::numeric, 2) AS average_order_value
FROM customer_sales_summary
ORDER BY total_revenue DESC
LIMIT 10;


-- 3. Доля клиентов, формирующих 80% выручки
WITH ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
        ) AS cumulative_revenue,
        SUM(total_revenue) OVER () AS overall_revenue
    FROM customer_sales_summary
),
customer_share AS (
    SELECT
        COUNT(*) FILTER (
            WHERE cumulative_revenue - total_revenue < overall_revenue * 0.8
        ) AS customers_for_80_percent,
        COUNT(*) AS total_customers
    FROM ranked_customers
)
SELECT
    customers_for_80_percent,
    total_customers,
    ROUND(
        customers_for_80_percent * 100.0 / total_customers,
        2
    ) AS customer_share_percent
FROM customer_share;


-- 4. Распределение клиентов по количеству заказов
SELECT
    CASE
        WHEN total_orders = 1 THEN '1 order'
        WHEN total_orders BETWEEN 2 AND 5 THEN '2-5 orders'
        WHEN total_orders BETWEEN 6 AND 10 THEN '6-10 orders'
        ELSE 'More than 10 orders'
    END AS customer_group,
    COUNT(*) AS customer_count
FROM customer_sales_summary
GROUP BY customer_group
ORDER BY MIN(total_orders);


-- 5. Клиенты с давней последней покупкой
SELECT
    customer_id,
    total_orders,
    ROUND(total_revenue::numeric, 2) AS total_revenue,
    last_purchase,
    recency_days
FROM customer_sales_summary
ORDER BY recency_days DESC
LIMIT 20;

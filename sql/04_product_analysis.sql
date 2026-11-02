
-- 1. Общая статистика по товарам
SELECT
    COUNT(*) AS total_products,
    SUM(total_quantity) AS total_quantity_sold,
    ROUND(SUM(total_revenue)::numeric, 2) AS total_revenue
FROM product_sales_summary;


-- 2. Топ-10 товаров по выручке
-- Исключаем аномальную операцию с товаром 23843
SELECT
    stock_code,
    product_name,
    total_quantity,
    total_orders,
    ROUND(total_revenue::numeric, 2) AS total_revenue
FROM product_sales_summary
WHERE stock_code <> '23843'
ORDER BY total_revenue DESC
LIMIT 10;


-- 3. Топ-10 товаров по количеству продаж
SELECT
    stock_code,
    product_name,
    total_quantity,
    total_orders,
    ROUND(total_revenue::numeric, 2) AS total_revenue
FROM product_sales_summary
WHERE stock_code <> '23843'
ORDER BY total_quantity DESC
LIMIT 10;


-- 4. Товары с наибольшей средней выручкой на заказ
SELECT
    stock_code,
    product_name,
    total_orders,
    ROUND(revenue_per_order::numeric, 2) AS revenue_per_order,
    ROUND(total_revenue::numeric, 2) AS total_revenue
FROM product_sales_summary
WHERE stock_code NOT IN ('23843', 'POST', 'DOT', 'M', 'D')
  AND total_orders >= 10
ORDER BY revenue_per_order DESC
LIMIT 10;


-- 5. Проверка аномальной операции
SELECT
    stock_code,
    product_name,
    total_quantity,
    total_orders,
    ROUND(total_revenue::numeric, 2) AS total_revenue
FROM product_sales_summary
WHERE stock_code = '23843';

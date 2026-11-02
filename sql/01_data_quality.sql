
-- 1. Общая информация о таблице
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT invoice_no) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT stock_code) AS unique_products
FROM sales;


-- 2. Проверка пропущенных значений
SELECT
    COUNT(*) FILTER (WHERE invoice_no IS NULL) AS missing_invoice,
    COUNT(*) FILTER (WHERE stock_code IS NULL) AS missing_stock_code,
    COUNT(*) FILTER (WHERE description IS NULL) AS missing_description,
    COUNT(*) FILTER (WHERE invoice_date IS NULL) AS missing_date,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer,
    COUNT(*) FILTER (WHERE country IS NULL) AS missing_country
FROM sales;


-- 3. Проверка дубликатов строк
SELECT
    invoice_no,
    stock_code,
    customer_id,
    invoice_date,
    quantity,
    unit_price,
    COUNT(*) AS duplicate_count
FROM sales
GROUP BY
    invoice_no,
    stock_code,
    customer_id,
    invoice_date,
    quantity,
    unit_price
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- 4. Проверка некорректных значений
SELECT
    COUNT(*) FILTER (WHERE quantity <= 0) AS invalid_quantity,
    COUNT(*) FILTER (WHERE unit_price <= 0) AS invalid_price,
    COUNT(*) FILTER (WHERE revenue <= 0) AS invalid_revenue
FROM sales;


-- 5. Период данных
SELECT
    MIN(invoice_date) AS first_date,
    MAX(invoice_date) AS last_date
FROM sales;

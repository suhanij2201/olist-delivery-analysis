-- Business question: Which product categories take longest from order
-- placement to customer delivery?
-- Joins four tables: orders carry no category, so the path is
-- orders -> order_items -> products -> category_translation (Portuguese to English)
-- Result: office_furniture averages 20.8 days against roughly 13 for every other category
SELECT
    t.product_category_name_english AS category,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(AVG(julianday(o.order_delivered_customer_date)
            - julianday(o.order_purchase_timestamp)), 1) AS avg_days_to_deliver
FROM orders o
JOIN order_items oi         ON o.order_id = oi.order_id
JOIN products p             ON oi.product_id = p.product_id
JOIN category_translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY category
HAVING orders >= 500
ORDER BY avg_days_to_deliver DESC
LIMIT 15;

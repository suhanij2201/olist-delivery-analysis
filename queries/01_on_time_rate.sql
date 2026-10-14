-- Business question: What proportion of delivered orders arrived on or before
-- the date the customer was promised?
-- Result: 96,470 delivered orders, 88,644 on time, 91.89% on-time rate
SELECT
    COUNT(*) AS delivered_orders,
    SUM(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date
             THEN 1 ELSE 0 END) AS on_time_orders,
    ROUND(100.0 * SUM(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date
                           THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_pct
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

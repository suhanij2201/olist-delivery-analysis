-- Business question: Is delivery performance improving or deteriorating over time?
-- Result: on-time rate fell from 94.7% to 85.7% in November 2017 as order volume
-- rose 63% (Black Friday). Months with very few orders in 2016 are excluded from charts.
SELECT
    strftime('%Y-%m', order_purchase_timestamp) AS month,
    COUNT(*) AS orders,
    ROUND(100.0 * SUM(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date
                           THEN 1 ELSE 0 END) / COUNT(*), 1) AS on_time_pct
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
GROUP BY month
ORDER BY month;

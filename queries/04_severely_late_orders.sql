-- Business question: Which orders missed the promised date by more than a week?
-- This is the list an ops team would work through.
-- Result: the worst cases are up to 188 days late, but many share one delivery
-- timestamp (e.g. 2017-09-19), which points to a bulk status update, not real delay
SELECT
    order_id,
    order_purchase_timestamp,
    order_estimated_delivery_date,
    order_delivered_customer_date,
    CAST(julianday(order_delivered_customer_date)
       - julianday(order_estimated_delivery_date) AS INTEGER) AS days_late
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND julianday(order_delivered_customer_date)
    - julianday(order_estimated_delivery_date) > 7
ORDER BY days_late DESC
LIMIT 50;

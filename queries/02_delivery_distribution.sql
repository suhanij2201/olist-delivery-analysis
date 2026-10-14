-- Business question: How is delivery performance distributed? Are misses
-- clustered near the promise date or are there severe outliers?
-- Result: 71,303 orders (73.9%) arrived 7+ days early; 2,862 were 8+ days late
SELECT
    CASE
        WHEN delay_days <= -7 THEN 'Early by 7+ days'
        WHEN delay_days < 0   THEN 'Early by 1-6 days'
        WHEN delay_days = 0   THEN 'On the estimated day'
        WHEN delay_days <= 7  THEN 'Late by 1-7 days'
        ELSE 'Late by 8+ days'
    END AS delivery_band,
    COUNT(*) AS order_count
FROM (
    SELECT CAST(julianday(order_delivered_customer_date)
              - julianday(order_estimated_delivery_date) AS INTEGER) AS delay_days
    FROM orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
)
GROUP BY delivery_band
ORDER BY order_count DESC;

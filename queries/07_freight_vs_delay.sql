-- Business question: Do orders with higher freight cost arrive more reliably?
-- Result: every band arrives 9 to 12 days early on average, with no consistent
-- pattern across a 4x difference in freight cost. A null result.
SELECT
    CASE
        WHEN oi.freight_value < 10 THEN 'Under 10'
        WHEN oi.freight_value < 20 THEN '10 to 20'
        WHEN oi.freight_value < 40 THEN '20 to 40'
        ELSE '40 and above'
    END AS freight_band,
    COUNT(*) AS order_lines,
    ROUND(AVG(julianday(o.order_delivered_customer_date)
            - julianday(o.order_estimated_delivery_date)), 2) AS avg_delay_days
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY freight_band
ORDER BY avg_delay_days DESC;

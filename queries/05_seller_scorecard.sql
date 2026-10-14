-- Business question: Which sellers have the worst on-time performance,
-- and how much revenue sits behind them?
-- The CTE collapses order_items to one row per order and seller first, so an
-- order with several items counts once (avoids fan-out in the on-time rate)
-- Result: one seller with 389 orders and R$36,098 revenue at 76.9% on time is
-- the largest revenue exposure among the 20 weakest sellers
WITH order_revenue AS (
    SELECT order_id, seller_id, SUM(price) AS revenue
    FROM order_items
    GROUP BY order_id, seller_id
)
SELECT
    s.seller_id,
    s.seller_state,
    COUNT(*) AS orders,
    ROUND(SUM(r.revenue), 2) AS revenue,
    ROUND(100.0 * SUM(CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
                           THEN 1 ELSE 0 END) / COUNT(*), 1) AS on_time_pct
FROM order_revenue r
JOIN orders o  ON r.order_id = o.order_id
JOIN sellers s ON r.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY s.seller_id, s.seller_state
HAVING orders >= 50
ORDER BY on_time_pct ASC
LIMIT 20;

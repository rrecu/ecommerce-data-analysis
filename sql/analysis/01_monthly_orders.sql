SELECT
  strftime('%Y-%m', o.order_purchase_timestamp) AS month,
  COUNT(DISTINCT o.order_id) AS order_count,
  ROUND(
    COALESCE(SUM(i.price), 0),
    2
  ) AS revenue,
  ROUND(
    COALESCE(SUM(i.price), 0) / COUNT(DISTINCT o.order_id),
    2
  ) AS avg_order_value
FROM orders AS o
LEFT JOIN order_items AS i
  ON o.order_id = i.order_id
WHERE order_status NOT IN ('canceled', 'unavailable')
GROUP BY month
ORDER BY month;

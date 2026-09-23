SELECT
  strftime('%Y-%m', o.order_delivered_customer_date) AS delivered_month,
  COUNT(DISTINCT o.order_id) AS order_count,
  ROUND(AVG(
    julianday(date(o.order_delivered_customer_date))
    - julianday(date(o.order_estimated_delivery_date))
  ), 1) AS avg_days_late,
  ROUND(100.0 * SUM(
    CASE WHEN date(o.order_delivered_customer_date)
      > date(o.order_estimated_delivery_date)
      THEN 1 ELSE 0 END
    ) / COUNT(*), 1) AS pct_days_late
FROM orders AS o
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
  AND o.order_status = 'delivered'
GROUP BY delivered_month
ORDER BY delivered_month;

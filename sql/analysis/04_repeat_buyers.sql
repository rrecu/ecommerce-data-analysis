WITH classified_orders AS (
  SELECT
    c.customer_id,
    c.customer_unique_id,
    o.order_id,
    o.order_purchase_timestamp,
    CASE
      WHEN o.order_purchase_timestamp > MIN(o.order_purchase_timestamp) OVER (
        PARTITION BY c.customer_unique_id
      )
      THEN 'repeat'
      ELSE 'first'
    END AS customer_type
  FROM customers AS c
  JOIN orders AS o
    ON c.customer_id = o.customer_id
  WHERE o.order_status NOT IN ('canceled', 'unavailable')
),
customer_type_summary AS (
  SELECT
    co.customer_type,
    COUNT(DISTINCT co.order_id) AS order_count,
    COALESCE(SUM(i.price), 0) AS revenue
  FROM classified_orders AS co
  LEFT JOIN order_items AS i
    ON co.order_id = i.order_id
  GROUP BY co.customer_type
)
SELECT
  cts.customer_type,
  cts.order_count,
  ROUND(
    100.0 * cts.order_count / SUM(cts.order_count) OVER (),
    1
  ) AS share_pct,
  ROUND(cts.revenue, 2) AS revenue
FROM customer_type_summary AS cts;

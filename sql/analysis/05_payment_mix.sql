WITH payment_summary AS (
  SELECT
    p.payment_type,
    COUNT(o.order_id) AS payment_count,
    SUM(p.payment_value) AS payment_value
  FROM orders AS o
  JOIN payments AS p
    ON o.order_id = p.order_id
  WHERE o.order_status NOT IN ('canceled', 'unavailable')
  GROUP BY p.payment_type
)
SELECT
  CASE ps.payment_type
    WHEN 'credit_card' THEN 'Credit card'
    WHEN 'boleto' THEN 'Boleto'
    WHEN 'voucher' THEN 'Voucher'
    WHEN 'debit_card' THEN 'Debit card'
    WHEN 'not_defined' THEN 'Not defined'
    ELSE ps.payment_type
  END AS payment_type,
  ps.payment_count,
  ROUND(
    100.0 * ps.payment_count / SUM(ps.payment_count) OVER (),
    2
  ) AS share_pct,
  ps.payment_value,
  ROUND(
    100.0 * ps.payment_value / SUM(ps.payment_value) OVER (),
    2
  ) AS value_pct,
  ROUND(
    ps.payment_value / ps.payment_count,
    2
  ) AS avg_payment
FROM payment_summary AS ps
ORDER BY value_pct DESC;

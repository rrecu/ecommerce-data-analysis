WITH latest_reviews AS (
  SELECT
    r.*,
    ROW_NUMBER() OVER (
      PARTITION BY order_id
      ORDER BY review_creation_date DESC
    ) AS row_num
  FROM reviews AS r
),
order_data AS (
  SELECT
    CASE
      WHEN julianday(date(o.order_delivered_customer_date))
        > julianday(date(o.order_estimated_delivery_date))
      THEN 'Late'
      ELSE 'On time'
    END AS delivery_status,
    julianday(date(o.order_delivered_customer_date))
      - julianday(date(o.order_estimated_delivery_date)) AS day_difference,
    r.review_score
  FROM orders as o
  JOIN latest_reviews as r
    ON o.order_id = r.order_id
    AND r.row_num = 1
  WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
    AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
  o.delivery_status,
  COUNT(*) AS order_count,
  ROUND(AVG(o.day_difference), 1) AS avg_day_difference,
  ROUND(AVG(o.review_score), 1) AS avg_review_score
FROM order_data AS o
GROUP BY delivery_status
ORDER BY CASE delivery_status WHEN 'On time' THEN 0 ELSE 1 END;

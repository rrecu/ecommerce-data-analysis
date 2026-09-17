# Data Dictionary

Olist Brazilian E-commerce dataset ([Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)). The raw CSV files are too large for GitHub, so download them from Kaggle if you want to run the notebooks yourself.

## olist_orders_dataset.csv

**About this table:** Main table, one row per order (99,441 rows). Most other tables join on `order_id`.

| Column | Type | Meaning | Notes |
|---|---|---|---|
| `order_id` | `text` | Order ID | Primary key |
| `customer_id` | `text` | Customer ID for this order | Joins to the customers table |
| `order_status` | `text` | Lifecycle status | `delivered`, `shipped`, `canceled`, `unavailable`, `invoiced`, `processing`, `created`, `approved` |
| `order_purchase_timestamp` | `text` | When the order was placed | |
| `order_approved_at` | `text` | Payment approval time | 160 rows are `null` (payment never approved) |
| `order_delivered_carrier_date` | `text` | Handed to carrier | 1783 rows are `null` - mostly orders that were never shipped |
| `order_delivered_customer_date` | `text` | Arrived at customer | 2965 rows are `null` - most never arrived, 8 are delivered despite `null` |
| `order_estimated_delivery_date` | `text` | Promised delivery estimate | No `null` rows |

**Notes:**

- The five date columns are actually timestamps stored as text (`2017-10-02 10:56:33`). Need to convert to datetime before date math
- `null` in delivery dates mostly means the order never reached that step (see `order_status` column), not random missing data
- 8 delivered orders have no delivery timestamp, exclude them from delay metrics

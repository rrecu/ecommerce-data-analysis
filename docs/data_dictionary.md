# Data Dictionary

Olist Brazilian E-commerce dataset ([Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)). The raw CSV files are too large for GitHub, so download them from Kaggle if you want to run the notebooks yourself.

## olist_orders_dataset.csv

**About this table:** Main table, one row per order (99,441 rows). Most other tables join on `order_id`.

| Column | Type | Meaning | Notes |
|---|---|---|---|
| `order_id` | `str` | Order ID | Primary key |
| `customer_id` | `str` | Customer ID for this order | Joins to the customers table |
| `order_status` | `str` | Lifecycle status | `delivered`, `shipped`, `canceled`, `unavailable`, `invoiced`, `processing`, `created`, `approved` |
| `order_purchase_timestamp` | `str` | When the order was placed | |
| `order_approved_at` | `str` | Payment approval time | 160 rows are `null` (payment never approved) |
| `order_delivered_carrier_date` | `str` | Handed to carrier | 1783 rows are `null` - mostly orders that were never shipped |
| `order_delivered_customer_date` | `str` | Arrived at customer | 2965 rows are `null` - most never arrived, 8 are delivered despite `null` |
| `order_estimated_delivery_date` | `str` | Promised delivery estimate | No `null` rows |

**Notes:**

- The five date columns are actually timestamps stored as `str` (`2017-10-02 10:56:33`). Need to convert to datetime before date math
- `null` in delivery dates mostly means the order never reached that step (see `order_status` column), not random missing data
- 8 delivered orders have no delivery timestamp, exclude them from delay metrics

## olist_order_items_dataset.csv

**About this table:** One row per item in an order (112650 rows, 98666 distinct orders). An order with several products appears on several rows.

| Column | Type | Meaning | Notes |
|---|---|---|---|
| `order_id` | `str` | Order this item belongs to | Joins to orders |
| `order_item_id` | `int64` | Item position in the order (1 = first) | Max 21 |
| `product_id` | `str` | Product bought | Joins to products |
| `seller_id` | `str` | Seller fulfilling the item | Joins to sellers |
| `shipping_limit_date` | `str` | Deadline for the seller to ship | Timestamp stored as `str` |
| `price` | `float64` | Item price (BRL) | Min 0.85, median 74.99, max 6735 |
| `freight_value` | `float64` | Delivery cost (BRL) | Separate from `price` |

**Notes:**

- No `null` in this table
- 775 orders from the orders table have no rows here, almost all `unavailable` or `canceled` (plus 1 `shipped`, looks wrong)
- Most orders have 1 item; average is slightly above 1

## olist_order_payments_dataset.csv

**About this table:** One row per payment for an order (103886 rows). Most orders have one payment, a few have several.

| Column | Type | Meaning | Notes |
|---|---|---|---|
| `order_id` | `str` | Order this payment belongs to | Joins to orders |
| `payment_sequential` | `int64` | Sequence number of this payment within the order | 1 = first payment |
| `payment_type` | `str` | How the order was paid | `credit_card`, `boleto`, `voucher`, `debit_card`, `not_defined` |
| `payment_installments` | `int64` | Number of card installments | Only meaningful for credit card |
| `payment_value` | `float64` | Amount paid (BRL) | |

**Notes:**

- No `null` in this table
- About 74% of payments are credit card. Boleto (Brazilian bank slip) is second at 19%
- About 97% of orders use a single payment row
- 103886 rows vs 99441 orders: some orders have more than one payment

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

- No `null` in this table, but 3 rows have `payment_type` set as `not_defined`
- About 74% of payments are made using a credit card. Boleto (Brazilian bank slip) is second at 19%
- 103886 payment rows vs 99441 orders: about 97% of orders have a single payment row, the rest use several

## olist_order_reviews_dataset.csv

**About this table:** One row per review (99224 rows). Most orders have at most one review row, but 547 orders have more than one.

| Column | Type | Meaning | Notes |
|---|---|---|---|
| `review_id` | `str` | Review ID | Some IDs appear on two or three orders |
| `order_id` | `str` | Order being reviewed | Joins to orders - 547 orders have multiple review rows |
| `review_score` | `int64` | Rating from 1 to 5 | Always filled |
| `review_comment_title` | `str` | Optional short title | 87656 `null` rows |
| `review_comment_message` | `str` | Optional comment text | 58247 `null` rows |
| `review_creation_date` | `str` | When the review was written | Date stored as `str` |
| `review_answer_timestamp` | `str` | When the store replied | Timestamp stored as `str` |

**Notes:**

- Score distribution: about 58% are 5, 19% are 4, 12% are 1, the rest are 2 and 3
- Score without any text is common. Title and message are both optional
- 547 orders have more than one review row with different `review_id`s and scores can differ. Pick one row per order for analysis or aggregate on purpose
- 768 orders have no review at all
- 764 review IDs appear twice and 25 appear three times (same score and text, different `order_id`s)

## olist_customers_dataset.csv

**About this table:** One row per order's customer record (99441 rows, same as orders). `customer_id` is unique per row, `customer_unique_id` is the same person across orders.

| Column | Type | Meaning | Notes |
|---|---|---|---|
| `customer_id` | `str` | Customer ID for this order | Primary key, joins to orders |
| `customer_unique_id` | `str` | The actual person | Repeats for repeat buyers - 3345 rows share an ID |
| `customer_zip_code_prefix` | `int64` | First digits of the postcode | Numeric, not a real number |
| `customer_city` | `str` | City | |
| `customer_state` | `str` | Brazilian state | Top: SP, RJ, MG |

**Notes:**

- No `null` in this table
- 96096 distinct people placed 99441 orders, so some customers came back
- Location is order-level: one person who ordered twice appears with two rows (city/state per order)

## olist_products_dataset.csv

**About this table:** One row per product (32951 rows). Items join to it via `product_id`.

| Column | Type | Meaning | Notes |
|---|---|---|---|
| `product_id` | `str` | Product ID | Primary key, joins to items |
| `product_category_name` | `str` | Category name in Portuguese | 610 `null`, 73 categories; translation table maps to English |
| `product_name_lenght` | `float64` | Number of characters in the product name | 610 `null` |
| `product_description_lenght` | `float64` | Number of characters in the description | 610 `null` |
| `product_photos_qty` | `float64` | Number of product photos | 610 `null` |
| `product_weight_g` | `float64` | Weight in grams | 2 `null`; min 0, median 700, max 40425 |
| `product_length_cm` | `float64` | Length in cm | 2 `null` |
| `product_height_cm` | `float64` | Height in cm | 2 `null` |
| `product_width_cm` | `float64` | Width in cm | 2 `null` |

**Notes:**

- The same 610 products miss category and all descriptive metadata fields together
- Number columns are `float64` instead of `int64` because of the `null` values
- Top categories: bed/bath/table, sports/leisure, furniture/decoration (Portuguese in the CSV)
- Every product in order items exists in this table (no orphan products in orders)
- Weights: most under 2 kg, a few very heavy ones pull the average to 2.28 kg

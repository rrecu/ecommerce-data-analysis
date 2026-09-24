# Findings

## Monthly orders grow 22x in two years

Orders grew from 293 in Oct (Sep has only 2 orders - excluded) 2016 to 6421 in Aug 2018, revenue from ~44k to ~849k BRL per month. November 2016 had zero orders (data starts spotty). Average order value drifts down slightly over time (~150 to ~132) as volume grows.

[Query: 01_monthly_orders.sql](../sql/analysis/01_monthly_orders.sql)

## Orders were generally delivered earlier than estimated

The average delivery gap improved from approximately 41 days early in late 2016 to around 8–12 days early during most of 2018. Estimates got tighter, or delivery slowed - accuracy improved toward the promise. Late deliveries increased toward the end of the period from ~0–3% late to ~6–7% late by 2018, last months show unusual spike: 2018-09/10 - 100% late but only 56/3 orders. These final-month results should be interpreted cautiously because they are based on very small samples.

[Query: 02_delivery_sla.sql](../sql/analysis/02_delivery_sla.sql)

## Late deliveries are rated around 2 points lower on average

Around 93% of orders (89,443) arrived on time, while approximately 7% (6,381) arrived late. The average review score for on-time deliveries was about 4.3/5, compared with 2.3/5 for late deliveries. On-time orders arrived on average about 14 days before the estimated date. However, other factors such as product quality or seller performance may also influence review scores.

[Query: 03_review_drivers.sql](../sql/analysis/03_review_drivers.sql)

## Only 3% of orders come from returning customers

Of all valid orders (98,207), only 3% (2,946) are from returning customers. Revenue from these repeat orders is ~368k BRL, about 2.7% of the total (13.49M). Average order value is 125 for repeat orders vs ~138 for first orders, so returning shoppers spend slightly less per order. The data covers only ~2 years, so some customers may have ordered again after it ends: 3% is a floor, not a ceiling.

[Query: 04_repeat_buyers.sql](../sql/analysis/04_repeat_buyers.sql)

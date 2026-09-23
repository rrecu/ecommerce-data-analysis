# Findings

## Monthly orders grow 22x in two years

Orders grew from 293 in Oct (Sep has only 2 orders - excluded) 2016 to 6421 in Aug 2018, revenue from ~44k to ~849k BRL per month. November 2016 had zero orders (data starts spotty). Average order value drifts down slightly over time (~150 to ~132) as volume grows.

[Query: 01_monthly_orders.sql](../sql/analysis/01_monthly_orders.sql)

## Orders were generally delivered earlier than estimated

The average delivery gap improved from approximately 41 days early in late 2016 to around 8–12 days early during most of 2018. Estimates got tighter, or delivery slowed - accuracy improved toward the promise. Late deliveries increased toward the end of the period from ~0–3% late to ~6–7% late by 2018, last months show unusual spike: 2018-09/10 - 100% late but only 56/3 orders. These final-month results should be interpreted cautiously because they are based on very small samples.

[Query: 02_delivery_sla.sql](../sql/analysis/02_delivery_sla.sql)

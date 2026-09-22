"""Load the Olist CSVs into a SQLite database."""
import sqlite3
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
DB = ROOT / "olist.db"

TABLES = {
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "payments": "olist_order_payments_dataset.csv",
    "reviews": "olist_order_reviews_dataset.csv",
    "customers": "olist_customers_dataset.csv",
    "products": "olist_products_dataset.csv",
    "sellers": "olist_sellers_dataset.csv",
    "category_translation": "product_category_name_translation.csv",
    "geolocation": "olist_geolocation_dataset.csv",
}

if DB.exists():
    DB.unlink()

conn = sqlite3.connect(DB)

for table, filename in TABLES.items():
    df = pd.read_csv(RAW / filename)
    df.to_sql(table, conn, index=False, if_exists="replace")
    print(f"{table}: {len(df)} rows")

conn.close()
print(f"Wrote {DB}")

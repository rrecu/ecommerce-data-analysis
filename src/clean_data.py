"""Clean and load the Olist CSVs into a SQLite database."""
import sqlite3
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
DB = ROOT / "olist_clean.db"

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

TIMESTAMP_COLUMNS = [
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date"
]

# Check every CSV exists before touching the old database
missing = [name for name in TABLES.values() if not (RAW / name).exists()]
if missing:
    raise SystemExit(f"Missing files in data/raw/: {', '.join(missing)}")

if DB.exists():
    DB.unlink()

conn = sqlite3.connect(DB)

for table, filename in TABLES.items():
    df = pd.read_csv(RAW / filename)

    # Convert TIMESTAMP_COLUMNS from text to real datetime
    for column in TIMESTAMP_COLUMNS:
        if column in df.columns:
            df[column] = pd.to_datetime(
                df[column],
                errors="coerce"
            )

    # Rename misspelled columns
    df = df.rename(columns={
        "product_name_lenght": "product_name_length",
        "product_description_lenght": "product_description_length"
    })

    # Change products with 0 weight to null
    if "product_weight_g" in df.columns:
        df.loc[df["product_weight_g"] == 0, "product_weight_g"] = None

    df.to_sql(table, conn, index=False, if_exists="replace")
    print(f"{table}: {len(df)} rows")

conn.close()
print(f"Wrote {DB}")

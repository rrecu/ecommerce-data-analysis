"""Sample the Olist SQLite database - seeded preview sample for the repo, not for analysis"""
import sqlite3
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "olist_clean.db"
OUT = ROOT / "data" / "processed" / "sample"
SEED = 42
SAMPLES = {
    "orders": 1000,
    "order_items": 1000,
    "payments": 1000,
    "reviews": 1000,
    "customers": 1000,
    "products": 1000,
    "sellers": 1000,
    "category_translation": None,
    "geolocation": 1000,
}

if not DB.exists():
    raise FileNotFoundError(f"Database not found: {DB}. Create using 'clean_data.py'")

OUT.mkdir(parents=True, exist_ok=True)
conn = sqlite3.connect(DB)

for table, n in SAMPLES.items():
    df = pd.read_sql_query(f"SELECT * FROM {table}", conn)
    if n is not None:
        df = df.sample(n=min(n, len(df)), random_state=SEED)
    df.to_csv(OUT / f"{table}.csv", index=False)
    print(f"{table}: {len(df)} rows")

conn.close()

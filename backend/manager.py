import sqlite3
import json
from contextlib import contextmanager

DB_PATH = "config.db"

def init_db():
    with get_conn() as conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS feature_flags (
                category TEXT NOT NULL,
                key TEXT NOT NULL,
                value TEXT NOT NULL,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (category, key)
            )
        """)

@contextmanager
def get_conn():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    try:
        yield conn
        conn.commit()
    finally:
        conn.close()

def load_all() -> dict:
    """Load entire DB into the in-memory dict shape."""
    with get_conn() as conn:
        rows = conn.execute("SELECT category, key, value FROM feature_flags").fetchall()
    result = {}
    for row in rows:
        if row["category"] not in result:
            result[row["category"]] = {}
        result[row["category"]][row["key"]] = json.loads(row["value"])
    return result

def upsert(category: str, key: str, value: dict):
    with get_conn() as conn:
        conn.execute("""
            INSERT INTO feature_flags (category, key, value)
            VALUES (?, ?, ?)
            ON CONFLICT(category, key) DO UPDATE SET
                value=excluded.value,
                updated_at=CURRENT_TIMESTAMP
        """, (category, key, json.dumps(value)))

def seed(data: dict):
    """Bulk insert from seed payload."""
    for category, keys in data.items():
        for key, value in keys.items():
            upsert(category, key, value)